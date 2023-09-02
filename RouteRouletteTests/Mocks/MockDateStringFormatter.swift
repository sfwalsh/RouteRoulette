//
//  MockDateStringFormatter.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
@testable import RouteRoulette

final class MockDateStringFormatter: DateStringFormatter {
    func format(for date: Date, timeOfDay: TimeOfDay) -> String? {
        "2023-09-02T23:59:59"
    }
}
