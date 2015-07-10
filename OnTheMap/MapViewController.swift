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

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding the bar button items of the navigation bar.
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "checkForStudentLocation")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "getStudentsList")
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItems = [refreshButton, addLocationButton]
        
        ParseClient.sharedInstance().getStudents { (success, students, error) -> Void in
            if success {
                if let students = students {
                    self.students = students
                    self.studentsLocationsAnnotations()
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue(), {
                    UIAlertView(title: nil, message: error, delegate: nil, cancelButtonTitle: "OK").show()
                })
            }
        }

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
        dispatch_async(dispatch_get_main_queue(), {
            self.mapView.addAnnotations(annotations)
        })
    }
    
}
