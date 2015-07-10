//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/7/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation

class UdacityClient {
    
    /* Shared session */
    var session: NSURLSession
    
    var userKey: String!
    var objectID: String!
    var userFirstName: String!
    var userLastName: String!

    init() {
        self.session = NSURLSession.sharedSession()
    }
    
    func postSessionWithUdacityCredentials(username: String, password: String, completionHandler: (success: Bool, error: String?) -> Void) {
        
        /* Configuring the request */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        
        /* Making the request */
        let task = self.session.dataTaskWithRequest(request) { data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(success: false, error: "Invalid Login Credentials")
            } else {
                
                /* Parsing the data */
                var parsingError: NSError? = nil
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                let parsedResult = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                /* Using the data */
                if let userAccount = parsedResult["account"] as? [String : AnyObject] {
                    self.userKey = userAccount["key"] as! String
//                    self.getUdacityPublicUserData()
                    completionHandler(success: true, error: nil) }
                else {
                    completionHandler(success: false, error: "Invalid Login Credentials")
                }
            }
        }
        
        /* Starting the request */
        task.resume()
        
    }
    
    class func sharedInstance() -> UdacityClient {
        
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        
        return Singleton.sharedInstance
    }
}