//
//  AddPostToConstellationViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/05.
//

import UIKit

class AddPostToConstellationViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var constellationNameLabel: UILabel!
    @IBOutlet weak var constellationImageView: UIImageView!
    
    var post = Post(postID: "", userID: "", photoData: UIImage(), date: "", tag: 0, description: "", constellation: "")
    
    var constellationNum: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        setupUI()
        changeConstellation(direction: 0)
    }
    
    func setupViews() {
        
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
    func setupUI() {
        
        imageView.image = post.photoData
    }
    
    @IBAction func swipeUP(_ sender: Any) {
        post.constellation = Constellation.shared.constellationID[constellationNum]
        
        sendNewPost()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            
            self.imageView.center.y -= 370
            self.imageView.alpha = 0
            
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: Any) {
        
        changeConstellation(direction: -1)
    }
    
    @IBAction func rightButtonPressed(_ sender: Any) {
        
        changeConstellation(direction: 1)
    }
    
    func sendNewPost() {
        
        FirebaseAPI.shared.addPostToFireBase(constellation: Constellation.shared.constellationID[constellationNum], post: post)
        
        FirebaseAPI.shared.updateTag(constellation: Constellation.shared.constellationID[constellationNum], tag: post.tag)
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
        
        constellationImageView.image = UIImage(named: Constellation.shared.constellationID[constellationNum])
        constellationNameLabel.text = Constellation.shared.constellationName[constellationNum]
    }
}
