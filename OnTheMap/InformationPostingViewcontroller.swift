//
//  InformationPostingViewcontroller.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/30/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    @IBOutlet weak var addressTextField: UITextField!
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    var location: String?
    var latitude: Double!
    var longitude: Double!
    var region: MKCoordinateRegion!
    var placemark: CLPlacemark!
    
    let textFieldDelegate = MyTextfieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addressTextField.delegate = textFieldDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification) / 2
            self.view.superview?.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if keyboardAdjusted == true {
            self.view.superview?.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var shouldPerform = true
        
        if identifier == "findOnTheMapButtonPressed" {
            shouldPerform = false
            if addressTextField.text.isEmpty {
                UIAlertView(title: nil, message: "The address field is empty", delegate: nil, cancelButtonTitle: "OK").show()
            } else {
                let regionRadius: CLLocationDistance = 200
                var geocoder = CLGeocoder()
                geocoder.geocodeAddressString(addressTextField.text, completionHandler: {(placemarks: [AnyObject]!, error: NSError!) -> Void in
                    if let firstPlacemark = placemarks?[0] as? CLPlacemark {
                        self.placemark = firstPlacemark
                        let coordinateRegion = MKCoordinateRegionMakeWithDistance(firstPlacemark.location.coordinate, regionRadius, regionRadius)
                        self.region = coordinateRegion
                        self.latitude = firstPlacemark.location.coordinate.latitude as Double
                        self.longitude = firstPlacemark.location.coordinate.longitude as Double
                        self.performSegueWithIdentifier(identifier, sender: self)
                    } else {
                        UIAlertView(title: nil, message: "The address is not valid", delegate: nil, cancelButtonTitle: "OK").show()
                    }
                })
            }
        }
        return shouldPerform
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "findOnTheMapButtonPressed" {
            var vc = segue.destinationViewController as! InformationPostingMapViewController
            vc.location = addressTextField.text
            vc.region = region
            vc.latitude = latitude
            vc.longitude = longitude
            vc.placemark = placemark
        }
    }
}