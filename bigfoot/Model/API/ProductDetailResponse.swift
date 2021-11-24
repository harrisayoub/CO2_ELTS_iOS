//
//  ProductDetailResponse.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  The JSON response for getting product details
//

import Foundation

extension BasicAPI
{
    struct ProductDetailResponse: JsonDecodable {
        var success: Bool
        var message: String
        var product: ProductDetail
        
        enum CodingKeys: String, CodingKey {
            case success = "success"
            case message = "message"
            case product = "product_detail"
        }
    }
}
