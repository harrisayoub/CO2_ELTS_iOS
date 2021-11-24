//
//  CountryListResponse.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/20/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  API response for the list of countries that have products
//

import Foundation

extension BasicAPI
{
    // Main response
    struct CountryListResponse: JsonDecodable {
        var success: Bool
        var countries: [Country]
    }
    
    // The JSON for a single country
    struct Country: JsonDecodable {
        var id: Int
        var name: String
        var code: String
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case code = "iso_code"
        }
    }
}
