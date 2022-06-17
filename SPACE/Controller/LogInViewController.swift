//
//  LogInViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/14.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var addAccountButton: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    func setupViews() {
        
        adressTextField.borderStyle = .roundedRect
        adressTextField.layer.cornerCurve = .continuous
        adressTextField.layer.cornerRadius = adressTextField.bounds.height / 2
        adressTextField.layer.masksToBounds = true
        adressTextField.delegate = self
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerCurve = .continuous
        passwordTextField.layer.cornerRadius = passwordTextField.bounds.height / 2
        passwordTextField.layer.masksToBounds = true
        passwordTextField.delegate = self
        
        loginButton.layer.cornerCurve = .continuous
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        adressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if passwordTextField.text == "" || adressTextField.text == "" {
            
            emptyAlert()
            return
        }
        
        FirebaseAPI.shared.checkUser(userID: adressTextField.text!, completionHandler:  { data in
            
            if data is NSNull {
                
                self.nullAlert()
            }else {
                
                self.loginManager(data: data as! NSDictionary)
            }
        })
    }
    
    @IBAction func createAccountButtonPressed() {
        
        performSegue(withIdentifier: "toAgreementView", sender: nil)
    }
    
    func emptyAlert() {
        
        let alert = UIAlertController(title: "エラー", message: "すべての項目に入力してください", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func nullAlert() {
    
        let alert = UIAlertController(title: "エラー", message: "ユーザーが見つかりません", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func errorAlert() {
        
        let alert = UIAlertController(title: "エラー", message: "パスワードが間違っています", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func loginManager(data: NSDictionary) {
        
        if data["password"] as? String ?? "" == passwordTextField.text {
            
            UserDefaults.standard.set(adressTextField.text, forKey: "userID")
            dismiss(animated: true)
        }else {
            
            errorAlert()
        }
    }
}
