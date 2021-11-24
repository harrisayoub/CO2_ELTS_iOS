//
//  JsonMapping.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/26/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Contains extensions for mapping decodable / encodable responses into json
//

import Foundation

protocol JsonDecodable: Decodable {
    init?(data: Data)
}

// Support decoding from json data into decodable types
extension JsonDecodable
{
    init?(data: Data)
    {
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        }
        catch {
            if let string = String(data: data, encoding: .utf8) {
                print("Failed to decode json: \(string)")
                print(error)
            }
            return nil
        }
    }
}
