//
//  ProductDetailViewController.swift
//  bigfoot
//
//  Created by Asad Ahmed on 8/23/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  View Controller responsible for displaying full details on an identified product
//

import UIKit

class ProductDetailViewController: UIViewController
{
    // MARK:- Outlets and Properties
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var loaderView: LoaderView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var productionFootprintStackView: UIStackView!
    @IBOutlet weak var transportationModeLabel: UILabel!
    @IBOutlet weak var transportationFootprintLabel: UILabel!
    @IBOutlet weak var sustainabilityIndexLabel: UILabel!
    @IBOutlet weak var countryImageView: UIImageView!
    
    // The product id. Must be set by the pushing VC
    var productID: Int!
    
    // The product image must be set by the pushing VC.
    var productImage: UIImage? = nil
    
    fileprivate var productDetails: BasicAPI.ProductDetail? = nil {
        didSet {
            if let product = productDetails
            {
                productNameLabel.text = product.name
                
                countryNameLabel.text = product.countryName
                countryImageView.image = UIImage(named: product.countryCode.lowercased())
                
                if let dataPoints = product.productionFootprint {
                    FootprintViewBuilder.setDataPointsForStackView(stackView: productionFootprintStackView, dataPoints: dataPoints)
                }
                
                if let transportFootprint = product.transportationFootprint {
                    transportationFootprintLabel.text = String(format: "%.8f CO2/Kg", transportFootprint.value)
                    transportationModeLabel.text = transportFootprint.mode
                }
                
                if let siValue = product.sustainabilityIndex {
                    sustainabilityIndexLabel.text = String(format: "%.8f", siValue)
                }
            }
        }
    }
    
    // MARK:- Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadProductDetails()
    }
    
    // UI Setup
    fileprivate func setupUI()
    {
        // title
        navigationItem.title = "Product Details"
        
        // clear out design UI
        productNameLabel.text = "N/A"
        countryNameLabel.text = nil
        countryImageView.image = nil
        
        for subview in productionFootprintStackView.arrangedSubviews {
            productionFootprintStackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        transportationModeLabel.text = "N/A"
        transportationFootprintLabel.text = "N/A"
        
        sustainabilityIndexLabel.text = nil
        
        // set product image
        productImageView.contentMode = .scaleAspectFill
        productImageView.image = productImage
        
        // load data from server
        loadProductDetails()
    }
    
    // Load product details
    fileprivate func loadProductDetails()
    {
        loaderView.isLoadingActive = true
        loaderView.message = "Fetching Product Details"
        
        let locationCode = DataManager.currentLocation!.countryCode
        BasicAPI.shared.productDetails(productID: productID, userLocationISOCode: locationCode) { [weak self] (response, error) in
            self?.loaderView.isLoadingActive = false
            if let productDetailResponse = response
            {
                if productDetailResponse.success {
                    self?.productDetails = productDetailResponse.product
                }
                else {
                    self?.presentOkAlertWithTitle("Error", andMessage: productDetailResponse.message)
                }
            }
            else {
                self?.showErrorForAPIError(error: error!)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
