//
//  ProduceScanViewBuilder.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/11/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  View builder responsible for building UI for the footprint UI
//

import Foundation
import UIKit

class FootprintViewBuilder
{
    // MARK:- Public API
    
    // Adds the following data points UI to the stack view
    static func setDataPointsForStackView(stackView: UIStackView, dataPoints: [BasicAPI.FootprintValue])
    {
        // remove previous views if any
        for subView in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subView)
            subView.removeFromSuperview()
        }
        
        // add stack views
        for dataPoint in dataPoints {
            let itemStackView = stackViewForDataPoint(dataPoint: dataPoint)
            stackView.addArrangedSubview(itemStackView)
        }
        
        stackView.layoutIfNeeded()
    }
    
    // MARK:- Private Functions
    
    // Builds a stack view for a single data point item
    fileprivate static func stackViewForDataPoint(dataPoint: BasicAPI.FootprintValue) -> UIStackView
    {
        let stackView = UIStackView()
        
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        
        let pointNameLabel = UILabel()
        pointNameLabel.textColor = AppTheme.Colors.textColor1
        pointNameLabel.text = dataPoint.name
        
        let pointValueNameLabel = UILabel()
        pointValueNameLabel.textColor = AppTheme.Colors.textColor2
        pointValueNameLabel.text = String(format: "%.8f CO2 Eq.", dataPoint.footprintValue)
        
        stackView.addArrangedSubview(pointNameLabel)
        stackView.addArrangedSubview(pointValueNameLabel)
        
        return stackView
    }
}
