//
//  AccountCollectionViewCell.swift
//  SPACE
//
//  Created by 保坂篤志 on 2022/06/15.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 12.0
        self.layer.cornerCurve = .continuous
    }
}
