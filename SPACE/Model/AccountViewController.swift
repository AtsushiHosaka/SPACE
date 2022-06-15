//
//  AccountViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/15.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var pastButton: UIButton!
    
    var posts = [Post]() {
        
        didSet {
            
            loadingAlert.dismiss(animated: true)
            
            posts.reverse()
            
            collectionView.reloadData()
        }
    }
    
    var mode: Int = 1
    
    var selectedCellNum: Int = 0
    
    let loadingAlert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initButton()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getFavoritePosts()
    }
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupCollectionView() {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let collectionLayout = UICollectionViewFlowLayout()
        
        collectionLayout.minimumInteritemSpacing = self.view.bounds.width * 15 / 390
        collectionLayout.minimumLineSpacing = self.view.bounds.width * 22 / 390
        
        collectionLayout.sectionInset = UIEdgeInsets(
            top:    self.view.bounds.width * 16 / 390,
            left:   self.view.bounds.width * 14 / 390,
            bottom: self.view.bounds.width * 16 / 390,
            right:  self.view.bounds.width * 14 / 390
        )
        
        collectionLayout.itemSize = CGSize(
            width:  self.view.bounds.width * 166 / 390,
            height: self.view.bounds.width * 221 / 390
        )

        collectionView.collectionViewLayout = collectionLayout
        
        collectionView.backgroundColor = nil
    }
    
    func initButton() {
        
        favoriteButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
        pastButton.tintColor = UIColor(white: 153 / 255, alpha: 1)
    }
    
    @IBAction func changeMode(_ sender: UIButton) {
        
        if sender.tag == 1 {
            
            if mode == 2 {
                
                mode = 1
                favoriteButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
                pastButton.tintColor = UIColor(white: 153 / 255, alpha: 1)
                
                getFavoritePosts()
            }
        }else {
            
            if mode == 1 {
                
                mode = 2
                favoriteButton.tintColor = UIColor(white: 153 / 255, alpha: 1)
                pastButton.tintColor = UIColor(white: 252 / 255, alpha: 1)
                
                getPastPosts()
            }
        }
    }
    
    func getFavoritePosts() {
        
        present(loadingAlert, animated: true)
        
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        FirebaseAPI.shared.readPostsFromFireBase(path: "User/" + userID + "/favorites", completionHandler: { data in
            
            if data is NSNull || data == nil {
                
                print("error")
            }else {
                
                let parsedData = data as! NSDictionary
                
                self.posts = PostManager.shared.parseArray(parsedData: parsedData)
            }
        })
    }
    
    func getPastPosts() {
        
        present(loadingAlert, animated: true)
        
        let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
        FirebaseAPI.shared.readPostsFromFireBase(path: "User/" + userID + "/Posts", completionHandler: { data in
            
            if data is NSNull || data == nil {
                
                print("error")
            }else {
                
                let parsedData = data as! NSDictionary
                
                self.posts = PostManager.shared.parseArray(parsedData: parsedData)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAccountPostsView" {
            
            let accountPostsView: AccountPostsViewController = segue.destination as! AccountPostsViewController
            
            accountPostsView.posts = self.posts
            accountPostsView.currentPostNum = self.selectedCellNum
            accountPostsView.mode = self.mode
        }
    }
}

extension AccountViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! AccountCollectionViewCell
        
        cell.imageView.image = posts[indexPath.row].photoData
        
        return cell
    }
}

extension AccountViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedCellNum = indexPath.row
        performSegue(withIdentifier: "toAccountPostsView", sender: nil)
    }
}
