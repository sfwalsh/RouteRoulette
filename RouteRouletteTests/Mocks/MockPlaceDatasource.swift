//
//  MockPlaceDatasource.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import XCTest
import Combine
@testable import RouteRoulette

final class MockPlaceDatasource: PlaceDatasource {
    var mockedPlacesResponse: PlacesResponse!
    
    func fetch(forSearchTerm searchTerm: String?) -> AnyPublisher<PlacesResponse, Error> {
        return Just(mockedPlacesResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
