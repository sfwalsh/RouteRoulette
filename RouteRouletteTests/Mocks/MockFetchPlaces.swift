//
//  MockFetchPlaces.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine
@testable import RouteRoulette

final class MockFetchPlaces: FetchPlaces {
    var result: Result<[Place], Error> = .failure(NetworkRoverError.invalidResponse)
    
    func invoke(requestValues: FetchPlacesRequestValues) -> AnyPublisher<[Place], Error> {
        Future<[Place], Error> { promise in
            promise(self.result)
        }
        .eraseToAnyPublisher()
    }
}
