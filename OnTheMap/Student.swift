//
//  Student.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/10/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation

class Student {
    
    var firstName: String!
    var lastName: String!
    var latitude: Double!
    var longitude: Double!
    var mediaURL: String!
    var mapString: String!
    var objectId: String!
    var uniqueKey: String!
    
    init(dictionary: [String : AnyObject]) {
        self.firstName = dictionary["firstName"] as! String
        self.lastName = dictionary["lastName"] as! String
        self.latitude = dictionary["latitude"] as! Double
        self.longitude = dictionary["longitude"] as! Double
        self.mediaURL = dictionary["mediaURL"] as! String
        self.mapString = dictionary["mapString"] as! String
        self.objectId = dictionary["objectId"] as! String
        self.uniqueKey = dictionary["uniqueKey"] as! String
    }
    
    var fullname: String {
        return firstName + " " + lastName
    }
}