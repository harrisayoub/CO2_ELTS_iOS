//
//  NetworkingManager.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/18/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Manager class for making HTTP requests
//

import Foundation
import Alamofire

class NetworkingManager
{
    // Singleton
    private init() {}
    static let shared = NetworkingManager()
    
    // Represents a file data param for a multipart form data request
    struct FileDataParam {
        var paramName: String
        var fileName: String
        var data: Data
    }
    
    // Make a http request and obtain the response as generic data
    func request(url: String, method: HTTPMethod, parameters: [String: Any], callback: @escaping (Data?, Error?) -> Void)
    {
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.methodDependent).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { (response) in
                if response.result.isSuccess {
                    callback(response.result.value!, response.error)
                }
                else {
                    callback(nil, response.error!)
                }
        }
    }
    
    // Make a multipart form upload request
    func multipartFormUploadRequest(url: String, method: HTTPMethod, parameters: [String: String], files: [FileDataParam], callback: @escaping (Data?, Error?) -> Void)
    {
        Alamofire.upload(multipartFormData: { (formData) in
            // add params
            for (key, value) in parameters
            {
                if let data = value.data(using: .utf8) {
                    formData.append(data, withName: key)
                }
                else {
                    print("Failed to convert param to data for uploading in a form data request: \(value)")
                }
            }
            
            // add files as multi-part file request
            for file in files {
                formData.append(file.data, withName: file.paramName, fileName: file.fileName, mimeType: self.mimeTypeFromFilename(filename: file.fileName))
            }
            // validate and get result from making the request
        }, to: url) { (encodingResult) in
            switch encodingResult {
            case .success(let request, _, _):
                request.responseData(completionHandler: { (responseData) in
                    callback(responseData.data, responseData.error)
                })
            case .failure(let error):
                callback(nil, error)
            }
        }
    }
    
    // Returns the mime type string for the given filename
    fileprivate func mimeTypeFromFilename(filename: String) -> String
    {
        let components = filename.split(separator: ".")
        if components.count == 2 {
            if let type = MimeType.all[String(components.last!)] {
                return type
            }
        }
        
        return MimeType.defaultType
    }
}
