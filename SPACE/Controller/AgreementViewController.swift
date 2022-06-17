//
//  AgreementViewController.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/18.
//

import UIKit

class AgreementViewController: UIViewController {
    
    @IBOutlet var agreeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        agreeButton.layer.cornerCurve = .continuous
        agreeButton.layer.cornerRadius = agreeButton.bounds.height / 2
    }
    
    @IBAction func agreeButtonPressed() {
        
        performSegue(withIdentifier: "toAddNewAccountView", sender: nil)
    }

}
