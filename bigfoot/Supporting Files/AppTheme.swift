//
//  AppTheme.swift
//  bigfoot
//
//  Created by Asad Ahmed on 5/27/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Contains constants and functions related to app ui theme settings
//

import UIKit

class AppTheme
{
    // Main colours used throughout the app
    struct Colors {
        static let mainGreen = UIColor(rgb: 0x12B4A0)
        static let secondaryGreen = UIColor(rgb: 0x6FC87B)
        static let textColor1 = UIColor(rgb: 0x2B362D)
        static let textColor2 = UIColor(rgb: 0x535A54)
    }
    
    // Apply system-wide theme
    static func applyTheme()
    {
        let appearance = UINavigationBar.appearance()
        
        // nav bar
        appearance.tintColor = UIColor.white
        appearance.barTintColor = Colors.mainGreen
        
        // nav bar title
        appearance.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
}
