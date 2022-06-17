//
//  FireBaseAPI.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/05.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

struct FirebaseAPI {
    
    static let shared = FirebaseAPI()
    
    private var ref = Database.database().reference()
    
    private var imageRef = Storage.storage().reference()
    
    func readPostsFromFireBase(path: String, completionHandler: @escaping (Any?) -> Void) {
        
        ref.child(path).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            completionHandler(value)
            
        }) { error in
            
            print(error.localizedDescription)
        }
    }
    
    func getImage(url: String, completionHandler: @escaping (UIImage?) -> Void) {
        
        do {
            
            let data = try Data(contentsOf: URL(string: url)!)
            completionHandler(UIImage(data: data)!)
            
        } catch let error {
            
            print("Error : \(error.localizedDescription)")
        }
    }
    
    func addPostToFireBase(constellation: String, post: Post) {
        
        guard let data = post.photoData.jpegData(compressionQuality: 0.2) else {
            
            return
        }
        
        let imageIDRef = imageRef.child("gs://space-e3be6.appspot.com").child(post.postID)
        
        let uploadTask = imageIDRef.putData(data)
        
        uploadTask.observe(.success) { _ in
            
            imageIDRef.downloadURL { url, error in
                
                if let url = url {
                    
                    let downloadURL: String = url.absoluteString
                    
                    self.ref.child("Post").child(constellation).child(post.postID).updateChildValues(["postID": post.postID,
                                                                                                      "userID": post.userID,
                                                                                                      "photoURL": downloadURL,
                                                                                                      "date": post.date,
                                                                                                      "tag": post.tag,
                                                                                                      "description": post.description,
                                                                                                      "likes": post.likes,
                                                                                                      "constellation": post.constellation])
                    
                    self.ref.child("User").child(post.userID).child("Posts").child(post.postID).updateChildValues(["postID": post.postID,
                                                                                                                   "userID": post.userID,
                                                                                                                   "photoURL": downloadURL,
                                                                                                                   "date": post.date,
                                                                                                                   "tag": post.tag,
                                                                                                                   "description": post.description,
                                                                                                                   "likes": post.likes,
                                                                                                                   "constellation": post.constellation])
                }
            }
        }
    }
    
    func checkUser(userID: String, completionHandler: @escaping (Any?) -> Void) {
        
        ref.child("User").child(userID).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value
            
            completionHandler(value)
            
        }) { error in
            
            print(error.localizedDescription)
        }
    }
    
    func addUser(userID: String, password: String) {
        
        ref.child("User").child(userID).updateChildValues(["password": password])
    }
    
    func addFavorite(userID: String, post: Post) {
        
        ref.child("User").child(userID).child("favorites").child(post.postID).updateChildValues(["postID": post.postID,
                                                                                                 "userID": post.userID,
                                                                                                 "photoURL": post.photoURL,
                                                                                                 "date": post.date,
                                                                                                 "tag": post.tag,
                                                                                                 "description": post.description,
                                                                                                 "likes": post.likes,
                                                                                                 "constellation": post.constellation])
    }
    
    func addLike(post: Post) {
        
        ref.child("User").child(post.userID).child("Posts").child(post.postID).child("likes").observeSingleEvent(of: .value, with: { snapshot in
            
            let value = (snapshot.value ?? 0) as! Int
            
            self.ref.child("User").child(post.userID).child("Posts").child(post.postID).updateChildValues(["likes": value + 1])
        })
    }
    
    func updateTag(constellation: String, tag: Int) {
        
        ref.child("Constellation").child(String(constellation)).child(String(tag)).observeSingleEvent(of: .value, with: { snapshot in
            
            if snapshot.value is NSNull {
                
                self.ref.child("Constellation").child(String(constellation)).updateChildValues([String(tag): 1])
            }else {
                
                let value = snapshot.value as! Int
                self.ref.child("Constellation").child(String(constellation)).updateChildValues([String(tag): value + 1])
            }
        })
    }
    
    func readTagsFromFireBase(constellation: String, completionHandler: @escaping (Any?) -> Void) {
        
        ref.child("Constellation").child(constellation).observeSingleEvent(of: .value, with: { snapshot in
            
            let value = snapshot.value as? NSDictionary
            
            completionHandler(value)
            
        }) { error in
            
            print(error.localizedDescription)
        }
    }
    
    func flagPost(date: String, postID: String) {
        
        ref.child("Report").child(date).updateChildValues([postID: postID])
    }
    
    func removePost(post: Post) {
        
        ref.child("Post").child(post.constellation).child(post.postID).removeValue()
        ref.child("User").child(post.userID).child("Posts").child(post.postID).removeValue()
    }
}
