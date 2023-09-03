//
//  DateStringFormatter.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation

enum TimeOfDay {
    case beginning, end
}

protocol DateStringFormatter {
    typealias Default = DefaultDateStringFormatter
    func format(for date: Date, timeOfDay: TimeOfDay) -> String?
}

struct DefaultDateStringFormatter: DateStringFormatter {
    
    private let calendar: Calendar
    private let formatter: DateFormatter
    
    enum Defaults {
        static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    init(
        calendar: Calendar,
        formatter: DateFormatter
    ) {
        self.calendar = calendar
        self.formatter = formatter
        self.formatter.dateFormat = Defaults.dateFormat
    }
    
    func format(for date: Date, timeOfDay: TimeOfDay) -> String? {
        let midnightToday = calendar.startOfDay(for: date)
        switch timeOfDay {
        case .beginning:
            return formatter.string(from: midnightToday)
        case .end:
            return calculateEndOfDayString(for: date)
        }
    }
    
    private func calculateEndOfDayString(for date: Date) -> String? {
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        guard let endOfDayDate = calendar.date(from: components) else {
            return nil
        }
        
        return formatter.string(from: endOfDayDate)
    }
}
