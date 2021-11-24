//
//  Footprint.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Contains JSON models for footprint data
//

import Foundation

extension BasicAPI
{
    // Represents the JSON of a footprint value
    struct FootprintValue: JsonDecodable
    {
        var id: Int
        var name: String
        var originalValue: Double
        var footprintValue: Double
        var reference: String?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case originalValue = "original_value"
            case footprintValue = "footprint_value"
            case reference = "reference"
        }
    }
    
    // Represents the JSON of the transportation footprint info
    struct TransportFootprint: JsonDecodable
    {
        var value: Double
        var mode: String
        
        enum CodingKeys: String, CodingKey {
            case value = "footprint_value"
            case mode = "transportation_mode"
        }
    }
}
