//
//  RoundedButton.swift
//  Encryption
//
//  Created by Kunal Kumar on 2020-05-03.
//  Copyright © 2020 KD inc. All rights reserved.
//

import Foundation

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    @IBInspectable var buttonBackgroundColor: UIColor = UIColor.red {
        didSet {
            sharedInit()
        }
    }
    
    @IBInspectable var isPrimaryButton: Bool = false {
        didSet {
            sharedInit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        self.layer.cornerRadius = self.frame.size.height / 2.0
        self.layer.borderWidth = 1.0
        
        if self.isPrimaryButton {
            self.backgroundColor = self.buttonBackgroundColor
            self.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.backgroundColor = UIColor.white
            self.setTitleColor(self.buttonBackgroundColor, for: .normal)
        }
        self.layer.borderColor = self.buttonBackgroundColor.cgColor
    }
}

