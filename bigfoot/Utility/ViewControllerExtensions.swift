//
//  ViewControllerExtensions.swift
//  bigfoot
//
//  Created by Asad Ahmed on 6/5/18.
//  Copyright © 2018 Bigfoot. All rights reserved.
//
//  Contains extensions for view controllers
//

import Foundation
import UIKit

extension UIViewController
{
    // Show an alert with the given title and message with a single OK button.
    // Optionally, call the callback when OK is tapped
    func presentOkAlertWithTitle(_ title: String, andMessage message: String, withOptionalCallback callback: (() -> Void)? = nil)
    {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let handler = callback {
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                handler()
            }))
        }
        else {
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        }
        
        present(ac, animated: true, completion: nil)
    }
    
    // Display an appropriate error for the given BASIC API error
    func showErrorForAPIError(error: BasicAPI.BasicAPIError)
    {
        switch error.errorType {
        case .noConnection:
            presentOkAlertWithTitle("Connection Error", andMessage: "There is a problem with you internet connection. Please try again later.")
            
        case .encodingFailure:
            fallthrough
            
        case .parseError:
            presentOkAlertWithTitle("Encoding Error", andMessage: "Failed to parse response from server")
            
        case .serverError:
            presentOkAlertWithTitle("Server Error", andMessage: "An error occurred on the server. Please try again later.")
            
        case .timedOut:
            presentOkAlertWithTitle("Connection Timeout", andMessage: "The connection timed out. Please check your internet connection.")
        }
    }
}
