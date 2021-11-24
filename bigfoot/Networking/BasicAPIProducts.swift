//
//  BasicAPIProducts.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Contains API calls related to products
//

import Foundation

extension BasicAPI
{
    // Get list of countries that have products
    func countryListWithProducts(callback: @escaping (CountryListResponse?, BasicAPIError?) -> Void)
    {
        let url = urlForEndpoint(endpoint: .countryList)
        
        NetworkingManager.shared.request(url: url, method: .get, parameters: [:]) { (response, error) in
            if let data = response
            {
                if let countryListResponse = CountryListResponse(data: data) {
                    callback(countryListResponse, nil)
                }
                else {
                    print("Failed to convert response into format.")
                    callback(nil, BasicAPIError.parseError)
                }
            }
            else {
                callback(nil, self.parsedError(error: error!))
            }
        }
    }
    
    // Get list of products arranged by their classifier
    func products(callback: @escaping (ProductListResponse?, BasicAPIError?) -> Void)
    {
        let url = urlForEndpoint(endpoint: .productsList)
        
        NetworkingManager.shared.request(url: url, method: .get, parameters: [:]) { (response, error) in
            if let data = response
            {
                if let productListResponse = ProductListResponse(data: data) {
                    callback(productListResponse, nil)
                }
                else {
                    print("Failed to convert response into format.")
                    callback(nil, BasicAPIError.parseError)
                }
            }
            else {
                callback(nil, self.parsedError(error: error!))
            }
        }
    }
    
    // Get product details for the given product id and user location
    func productDetails(productID: Int, userLocationISOCode: String, callback: @escaping (ProductDetailResponse?, BasicAPIError?) -> Void)
    {
        let url = urlForEndpoint(endpoint: .productDetail)
        let params: [String: Any] = ["product_id": productID, "api_key": API_KEY, "user_location_iso_code": userLocationISOCode]
        
        NetworkingManager.shared.request(url: url, method: .get, parameters: params) { (response, error) in
            if let data = response
            {
                if let detailResponse = ProductDetailResponse(data: data) {
                    callback(detailResponse, nil)
                }
                else {
                   callback(nil, BasicAPIError.parseError)
                }
            }
            else {
                callback(nil, self.parsedError(error: error!))
            }
        }
    }
}
