//
//  MakePostViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/05/22.
//

import UIKit
import SwiftDate

class MakePostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    var selectedTag: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUI()
    }
    
    func setupUI() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        imageView.image = UIImage(named: "unselected.png")
        
        selectedTag = -1
    }
    
    func setupViews() {
        
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "説明を入力",
                                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 153 / 255, alpha: 1)])
        descriptionTextField.delegate = self
        
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 10
        
        imageButton.setTitle("", for: .normal)
        
        tagButton.layer.cornerCurve = .continuous
        tagButton.layer.cornerRadius = tagButton.bounds.height / 2
        tagButton.setTitle("  タグを選択  ", for: .normal)
        
        var actions = [UIAction]()
        for i in 0 ..< PostManager.shared.tagName.count {
            
            actions.append(UIAction(title: PostManager.shared.tagName[i], handler: { _ in
                
                self.updateTagButton(num: i)
                self.selectedTag = i
            }))
        }
        tagButton.menu = UIMenu(title: "", children: actions)
        tagButton.showsMenuAsPrimaryAction = true
        
        nextButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Rounded M+ 2m", size: 17.0)!], for: .normal)
    }
    
    func updateTagButton(num: Int) {
        
        tagButton.setTitle("  ＃" + PostManager.shared.tagName[num] + "  ", for: .normal)
    }
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        
        presentPickerController(sourceType: .photoLibrary)
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        if imageView.image == nil {
            
            let alert = UIAlertController(title: "画像を選択してください", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alert, animated: true)
        }else if selectedTag == -1 {
            
            let alert = UIAlertController(title: "タグを選択してください", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            present(alert, animated: true)
        }else {
            
            performSegue(withIdentifier: "toAddPostToConstellationView", sender: nil)
        }
    }
    
    func presentPickerController(sourceType: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true, completion: nil)
        imageView.image = info[.originalImage] as? UIImage
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        descriptionTextField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toAddPostToConstellationView" {
        
            let addPostToConstellationView: AddPostToConstellationViewController = segue.destination as! AddPostToConstellationViewController
            
            let date = Date()
            guard let userID = UserDefaults.standard.string(forKey: "userID") else { return }
            
            addPostToConstellationView.post = Post(postID: UUID().uuidString,
                                                   userID: userID,
                                                   photoData: imageView.image!,
                                                   date: String(date.year) + "/" + String(date.month) + "/" + String(date.day),
                                                   tag: selectedTag,
                                                   description: descriptionTextField.text!)
        }
    }
}
