//
//  ProductTableViewCell.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/22/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Custom table view cell for displaying products
//

import UIKit

class ProductTableViewCell: UITableViewCell
{
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImageView.tintColor = AppTheme.Colors.mainGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
