//
//  ProduceScanViewController.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/3/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  View controller that scans and displays information on the produce
//

import UIKit
import AVFoundation
import AlamofireImage

class ProduceScanViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate
{
    // MARK:- Outlets and Properties
    
    @IBOutlet weak var imageViewBGView: GradientView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var analyzeButton: RoundedButton!
    @IBOutlet weak var itemOriginTextField: UITextField!
    @IBOutlet weak var loaderView: LoaderView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var scanAgainButton: UIButton!
    
    enum PickerType {
        case camera
        case photoLibrary
    }
    
    // List of countries. Must bet set by previous VC
    var countries = [BasicAPI.Country]()
    
    fileprivate var image: UIImage? = nil {
        didSet {
            instructionsLabel.isHidden = (image != nil)
            itemOriginTextField.isHidden = (image == nil)
            cameraButton.alpha = (image != nil ? 0.3 : 1.0)
            imageViewBGView.isHidden = (image == nil)
            imageView.image = image
            analyzeButton.isHidden = itemOriginTextField.isHidden
        }
    }
    
    fileprivate var selectedCountryOfOrigin: BasicAPI.Country? = nil {
        didSet {
            itemOriginTextField.text = (selectedCountryOfOrigin != nil ? selectedCountryOfOrigin!.name : nil)
        }
    }
    
    fileprivate let MAX_IMAGE_SIZE: CGFloat = 512
    
    // MARK:- Setup
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // setup default values for data and UI
        image = nil
        itemTitle.text = nil
        scanAgainButton.isHidden = true
        itemOriginTextField.isHidden = false
        
        // setup image view corners
        imageView.layer.cornerRadius = imageViewBGView.cornerRadius
        
        // show picker when navigating to the screen
        if checkCameraPermissions() {
            showImagePicker(type: .camera)
        }
        
        // setup iso country list picker
        let countryPicker = UIPickerView()
        countryPicker.dataSource = self
        countryPicker.delegate = self
        
        itemOriginTextField.inputView = countryPicker
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK:- Picker View (Country Selection)
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1    // only 1 column
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountryOfOrigin = countries[row]
    }
    
    // MARK:- Events
    
    // Image picker picked image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            // scale image down while maintaining aspect ratio
            if image.size.width > MAX_IMAGE_SIZE || image.size.height > MAX_IMAGE_SIZE {
                self.image = image.af_imageAspectScaled(toFill: CGSize(width: MAX_IMAGE_SIZE, height: MAX_IMAGE_SIZE))
            }
            else {
                self.image = image
            }
        }
    }
    
    // Image picker cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // User taps on the camera button to take a photo
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        if checkCameraPermissions() {
            showPhotoOptions()
        }
    }
    
    // User taps on the analyze button
    @IBAction func analyzeButtonTapped(_ sender: RoundedButton)
    {
        // validation
        if itemOriginTextField.text == nil || itemOriginTextField.text!.count == 0 || selectedCountryOfOrigin == nil {
            presentOkAlertWithTitle("Item Origin", andMessage: "Please enter the country of origin for this item")
            return
        }
        else if image == nil {
            presentOkAlertWithTitle("Image", andMessage: "Please take an image to analyze")
            return
        }
        
        // make the API call to process the image
        loaderView.message = "Processing..."
        loaderView.isLoadingActive = true
        
        guard let data = UIImageJPEGRepresentation(image!, 0.9) else {
            presentOkAlertWithTitle("Image", andMessage: "Failed to process your image. Please take another image.")
            return
        }
        
        // make the API call to analyze the image
        BasicAPI.shared.analyzeImage(imageData: data, countryOfOriginCode: selectedCountryOfOrigin!.code, userLocationCode: DataManager.currentLocation!.countryCode) { [weak self] (response, error) in
            self?.loaderView.isLoadingActive = false
            if let basicImageAnalysisResponse = response
            {
                if basicImageAnalysisResponse.success
                {
                    guard case self = self else { return }
                    
                    self!.scanAgainButton.isHidden = false
                    self!.itemOriginTextField.isHidden = true
                    
                    // navigate to product detail vc
                    if let productID = basicImageAnalysisResponse.productID {
                        self!.performSegue(withIdentifier: "To Product Detail VC", sender: productID)
                    }
                }
                else {
                    self?.presentOkAlertWithTitle("Failure", andMessage: basicImageAnalysisResponse.message)
                }
            }
            else {
                self?.showErrorForAPIError(error: error!)
            }
        }
    }
    
    // User taps on the scan again button to do another scan of another product
    @IBAction func scanAgainButtonTapped(_ sender: UIButton)
    {
        // clear out fields
        itemTitle.text = nil
        itemOriginTextField.text = nil
        itemOriginTextField.isHidden = false
        scanAgainButton.isHidden = true
        cameraButton.isHidden = false
        cameraButton.alpha = 1.0
        image = nil
        
        // get another image to analyze and repeat the process
        showPhotoOptions()
    }
    
    // item origin text field focused
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == itemOriginTextField {
            if let picker = textField.inputView as? UIPickerView {
                selectedCountryOfOrigin = countries[picker.selectedRow(inComponent: 0)]
            }
        }
    }
    
    // MARK:- Private Functions
    
    // Present the user with options for using the camera or select a photo from the album
    fileprivate func showPhotoOptions()
    {
        let ac = UIAlertController(title: "Analyze Image", message: "Take a photo from the camera or photo library?", preferredStyle: .actionSheet)
        
        // camera option
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.showImagePicker(type: .camera)
        }))
        
        // photo library option
        ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (_) in
            self.showImagePicker(type: .photoLibrary)
        }))
        
        // cancel
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    // Display the photo picker to take a photo from the camera
    fileprivate func showImagePicker(type: PickerType)
    {
        let picker = UIImagePickerController()
        
        if type == .camera {
            picker.sourceType = UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary
        }
        else {
            picker.sourceType = .photoLibrary
        }
        
        picker.allowsEditing = false
        picker.delegate = self
        
        present(picker, animated: true, completion: nil)
    }
    
    // Checks if permissions for camera use have been granted and prompts the user for access. Returns true if access is granted and false if not.
    fileprivate func checkCameraPermissions() -> Bool
    {
        // check if permissions were denied and show alert to the user to give permission
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus == .authorized || authorizationStatus == .notDetermined {
            return true
        }
        else
        {
            // request for permission from the user
            presentOkAlertWithTitle("Camera Usage", andMessage: "You have denied access to use the camera. Please provide authorization to use the camera.") {
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            
            return false
        }
    }
    
    // MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let productDetailVC = segue.destination as? ProductDetailViewController
        {
            if let productID = sender as? Int {
                productDetailVC.productID = productID
                productDetailVC.productImage = image
            }
        }
    }
}
