//
//  ProductDetail.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Represents the product detail JSON
//

import Foundation

extension BasicAPI
{
    struct ProductDetail: JsonDecodable
    {
        var id: Int
        var name: String
        var watsonClassifier: String
        var countryName: String
        var countryCode: String
        var continentalTransportMode: String
        var interContinentalTransportMode: String
        var sustainabilityIndex: Double?
        var productionFootprint: [FootprintValue]?
        var transportationFootprint: TransportFootprint?
        
        enum CodingKeys: String, CodingKey
        {
            case id = "product_id"
            case name = "product_name"
            case watsonClassifier = "watson_classifier_id"
            case countryName = "country_name"
            case countryCode = "country_code"
            case continentalTransportMode = "product_transportation_mode_continental"
            case interContinentalTransportMode = "product_transportation_mode_inter_continental"
            case sustainabilityIndex = "sustainability_index"
            case productionFootprint = "production_footprint"
            case transportationFootprint = "transportation_footprint"
        }
    }
}
