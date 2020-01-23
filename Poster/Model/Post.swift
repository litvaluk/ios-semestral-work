//
//  Post.swift
//  Poster
//
//  Created by Lukáš Litvan on 21/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation

struct Post: Codable {
    let id: String
    let image_url: String
    let description: String
    let rating: Double
    let timestamp: Double
    
    init(id: String, image_url: String, description: String, rating: Double, timestamp: Double) {
        self.id = id
        self.image_url = image_url
        self.description = description
        self.rating = rating
        self.timestamp = timestamp
    }
}
