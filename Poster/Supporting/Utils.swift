//
//  Utils.swift
//  Poster
//
//  Created by Lukáš Litvan on 26/01/2020.
//  Copyright © 2020 Lukáš Litvan. All rights reserved.
//

import Foundation

class Utils {
    
    static func timestampToString(timestamp: Double, dateFormat: String = "d. M. yyyy H:mm") -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }
    
}
