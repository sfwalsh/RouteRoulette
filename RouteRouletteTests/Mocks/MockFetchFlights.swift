//
//  MockFetchFlights.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine
@testable import RouteRoulette

final class MockFetchFlights: FetchFlights {
    var result: Result<[FlightDTO], Error> = .failure(NetworkRoverError.serverError(message: "something went wrong."))
    
    func invoke(requestValues: FetchFlightsRequestValues) -> AnyPublisher<[FlightDTO], Error> {
        Future<[FlightDTO], Error> { promise in
            promise(self.result)
        }
        .eraseToAnyPublisher()
    }
}
