//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/16/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import UIKit
import Foundation

class TableViewController: UITableViewController {
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding the bar button items of the navigation bar.
        let addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "checkForStudentLocation")
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "loadStudents")
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logout")
        
        self.navigationItem.leftBarButtonItem = logoutButton
        self.navigationItem.rightBarButtonItems = [refreshButton, addLocationButton]
        
        self.loadStudents()
    }
    
    func logout() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadStudents() {
        ParseClient.sharedInstance().getStudents { (success, students, error) -> Void in
            if success {
                if let students = students {
                    self.students = students
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
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
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Setting up the TableViewCell
        let cellReuseIdentifier = "StudentCell"
        let student = students[indexPath.row]
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as! UITableViewCell
        
        cell.textLabel!.text = student.fullname
        cell.detailTextLabel!.text = student.mediaURL
        cell.imageView!.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let student = students[indexPath.row]
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL)!)
    }
    
}