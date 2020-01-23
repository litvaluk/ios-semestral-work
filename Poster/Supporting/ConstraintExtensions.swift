//
//  ConstraintExtensions.swift
//  Poster
//
//  Created by Lukáš Litvan on 22/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func pin(superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
    
}
