//
//  ProductListResponse.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/22/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  API response for product list
//

import Foundation

extension BasicAPI
{
    struct ProductListResponse: JsonDecodable {
        var success: Bool
        var products: [String: [Product]]
    }
    
    // JSON for product info
    struct Product: JsonDecodable
    {
        var id: Int
        var name: String
        var watsonClassifier: String
        var countryName: String
        var countryCode: String
        
        enum CodingKeys: String, CodingKey {
            case id = "product_id"
            case name = "product_name"
            case watsonClassifier = "watson_classifier_id"
            case countryName = "country_name"
            case countryCode = "country_code"
        }
    }
}
