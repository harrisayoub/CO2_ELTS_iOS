//
//  BasicAPI.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/26/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  The API for the Basic Backend system. Contains functionality for making API calls and parsing the results
//

import Foundation
import Alamofire

class BasicAPI
{
    // Singleton
    private init() {}
    static let shared = BasicAPI()
    
    // URLs and constants
    let SERVER_URL = "https://thebigfootproject.org"
    let API_ROOT = "/basic/api/"
    let API_KEY = "D8D0CEF7-0285-4144-A762-963248AE6F31"
    
    // Error types
    enum BasicAPIErrorType {
        case noConnection
        case timedOut
        case serverError
        case parseError
        case encodingFailure
    }
    
    // Error wrapper
    struct BasicAPIError
    {
        var errorMessage: String
        var errorType: BasicAPIErrorType
        
        static var parseError: BasicAPIError {
            get {
                return BasicAPIError(errorMessage: "Failed to parse response JSON", errorType: .parseError)
            }
        }
    }
    
    // Endpoint enum
    enum Endpoint: String {
        case analyzeImage = "product/analyze"
        case countryList = "product/country_list"
        case productsList = "product/list"
        case productDetail = "product/detail"
    }
    
    // Returns the URL for the endpoint
    func urlForEndpoint(endpoint: Endpoint) -> String {
        let url = "\(SERVER_URL)\(API_ROOT)\(endpoint.rawValue)"
        return url
    }
    
    // Analyze the given image data
    func analyzeImage(imageData: Data, countryOfOriginCode: String, userLocationCode: String, callback: @escaping (BasicImageAnalysisResponse?, BasicAPIError?) -> Void)
    {
        let url = urlForEndpoint(endpoint: .analyzeImage)
        let params = ["api_key": API_KEY, "product_origin_country_iso_code": countryOfOriginCode.trimmingCharacters(in: .whitespacesAndNewlines), "user_location_iso_code": userLocationCode]
        let filename = UUID().uuidString + ".jpg"
        let files = [NetworkingManager.FileDataParam(paramName: "image_file", fileName: filename, data: imageData)]
        
        NetworkingManager.shared.multipartFormUploadRequest(url: url, method: .post, parameters: params, files: files) { (response, error) in
            if let data = response
            {
                if let basicResponse = BasicImageAnalysisResponse(data: data) {
                    callback(basicResponse, nil)
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
    
    // Parses the swift error into a more useful error
    func parsedError(error: Error) -> BasicAPIError
    {
        if let urlError = error as? URLError
        {
            switch urlError.code
            {
            case URLError.notConnectedToInternet:
                fallthrough
            case URLError.networkConnectionLost:
                return BasicAPIError(errorMessage: "Not connected to the internet", errorType: .noConnection)
                
            case URLError.timedOut:
                return BasicAPIError(errorMessage: "Connection timed out", errorType: .timedOut)
                
            default:
                return BasicAPIError(errorMessage: "Server Error", errorType: .serverError)
            }
        }
        
        return BasicAPIError(errorMessage: "Server Error", errorType: .serverError)
    }
}
