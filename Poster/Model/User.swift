//
//  User.swift
//  Poster
//
//  Created by Lukáš Litvan on 26/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: String
    let name: String
    let description: String
    
    init(id: String, name: String, description: String) {
        self.id = id
        self.description = description
        self.name = name
    }
    
}
