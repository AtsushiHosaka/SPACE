//
//  Post.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/03.
//

import Foundation
import UIKit

struct Post {
    
    var postID: String = ""
    var userID: String = ""
    var photoURL: String = ""
    var photoData: UIImage = UIImage()
    var date: String = ""
    var tag: Int = 0
    var description: String = ""
    var likes: Int = 0
    
    init(postID: String, userID: String, photoData: UIImage, date: String, tag: Int, description: String) {
        
        self.postID = postID
        self.userID = userID
        self.photoData = photoData
        self.date = date
        self.tag = tag
        self.description = description
    }
}
