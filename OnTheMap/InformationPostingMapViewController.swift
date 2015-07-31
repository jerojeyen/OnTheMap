//
//  InformationPostingMapViewController.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/31/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class InformationPostingMapViewController: UIViewController {
    
    var location: String?
    var latitude: Double!
    var longitude: Double!
    var region: MKCoordinateRegion!
    var placemark: CLPlacemark!
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    let textFieldDelegate = MyTextfieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        linkTextField.delegate = textFieldDelegate
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.setRegion(region, animated: true)
        self.mapView.addAnnotation(MKPlacemark(placemark: placemark))
        
    }
   
    @IBAction func cancelPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitPressed(sender: AnyObject) {

    }
}