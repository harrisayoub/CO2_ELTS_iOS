//
//  AboutViewController.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController
{
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var buildNumberLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") {
            versionNumberLabel.text = "\(version)"
        }
        
        if let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") {
            buildNumberLabel.text = "\(build)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
