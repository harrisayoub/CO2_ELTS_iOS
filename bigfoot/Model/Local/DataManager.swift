//
//  DataManager.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/1/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Manages the retreival and storage of data throughout the app
//

import Foundation
import CoreLocation

class DataManager
{
    fileprivate static let DEFAULTS_KEY_LOCATION = "kUserLocationData"
    
    // Represents location information
    struct UserLocation : Codable
    {
        var city: String
        var country: String
        var countryCode: String
        
        // Standard constructor
        init(city: String, country: String, countryCode: String) {
            self.city = city
            self.country = country
            self.countryCode = countryCode
        }
        
        // Construct from CLPlacemark
        init(placemark: CLPlacemark) {
            self.city = placemark.locality != nil ? placemark.locality! : ""
            self.country = placemark.country != nil ? placemark.country! : ""
            self.countryCode = placemark.isoCountryCode != nil ? placemark.isoCountryCode! : ""
        }
    }
    
    // The current location of the user
    static var currentLocation: UserLocation? {
        get {
            if let locationData = UserDefaults.standard.data(forKey: DEFAULTS_KEY_LOCATION) {
                if let location = try? JSONDecoder().decode(UserLocation.self, from: locationData) {
                    return location
                }
                else {
                    print("Failed to decode location data")
                }
            }
            return nil
        }
        set {
            if let location = newValue {
                if let locationData = try? JSONEncoder().encode(location) {
                    UserDefaults.standard.set(locationData, forKey: DEFAULTS_KEY_LOCATION)
                }
                else {
                    print("Failed to encode location data")
                }
            }
        }
    }
    
    // Set current location from CLPlacemark
    static func setUserLocationFromPlacemark(_ placemark: CLPlacemark) {
        let location = UserLocation(placemark: placemark)
        currentLocation = location
    }
    
    // Set location from city and country
    static func setUserLocationFromCity(_ city: String, andCountry country: String) {
        let location = UserLocation(city: city, country: country, countryCode: "-")
        currentLocation = location
    }
}
