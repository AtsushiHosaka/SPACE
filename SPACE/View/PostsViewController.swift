//
//  PostsViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/05/22.
//

import UIKit

class PostsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var posts = [Post]() {
        
        didSet {
            
            loadingAlert.dismiss(animated: true)
            
            if !posts.isEmpty {
                
                posts.reverse()
                showPost(post: posts[currentPostNum])
            }
        }
    }
    
    var currentPostNum: Int = 0
    
    var isShowingDescription: Bool = false
    
    var constellationName: String = ""
    var constellationID: String = ""
    
    var likePostsID = [String]()
    var favoritePostsID = [String]()
    
    var userID: String = ""
    
    var loadingAlert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        getUserID()
        getLikePosts()
        getFavoritePosts()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializePost()
    }
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.title = constellationName
        
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
        
        present(loadingAlert, animated: true)
        
        PostManager.shared.getPosts(path: "Post/" + constellationID, completionHandler: { data in
            
            self.posts = data
        })
    }
    
    func getUserID() {
        
        userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    }
    
    func getLikePosts() {
        
        likePostsID = (UserDefaults.standard.array(forKey: "likes" + userID) ?? [String]()) as! [String]
    }
    
    func getFavoritePosts() {
        
        favoritePostsID = (UserDefaults.standard.array(forKey: "favorites" + userID) ?? [String]()) as! [String]
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        likeButton.tintColor = UIColor(red: 1, green: 0, blue: 167 / 255, alpha: 1)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        PostManager.shared.addLike(post: posts[currentPostNum])
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        
        if !favoritePostsID.contains(posts[currentPostNum].postID) {
            
            favoriteButton.tintColor = UIColor(red: 1, green: 245 / 255, blue: 0, alpha: 1)
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
            PostManager.shared.addFavorite(userID: userID, post: posts[currentPostNum])
        }
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
        
        getLikePosts()
        getFavoritePosts()
        
        if likePostsID.contains(post.postID) {
            
            likeButton.tintColor = UIColor(red: 1, green: 0, blue: 167 / 255, alpha: 1)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            
            likeButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        if favoritePostsID.contains(post.postID) {
            
            favoriteButton.tintColor = UIColor(red: 1, green: 245 / 255, blue: 0, alpha: 1)
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else {
            
            favoriteButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
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
