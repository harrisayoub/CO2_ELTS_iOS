//
//  ProductListViewController.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/22/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  View controller responsible for displaying list of products in the database
//

import UIKit

class ProductListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    // MARK:- Outlets and Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loaderView: LoaderView!
    
    fileprivate var products = [String: [BasicAPI.Product]]()
    
    // MARK:- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProductList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // UI setup
    fileprivate func setupUI() {
        navigationItem.title = "Product List"
    }
    
    // Load product list
    fileprivate func loadProductList()
    {
        loaderView.message = "Downloading Products"
        loaderView.isLoadingActive = true
        
        BasicAPI.shared.products { [weak self] (response, error) in
            self?.loaderView.isLoadingActive = false
            if let productListResponse = response {
                self?.products = productListResponse.products
                self?.tableView.reloadData()
            }
            else {
                self?.showErrorForAPIError(error: error!)
            }
        }
    }
    
    // MARK:- Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Product Cell", for: indexPath) as! ProductTableViewCell
        let classifier = classifierForIndexPath(indexPath)
        
        // image built from classifier ID
        if let image = UIImage(named: classifier) {
            cell.productImageView.image = image.withRenderingMode(.alwaysTemplate)
        }
        
        cell.productNameLabel.text = classifier.capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK:- Private Functions
    
    // Reuturns the classifier for index path
    fileprivate func classifierForIndexPath(_ indexPath: IndexPath) -> String {
        let classifiers = Array(products.keys)
        return classifiers[indexPath.row]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let countryListVC = segue.destination as? ProductCountrySelectionViewController
        {
            if let cell = sender as? UITableViewCell
            {
                if let indexPath = tableView.indexPath(for: cell) {
                    let classifier = classifierForIndexPath(indexPath)
                    countryListVC.products = products[classifier]!
                    countryListVC.classifier = classifier
                }
            }
        }
    }
}
