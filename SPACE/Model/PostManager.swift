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
    
    var likePosts = [String]()
    var favoritePosts = [String]()
    
    func getPosts(constellation: String, completionHandler: @escaping ([Post]) -> Void) {
        
        FirebaseAPI.shared.readPostsFromFireBase(path: constellation, completionHandler: { data in
            
            if data is NSNull {
                
                print("error")
                completionHandler([Post]())
                
            }else {
                
                let parsedData = data as! NSDictionary
                let keys = parsedData.allKeys as! [String]
                
                var posts = [Post]()
                
                for key in keys {
                    
                    let postData = parsedData[key] as! NSDictionary
                    
                    FirebaseAPI.shared.getImage(url: postData["photoURL"] as! String, completionHandler: { image in
                        
                        let post = Post(postID: postData["postID"] as! String,
                                        userID: postData["userID"] as! String,
                                        photoData: image!,
                                        date: postData["date"] as! String,
                                        tag: postData["tag"] as! Int,
                                        description: postData["description"] as! String)
                        
                        posts.append(post)
                    })
                }
                
                completionHandler(posts)
            }
        })
    }
    
    func getLikePosts(userID: String) {
        
        
    }
    
    func getFavoritePosts(userID: String) {
        
        
    }
}
