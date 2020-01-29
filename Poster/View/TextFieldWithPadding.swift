//
//  TextFieldWithPadding.swift
//  Poster
//
//  Created by Lukáš Litvan on 27/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit

class TextFieldWithPadding: UITextField {

    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
      return bounds.inset(by: padding)
    }

}
