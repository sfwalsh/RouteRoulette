//
//  StringToDateFormatter.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import Foundation



protocol StringToDateFormatter {
    typealias Default = DefaultStringToDateFormatter
    func format(forDateString dateString: String) -> Date?
}

struct DefaultStringToDateFormatter: StringToDateFormatter {
 
    private let formatter: DateFormatter
    
    init(formatter: DateFormatter) {
        self.formatter = formatter
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
    }
    
    func format(forDateString dateString: String) -> Date? {
        formatter.date(from: dateString)
    }
}
