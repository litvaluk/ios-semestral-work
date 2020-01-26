//
//  PostAnnotationView.swift
//  Poster
//
//  Created by Lukáš Litvan on 24/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import UIKit
import MapKit

class PostAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var post: Post
    let title: String?
    let subtitle: String?

    init(post: Post) {
        self.post = post
        self.coordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
        self.title = post.description
        self.subtitle = Utils.timestampToString(timestamp: post.timestamp)
    }

}
