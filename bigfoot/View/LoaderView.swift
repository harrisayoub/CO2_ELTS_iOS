//
//  LoaderView.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/10/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Custom UIView that displays the activity indicator and a message
//

import UIKit

class LoaderView: UIView
{
    // MARK:- Properties
    
    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate var messageLabel: UILabel!
    
    fileprivate let DEFAULT_SPACING: CGFloat = 8.0
    
    var backgroundViewColor = UIColor.black.withAlphaComponent(0.6) {
        didSet {
            self.backgroundColor = backgroundColor
        }
    }
    
    var textColor = UIColor.white {
        didSet {
            if let messageLabel = self.messageLabel {
                messageLabel.textColor = textColor
            }
        }
    }
    
    var spinnerColor = UIColor.white {
        didSet {
            if let spinner = self.spinner {
                spinner.color = spinnerColor
            }
        }
    }
    
    var viewCornerRadius: CGFloat = 12.0 {
        didSet {
            self.layer.cornerRadius = viewCornerRadius
        }
    }
    
    var message = "" {
        didSet {
            if let messageLabel = self.messageLabel {
                messageLabel.text = message
            }
        }
    }
    
    var isLoadingActive = false {
        didSet {
            if isLoadingActive {
                self.isHidden = false
                spinner.startAnimating()
            }
            else {
                self.isHidden = true
                spinner.stopAnimating()
            }
        }
    }
    
    // MARK:- Setup
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    // Build the view
    fileprivate func setupView()
    {
        // initially hidden
        self.isHidden = true
        
        // spinner in the center
        spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // rounded corners for view and background color
        layer.cornerRadius = viewCornerRadius
        self.backgroundColor = backgroundViewColor
        
        // message label and constraints
        messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.textAlignment = .center
        messageLabel.textColor = self.textColor
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(messageLabel)
        
        messageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: DEFAULT_SPACING).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: DEFAULT_SPACING).isActive = true
        messageLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: DEFAULT_SPACING).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: DEFAULT_SPACING).isActive = true
    }
}
