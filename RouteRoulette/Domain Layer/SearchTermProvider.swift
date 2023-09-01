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
    func generate() -> String {
        // TODO: Implement functionality
        return ""
    }
}
