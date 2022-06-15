//
//  ViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/05/22.
//

import UIKit

class SelectConstellationViewController: UIViewController {

    @IBOutlet weak var constellationNameLabel: UILabel!
    @IBOutlet weak var constellationButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var tagLabel: UILabel!
    
    var constellationNum: Int = 0
    
    var tags = [Int]() {
        
        didSet {
            
            if tags.count == Constellation.shared.constellationName.count {
                
                changeConstellation(direction: 0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginCheck()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        constellationNameLabel.text = ""
        
        setupUI()
        
        getTags()
    }
    
    func loginCheck() {
        
        if UserDefaults.standard.string(forKey: "userID") == nil {
            
            performSegue(withIdentifier: "toLogInView", sender: nil)
        }
    }
    
    func getTags() {
        
        tags = [Int]()
        
        for constellation in Constellation.shared.constellationID {
            
            PostManager.shared.getTags(constellation: constellation, completionHandler: { data in
                
                self.tags.append(data)
            })
        }
    }
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupViews() {
        
        postButton.layer.cornerRadius = postButton.bounds.height / 2
    }
    
    func setTabBarImages(index: Int, image: String, selectedImage: String) {
        
        let item = tabBarController?.tabBar.items![index]
        let image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        
        item?.image = image
        item?.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
    }
    
    @IBAction func constellationButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toPostsView", sender: nil)
    }
    
    @IBAction func makePostButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "toMakePostView", sender: nil)
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        
        changeConstellation(direction: -1)
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        changeConstellation(direction: 1)
    }
    
    func changeConstellation(direction: Int) {
        
        let maxNum = Constellation.shared.constellationName.count
        
        constellationNum += direction
        if constellationNum >= maxNum {
            
            constellationNum -= maxNum
        }
        if constellationNum < 0 {
            
            constellationNum += maxNum
        }
        
        tagLabel.text = "＃" + PostManager.shared.tagName[tags[constellationNum]]
        constellationNameLabel.text = Constellation.shared.constellationName[constellationNum]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toPostsView" {
            
            let postsView: PostsViewController = segue.destination as! PostsViewController
            
            postsView.constellationName = Constellation.shared.constellationName[constellationNum]
            postsView.constellationID = Constellation.shared.constellationID[constellationNum]
        }
    }
}
