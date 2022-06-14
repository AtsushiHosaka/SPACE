//
//  ViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/05/22.
//

import UIKit

class SelectConstellationViewController: UIViewController {

    @IBOutlet weak var constellationButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
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
}
