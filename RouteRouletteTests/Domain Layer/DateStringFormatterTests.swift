//
//  DateStringFormatterTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import XCTest
@testable import RouteRoulette

final class DefaultDateStringFormatterTests: XCTestCase {
    
    var sut: DefaultDateStringFormatter!
    
    override func setUp() {
        super.setUp()
        let calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        sut = DefaultDateStringFormatter(calendar: calendar, formatter: formatter)
    }
    
    func testFormatBeginningOfDay() {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        let formattedDate = calendar.startOfDay(for: currentDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = DefaultDateStringFormatter.Defaults.dateFormat
        let expectedDateString = formatter.string(from: formattedDate)
        
        let result = sut.format(for: currentDate, timeOfDay: .beginning)
        XCTAssertEqual(result, expectedDateString)
    }
    
    func testFormatEndOfDay() {
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        
        var components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endOfDayDate = calendar.date(from: components)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = DefaultDateStringFormatter.Defaults.dateFormat
        let expectedDateString = formatter.string(from: endOfDayDate)
        
        let result = sut.format(for: currentDate, timeOfDay: .end)
        XCTAssertEqual(result, expectedDateString)
    }
}
