//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/9/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding the bar button items of the navigation bar.
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "checkForStudentLocation")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "loadStudents")
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItems = [refreshButton, addLocationButton]
        
        self.mapView.delegate = self
        
        self.loadStudents()
    }
    
    func loadStudents() {
        ParseClient.sharedInstance().getStudents { (success, students, error) -> Void in
            if success {
                if let students = students {
                    self.students = students
                    dispatch_async(dispatch_get_main_queue(), {
                        self.studentsLocationsAnnotations()
                        self.mapView.reloadInputViews()
                    })
                }
                else {
                    self.displayErrorAlertView("Could not get students datas")
                }
            }
            else {
                if let error = error {
                    self.displayErrorAlertView(error)
                }
            }
        }
    }
    
    func displayErrorAlertView(error: String) {
        dispatch_async(dispatch_get_main_queue(), {
            UIAlertView(title: nil, message: error, delegate: nil, cancelButtonTitle: "OK").show()
        })
    }
    
    func studentsLocationsAnnotations() {
        
        //Remove old pins before adding new ones to avoid duplication.
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            // Here we create the annotation and set its coordinate, title, and subtitle properties
            var annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            annotation.title = student.fullname
            annotation.subtitle = student.mediaURL
            
            // Placing the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    
    // Creating a view with a "right callout accessory view".
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .Red
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            UIApplication.sharedApplication().openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
}
