//
//  bigfootTests.swift
//  bigfootTests
//
//  Created by Asad Ahmed on 5/27/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//

import XCTest
@testable import bigfoot

class bigfootTests: XCTestCase
{
    // Test encoding and decoding of data
    func testLocationDataEncodeAndDecode()
    {
        let location = DataManager.UserLocation(city: "Sharjah", country: "UAE", countryCode: "AE")
        DataManager.currentLocation = location
        
        let locationFromDisk = DataManager.currentLocation
        assert(locationFromDisk != nil)
        
        assert(locationFromDisk!.city == location.city)
        assert(locationFromDisk!.country == location.country)
        assert(locationFromDisk!.countryCode == location.countryCode)
    }
    
    // Test networking stack for making http requests and obtaining JSON
    func testNetworkingStack()
    {
        let url = "http://thebigfootproject.org/laravel_test/api/test"
        let params = ["count": 3]
        
        let promise = XCTestExpectation()
        
        NetworkingManager.shared.request(url: url, method: .get, parameters: params) { (response, error) in
            XCTAssert(response != nil)
            XCTAssert(error == nil)
            
            let string = String(data: response!, encoding: String.Encoding.utf8)!
            XCTAssert(string.count > 0)
            XCTAssert(string.contains("success"))
            
            promise.fulfill()
        }
    }
    
    // Test API for analyzing an image
    func testAnalyzeImageAPI()
    {
        let image = #imageLiteral(resourceName: "Test Image Apple")
        let data = UIImageJPEGRepresentation(image, 0.9)
        
        let promise = XCTestExpectation()
        
        BasicAPI.shared.analyzeImage(imageData: data!, countryOfOriginCode: "SE", userLocationCode: "AE") { (response, error) in
            XCTAssert(response != nil)
            XCTAssert(error == nil)
            XCTAssert(response!.success == true)
            XCTAssert(response!.productionFootprint != nil)
            XCTAssert(response!.transportationFootprint != nil)
            promise.fulfill()
        }
    }
    
    // Test API for getting country list
    func testCountryListAPI()
    {
        let promise = XCTestExpectation()
        
        BasicAPI.shared.countryListWithProducts { (response, error) in
            XCTAssert(response != nil)
            XCTAssert(error == nil)
            XCTAssert(response!.success == true)
            XCTAssert(response!.countries.count > 0)
        }
    }
}
