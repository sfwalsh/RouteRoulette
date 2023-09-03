//
//  SearchTermProvider.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

protocol SearchTermProvider {
    typealias Default = DefaultSearchTermProvider
    
    func generate() -> String
}

struct DefaultSearchTermProvider: SearchTermProvider {
    
    // Corner cutting note: I planned to implement a "spin the roulette wheel" functionality for selecting the days' search term,
    // but ran out of time, so went for a deterministic day to search term dictionary approach instead
    
    private let searchTerms: [String]
    
    init(searchTerms: [String]) {
        self.searchTerms = searchTerms
    }
    
    func generate() -> String {
        let dayNumber = dayNumberOfTheYear() ?? 0
        // The modulo operator ensures the chosen index is within the bounds of the search terms collection
        let index = dayNumber % searchTerms.count
        return searchTerms[index]
    }

    func dayNumberOfTheYear() -> Int? {
        let date = Date()
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: date)
        return dayOfYear
    }
}
