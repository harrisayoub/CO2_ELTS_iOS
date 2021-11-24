//
//  BasicImageAnalysisResponse.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/26/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  The image response for performing an image analysis
//

import Foundation

extension BasicAPI
{    
    // The main image analysis response
    struct BasicImageAnalysisResponse: JsonDecodable
    {
        var success: Bool
        var message: String
        var productID: Int?
        var productName: String?
        var sustainabilityIndex: Double?
        var productionFootprint: [FootprintValue]?
        var transportationFootprint: TransportFootprint?
        
        enum CodingKeys: String, CodingKey {
            case success = "success"
            case message = "message"
            case productID = "product_id"
            case productName = "product_name"
            case sustainabilityIndex = "sustainability_index"
            case productionFootprint = "production_footprint"
            case transportationFootprint = "transportation_footprint"
        }
    }
}
