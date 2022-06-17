//
//  AccountPostsViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/15.
//

import UIKit

class AccountPostsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var trashButton: UIBarButtonItem!
    
    var posts = [Post]()
    
    var currentPostNum: Int = 0
    
    var isShowingDescription: Bool = false
    
    var constellationName: String = ""
    
    var likePostsID = [String]()
    var favoritePostsID = [String]()
    
    var userID: String = ""
    
    var mode: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
        updateTitle()
        getUserID()
        getLikePosts()
        getFavoritePosts()
        
        showPost(post: posts[currentPostNum])
    }
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.title = constellationName
        
        dateLabel.alpha = 0
        tagLabel.alpha = 0
        descriptionLabel.alpha = 0
        
        if mode == 2 {
            
            trashButton.isEnabled = true
            trashButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
        }else {
            
            trashButton.isEnabled = false
            trashButton.tintColor = UIColor.clear
        }
    }
    
    func setupViews() {
        
        imageView.frame = CGRect(x: 0, y: 115, width: self.view.bounds.width, height: self.view.bounds.width * 1.59)
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
    }
    
    func updateTitle() {
        
        if mode == 1 {
            
            self.title = "お気に入り"
        }else {
            
            self.title = "過去の投稿"
        }
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
    
    @IBAction func trashButtonPressed() {
        
        let alert = UIAlertController(title: "この投稿を削除しますか？", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
            
            self.removePost()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .default))
        
        present(alert, animated: true)
    }
    
    func removePost() {
        
        FirebaseAPI.shared.removePost(post: posts[currentPostNum])
        
        posts.remove(at: currentPostNum)
        currentPostNum = 0
        
        if !posts.isEmpty {
            
            showPost(post: posts[currentPostNum])
        }
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
        
        if post.likes > 0 && mode == 2 {
            
            likeCountLabel.isHidden = false
            likeCountLabel.text = "x" + String(post.likes)
            
            likeButton.tintColor = UIColor(red: 1, green: 0, blue: 167 / 255, alpha: 1)
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }else {
            
            likeCountLabel.isHidden = true
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
