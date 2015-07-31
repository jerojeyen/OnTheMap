//
//  MyTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/31/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import UIKit

class MyTextfieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}