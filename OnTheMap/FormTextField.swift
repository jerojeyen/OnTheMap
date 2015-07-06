//
//  FormTextField.swift
//  OnTheMap
//
//  Created by Jerozan Jeyendrarasa on 7/3/15.
//  Copyright (c) 2015 jerojeyen. All rights reserved.
//

import UIKit

@IBDesignable
class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return CGRectInset(bounds, inset, inset)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }
}
