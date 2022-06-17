//
//  AddNewAccountViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/14.
//

import UIKit

class AddNewAccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        
        userIDTextField.borderStyle = .roundedRect
        userIDTextField.layer.cornerCurve = .continuous
        userIDTextField.layer.cornerRadius = userIDTextField.bounds.height / 2
        userIDTextField.layer.masksToBounds = true
        userIDTextField.delegate = self
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerCurve = .continuous
        passwordTextField.layer.cornerRadius = passwordTextField.bounds.height / 2
        passwordTextField.layer.masksToBounds = true
        passwordTextField.delegate = self
        
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.layer.cornerCurve = .continuous
        confirmPasswordTextField.layer.cornerRadius = confirmPasswordTextField.bounds.height / 2
        confirmPasswordTextField.layer.masksToBounds = true
        confirmPasswordTextField.delegate = self
        
        createButton.layer.cornerCurve = .continuous
        createButton.layer.cornerRadius = createButton.bounds.height / 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        userIDTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func createButtonPressed(_ sender: Any) {
        
        if userIDTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            
            if passwordTextField.text! == confirmPasswordTextField.text! {
            
                FirebaseAPI.shared.checkUser(userID: userIDTextField.text!, completionHandler:  { data in
                    
                    if data is NSNull {
                        
                        FirebaseAPI.shared.addUser(userID: self.userIDTextField.text!, password: self.passwordTextField.text!)
                        UserDefaults.standard.set(self.userIDTextField.text!, forKey: "userID")
                        
                        self.navigationController?.popToRootViewController(animated: true)
                    }else {
                        
                        self.existAlert()
                    }
                })
            }else {
                
                self.missAlert()
            }
        }else {
            
            self.emptyAlert()
        }
    }
    
    
    
    func emptyAlert() {
        
        let alert = UIAlertController(title: "エラー", message: "すべての項目に入力してください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func existAlert() {
        
        let alert = UIAlertController(title: "エラー", message: "すでにこのIDは使われています", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func missAlert() {
        
        let alert = UIAlertController(title: "エラー", message: "パスワードが異なります", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
}
