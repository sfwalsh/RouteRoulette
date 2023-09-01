//
//  MockQueryBuilder.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
@testable import RouteRoulette

final class MockQueryBuilder: QueryBuilder {
    var lastSearchTerm: String?
    var returnedString = ""
    
    func build(for queryType: QueryType) -> String {
        if case let .place(searchTerm) = queryType {
            lastSearchTerm = searchTerm
        }
        return returnedString
    }
}
