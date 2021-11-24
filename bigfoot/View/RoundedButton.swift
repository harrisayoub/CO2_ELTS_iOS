//
//  RoundedButton.swift
//  bigfoot
//
//  Created by Asad Ahmed on 5/27/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Custom rounded button
//

import UIKit

@IBDesignable
class RoundedButton : UIButton
{
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var outlineColor: UIColor = UIColor.black {
        didSet {
            self.layer.borderColor = outlineColor.cgColor
        }
    }
    
    @IBInspectable
    var fillColor: UIColor = UIColor.white {
        didSet {
            self.backgroundColor = fillColor
        }
    }
    
    @IBInspectable
    var textColor: UIColor = UIColor.black {
        didSet {
            self.setTitleColor(textColor, for: .normal)
        }
    }
    
    @IBInspectable
    var outlineWidth: CGFloat = 1.0 {
        didSet {
            self.layer.borderWidth = outlineWidth
        }
    }
}
