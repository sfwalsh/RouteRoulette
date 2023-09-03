//
//  MockFlightRepository.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine
@testable import RouteRoulette

final class MockFlightRepository: FlightRepository {
    var mockedResponse: [FlightDTO] = []
    var shouldFail = false
    
    func fetch(
        sourcePlaces: [Place],
        destinationPlaces: [Place]?,
        dateRangeBeginning: String,
        dateRangeEnd: String
    ) -> AnyPublisher<[FlightDTO], Error> {
        if shouldFail {
            return Fail(error: NetworkRoverError.serverError(message: "Network error"))
                .eraseToAnyPublisher()
        }
        
        return Just(mockedResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
