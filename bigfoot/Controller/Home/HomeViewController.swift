//
//  HomeViewController.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/1/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  The home view controller responsible for getting the user's data and setting the location
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate
{
    // MARK:- Outlets and Properties
    
    @IBOutlet weak var locationButton: RoundedButton!
    @IBOutlet weak var loaderView: LoaderView!
    
    fileprivate var locationManager = CLLocationManager()
    fileprivate var location = DataManager.currentLocation {
        didSet {
            locationButton.setTitle(location != nil ? location!.city : "LOCATION NOT SET", for: .normal)
        }
    }
    
    fileprivate var countries: [BasicAPI.Country]? = nil
    
    fileprivate let SEGUE_TO_SCAN_VC = "Segue To Scan VC"
    
    // MARK:- Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // first time load - so determine user's location through device location services
        if location == nil {
            determineUserLocation()
        }
        else {
            locationButton.setTitle(location!.city, for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- Location
    
    // Start tracking the user's location and determine location information for the user
    fileprivate func determineUserLocation()
    {
        locationButton.isEnabled = false
        
        loaderView.message = "Determining your location"
        loaderView.isLoadingActive = true
        
        locationManager.delegate = self
        
        // request permission if not granted
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // User accepted / rejected location services
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        // if user denied location services hide loader and show error message
        if status == .denied || status == .restricted {
            loaderView.isLoadingActive = false
            locationButton.isEnabled = true
            presentOkAlertWithTitle("Location Denied", andMessage: "You have denied location services. Please enter your location manually.")
            return
        }
        
        if status == .authorizedWhenInUse {
            // user authorized - get location
            locationManager.requestLocation()
        }
        else {
            print("User did not grant permission to use location services")
        }
    }
    
    // Location manager recived updates on user's location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let location = locations.first
        {
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                if let placemark = placemarks?.first {
                    self?.loaderView.isLoadingActive = false
                    DataManager.setUserLocationFromPlacemark(placemark)
                    self?.location = DataManager.currentLocation
                    self?.locationButton.isEnabled = true
                }
            }
        }
    }
    
    // Location manager failed to determine location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        loaderView.isLoadingActive = false
        print("Location manager failed to determine location: \(error.localizedDescription)")
        requestUserForLocation()
    }
    
    // Request user for location manually
    fileprivate func requestUserForLocation()
    {
        // ask user to input location through textfield
        let ac = UIAlertController(title: "Enter Location", message: "Failed to determine your location. Please enter your location manually.", preferredStyle: .alert)
        
        // textfield for city
        ac.addTextField { (textField) in
            textField.placeholder = "City"
            textField.tag = 0
        }
        
        // textfield for country
        ac.addTextField { (textField) in
            textField.placeholder = "Country"
            textField.tag = 1
        }
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let city = ac.textFields![0].text!
            let country = ac.textFields![1].text!
            DataManager.setUserLocationFromCity(city, andCountry: country)
            self.location = DataManager.currentLocation
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    // MARK:- Other
    
    // Fetch country list
    fileprivate func downloadCountryList(callback: @escaping () -> Void)
    {
        loaderView.message = "Getting country list"
        loaderView.isLoadingActive = true
        
        BasicAPI.shared.countryListWithProducts { [weak self] (response, error) in
            self?.loaderView.isLoadingActive = false
            if let countryListResponse = response {
                self?.countries = countryListResponse.countries
                callback()
            }
            else {
                self?.showErrorForAPIError(error: error!)
            }
        }
    }
    
    // MARK:- Events
    
    // User taps on the scan button to proceed to next VC
    @IBAction func scanButtonTapped(_ sender: UIButton)
    {
        // verify location has been set
        if location == nil {
            presentOkAlertWithTitle("Location Not Set", andMessage: "Your location has not been set. Please tap on the button below to set your location.")
            return
        }
        
        // verify country list is downloaded
        if countries != nil {
            performSegue(withIdentifier: SEGUE_TO_SCAN_VC, sender: nil)
        }
        else {
            downloadCountryList {
                self.performSegue(withIdentifier: self.SEGUE_TO_SCAN_VC, sender: nil)
            }
        }
    }
    
    // User tapped on the location button to determine location
    @IBAction func locationButtonTapped(_ sender: RoundedButton)
    {
        // check if location already determined
        if location != nil
        {
            let ac = UIAlertController(title: "Location Set", message: "Your location is already set to: \(location!.city). Do you want to determine the location again?", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                self.determineUserLocation()
            }))
            
            ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            present(ac, animated: true, completion: nil)
        }
        else
        {
            // location not set - user denied location services so request location manually
            if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
                requestUserForLocation()
            }
        }
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let scanVC = segue.destination as? ProduceScanViewController {
            scanVC.countries = self.countries!
        }
    }
}
