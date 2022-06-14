//
//  AddPostToConstellationViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/05.
//

import UIKit

class AddPostToConstellationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var post = Post(postID: "", userID: "", photoData: UIImage(), date: "", tag: 0, description: "")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setupUI()
    }
    
    func setupViews() {
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
    func setupUI() {
        
        imageView.image = post.photoData
    }
    
    @IBAction func swipeUP(_ sender: Any) {
        
        sendNewPost()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            
            self.imageView.center.y -= 370
            self.imageView.alpha = 0
            
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func sendNewPost() {
        
        FirebaseAPI.shared.addPostToFireBase(constellation: "test", post: post)
    }
}
