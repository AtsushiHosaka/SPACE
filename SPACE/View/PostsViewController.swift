//
//  PostsViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/05/22.
//

import UIKit

class PostsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var posts = [Post]() {
        
        didSet {
            
            posts.reverse()
            showPost(post: posts[currentPostNum])
        }
    }
    
    var currentPostNum: Int = 0
    
    var isShowingDescription: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        test()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        initializePost()
    }
    
    func test() {
        
        backgroundImageView.isHidden = true
    }
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        dateLabel.alpha = 0
        tagLabel.alpha = 0
        descriptionLabel.alpha = 0
    }
    
    func setupViews() {
        
        imageView.frame = CGRect(x: 0, y: 115, width: self.view.bounds.width, height: self.view.bounds.width * 1.59)
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
    }
    
    func initializePost() {
        
        currentPostNum = 0
        
        PostManager.shared.getPosts(constellation: "test", completionHandler: { data in
            
            self.posts = data
        })
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        likeButton.tintColor = UIColor(red: 1, green: 0, blue: 167 / 255, alpha: 1)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        favoriteButton.tintColor = UIColor(red: 1, green: 245 / 255, blue: 0, alpha: 1)
        favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    @IBAction func swipeUP(_ sender: Any) {
        
        if !isShowingDescription {
            
            isShowingDescription = true
            showDescription()
        }
    }
    
    @IBAction func swipeDOWN(_ sender: Any) {
        
        if isShowingDescription {
            
            isShowingDescription = false
            hideDescription()
        }
    }
    
    @IBAction func swipeRIGHT(_ sender: Any) {
        
        currentPostNum -= 1
        if currentPostNum < 0 {
            
            currentPostNum += posts.count
        }
        
        showPost(post: posts[currentPostNum])
    }
    
    @IBAction func swipeLEFT(_ sender: Any) {
        
        currentPostNum += 1
        if currentPostNum >= posts.count {
            
            currentPostNum = 0
        }
        
        showPost(post: posts[currentPostNum])
    }
    
    func showPost(post: Post) {
        
        imageView.image = post.photoData
        dateLabel.text = post.date
        tagLabel.text = "＃" + PostManager.shared.tagName[post.tag]
        descriptionLabel.text = post.description
        
        likeButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        
        favoriteButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
    }
    
    func showDescription() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            
            self.imageView.frame = CGRect(x: self.view.bounds.width * 0.08, y: self.imageView.frame.minY - 11, width: self.imageView.bounds.width * 0.84, height: self.imageView.bounds.height * 0.84)
            self.dateLabel.alpha = 1
            self.tagLabel.alpha = 1
            self.descriptionLabel.alpha = 1
        }, completion: nil)
    }
    
    func hideDescription() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            
            self.imageView.frame = CGRect(x: 0, y: 115, width: self.view.bounds.width, height: self.view.bounds.width * 1.59)
            self.dateLabel.alpha = 0
            self.tagLabel.alpha = 0
            self.descriptionLabel.alpha = 0
        }, completion: nil)
        
        
    }
}
