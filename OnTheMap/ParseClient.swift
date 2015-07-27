//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/9/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation

class ParseClient {
    
    /* Shared session */
    let session: NSURLSession
    let applicationId: String
    let restApiKey: String
    
    init() {
        self.session = NSURLSession.sharedSession()
        self.applicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        self.restApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    func getStudents(completionHandler: (success: Bool, students: [Student]?, error: String?) -> Void) {
        /* Setting the parameters */
        let methodParameters = [
            "limit": 100
        ]
        
        /* Configuring the request */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation" + escapedParameters(methodParameters))!)
        request.addValue(self.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.restApiKey, forHTTPHeaderField: "X-Parse-REST-Api-Key")
        
        /* Making the request */
        let task = self.session.dataTaskWithRequest(request) {data, response, downloadError in
            
            if let error = downloadError {
                completionHandler(success: false, students: nil, error: "Could not find students")
            } else {
                
                /* Parsing the data */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                /* Using the data! */
                if let error = parsingError {
                    completionHandler(success: false, students: nil, error: "Could not find students")
                } else {
                    if let results = parsedResult["results"] as? [[String : AnyObject]] {
                        
                        var studentsArray = [Student]()
                        
                        for studentResult in results {
                            studentsArray.append(Student(dictionary: studentResult))
                        }
                        
                        completionHandler(success: true, students: studentsArray, error: nil)
                        
                    } else {
                        completionHandler(success: false, students: nil, error: "Could not find students")
                    }
                }
            }
        }
        
        /* Starting the request */
        task.resume()

    }
    
    func queryingStudentLocation(completionHandler: (success: Bool, error: String?) -> Void) {
        
        let userKey = UdacityClient.sharedInstance().userKey
        
        /* Configuring the request */
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.parse.com/1/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(userKey)%22%7D")!)
        request.addValue(self.applicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(self.restApiKey, forHTTPHeaderField: "X-Parse-REST-Api-Key")
        
        /* Making the request */
        let task = session.dataTaskWithRequest(request) { data, response, error in
            
            if let error = error {
                completionHandler(success: false, error: "Could not find student location.")
            } else {
                
                /* Parsing the data */
                var parsingError: NSError? = nil
                let parsedResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as! NSDictionary
                
                /* Using the data */
                if let results = parsedResult["results"] as? [[String : AnyObject]] {
//                    self.objectID = results[0]["objectId"] as! String
                    completionHandler(success: true, error: nil)
                }
                else {
                    completionHandler(success: false, error: "Could not find student location.")
                }
                
            }
        }
        /* Starting the request */
        task.resume()
    }

    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + join("&", urlVars)
    }
    
    class func sharedInstance() -> ParseClient {
        
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        
        return Singleton.sharedInstance
    }
}
