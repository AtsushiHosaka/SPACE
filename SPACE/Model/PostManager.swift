//
//  PostManager.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/04.
//

import UIKit

class PostManager {
    
    static let shared = PostManager()
    
    let tagName = ["旅行", "散歩"]
    
    func getPosts(path: String, completionHandler: @escaping ([Post]) -> Void) {
        
        FirebaseAPI.shared.readPostsFromFireBase(path: path, completionHandler: { data in
            
            if data is NSNull || data == nil {
                
                print("error")
                completionHandler([Post]())
                
            }else {
            
                let parsedData = data as! NSDictionary
                
                let posts = self.parseArray(parsedData: parsedData)
                
                completionHandler(posts)
            }
        })
    }
    
    func parseArray(parsedData: NSDictionary) -> [Post] {
        
        let keys = parsedData.allKeys as! [String]
        
        var posts = [Post]()
        
        for key in keys {
            
            let postData = parsedData[key] as! NSDictionary
            
            FirebaseAPI.shared.getImage(url: postData["photoURL"] as! String, completionHandler: { image in
                
                var post = Post(postID: postData["postID"] as! String,
                                userID: postData["userID"] as! String,
                                photoData: image!,
                                date: postData["date"] as! String,
                                tag: postData["tag"] as! Int,
                                description: postData["description"] as! String)
                
                post.photoURL = postData["photoURL"] as! String
                
                post.likes = postData["likes"] as! Int
                
                posts.append(post)
            })
        }
        
        return posts
    }
    
    func getTags(constellation: String, completionHandler: @escaping (Int) -> Void) {
        
        FirebaseAPI.shared.readTagsFromFireBase(constellation: constellation, completionHandler: { data in
            
            if data is NSNull || data == nil {
                
                print("error")
                completionHandler(0)
                
            }else {
            
                let parsedData = data as! NSDictionary
                let keys = parsedData.allKeys as! [String]
                print(parsedData)
                var tag = 0
                var max = 0
                
                for key in keys {
                    
                    var postData = parsedData[key] as! NSDictionary
                    
                    //if postData.va
//                    FirebaseAPI.shared.getImage(url: postData["photoURL"] as! String, completionHandler: { image in
//
//                        let post = Post(postID: postData["postID"] as! String,
//                                        userID: postData["userID"] as! String,
//                                        photoData: image!,
//                                        date: postData["date"] as! String,
//                                        tag: postData["tag"] as! Int,
//                                        description: postData["description"] as! String)
//
//                        posts.append(post)
//                    })
                    
                    
                    
                }
                
                //completionHandler(posts)
            }
        })
    }
    
    func addLike(post: Post) {
        
        FirebaseAPI.shared.addLike(post: post)
        
        let userID = post.userID
        let postID = post.postID
        
        if let arrayData = UserDefaults.standard.array(forKey: "likes" + userID) {
            
            var array = arrayData as! [String]
            array.append(postID)
            UserDefaults.standard.set(array, forKey: "likes" + userID)
        }else {
            
            let array = [postID]
            UserDefaults.standard.set(array, forKey: "likes" + userID)
        }
    }
    
    func addFavorite(userID: String, post: Post) {
        
        FirebaseAPI.shared.addFavorite(userID: userID, post: post)
        
        let postID = post.postID
        
        if let arrayData = UserDefaults.standard.array(forKey: "favorites" + userID) {
            
            var array = arrayData as! [String]
            array.append(postID)
            UserDefaults.standard.set(array, forKey: "favorites" + userID)
        }else {
            
            let array = [postID]
            UserDefaults.standard.set(array, forKey: "favorites" + userID)
        }
    }
}
