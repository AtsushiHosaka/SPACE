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
    
    var constellationNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PostManager.shared.getTags(constellation: "aries", completionHandler: { data in
            
        })
        
        loginCheck()
        
        setupViews()
        changeConstellation(direction: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    func loginCheck() {
        
        if UserDefaults.standard.string(forKey: "userID") == nil {
            
            performSegue(withIdentifier: "toLogInView", sender: nil)
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
        
        constellationNum += direction
        if constellationNum >= 12 {
            
            constellationNum -= 12
        }
        if constellationNum < 0 {
            
            constellationNum += 12
        }
        
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
