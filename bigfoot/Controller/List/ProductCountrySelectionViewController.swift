//
//  ProductCountrySelectionViewController.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  View controller responsible for selecting a country of a given product to view its SI
//

import UIKit

class ProductCountrySelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK:- Outlets and Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // The internal struct used by this VC to store countries and the corresponding product of that country
    struct Country {
        var productID: Int
        var name: String
        var code: String
    }
    
    // The list of products of the same class in different countries. Must be set by the pushing VC.
    var products: [BasicAPI.Product]!
    
    // The name of the classifier. Must be set by the pushing VC.
    var classifier: String!
    
    // The processed array of countries sorted by country names
    fileprivate var countries = [Country]()
    
    // MARK:- Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // sort and process the countries set by the pushing VC
        for product in products {
            countries.append(Country(productID: product.id, name: product.countryName, code: product.countryCode))
        }
        countries.sort(by: { return $0.name < $1.name })
        
        // vc title
        navigationItem.title = classifier.capitalized
    }
    
    // MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country Cell", for: indexPath) as! CountryTableViewCell
        let country = countries[indexPath.row]
        
        cell.countryFlagImageView.image = UIImage(named: country.code.lowercased())
        cell.countryNameLabel.text = country.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "To Product Detail VC", sender: indexPath)
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // to product detail VC
        if let productDetailVC = segue.destination as? ProductDetailViewController
        {
            if let indexPath = sender as? IndexPath {
                let country = countries[indexPath.row]
                productDetailVC.productID = country.productID
                
                if let image = UIImage(named: classifier) {
                    productDetailVC.productImage = image.withRenderingMode(.alwaysTemplate)
                }
            }
        }
    }
}
