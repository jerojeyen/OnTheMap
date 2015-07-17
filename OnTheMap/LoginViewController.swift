//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/6/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextField: FormTextField!
    @IBOutlet weak var passwordTextField: FormTextField!
    
    var keyboardAdjusted = false
    var lastKeyboardOffset : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
        
        usernameTextField.text = "jerozan.jeyendrarasa@careerbuilder.com"
        passwordTextField.text = "Apple2015"
        
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        if usernameTextField.text.isEmpty || passwordTextField.text.isEmpty {
            UIAlertView(title: nil, message: "Empty username or password", delegate: nil, cancelButtonTitle: "OK").show()
        } else {
            
            UdacityClient.sharedInstance().postSessionWithUdacityCredentials(self.usernameTextField.text, password: self.passwordTextField.text) { (success, error) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let controller = self.storyboard!.instantiateViewControllerWithIdentifier("OnTheMapTabBarController") as! UITabBarController
                        self.presentViewController(controller, animated: true, completion: nil)
                    })
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), {
                        UIAlertView(title: nil, message: "Wrong username or password", delegate: nil, cancelButtonTitle: "OK").show()
                    })
                    
                }
            }
        }
    }
    
    @IBAction func signUpButtonPressed(sender: AnyObject) {
        let signUpUrl = "https://www.google.com/url?q=https%3A%2F%2Fwww.udacity.com%2Faccount%2Fauth%23!%2Fsignin&sa=D&sntz=1&usg=AFQjCNERmggdSkRb9MFkqAW_5FgChiCxAQ"
        UIApplication.sharedApplication().openURL(NSURL(string: signUpUrl)!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
    
}