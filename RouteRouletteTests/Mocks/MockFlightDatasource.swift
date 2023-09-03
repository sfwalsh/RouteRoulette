//
//  MockFlightDatasource.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine
@testable import RouteRoulette

final class MockFlightDatasource: FlightDatasource {
    var mockedResponse = FlightsResponse(onewayItineraries: FlightsResponse.OnewayItineraries(itineraries: []))
    var shouldSucceed = true

    func fetch(sourcePlaces: [Place], destinationPlaces: [Place]?, dateRangeBeginning: String, dateRangeEnd: String) -> AnyPublisher<FlightsResponse, Error> {
        if shouldSucceed {
            return Just(mockedResponse)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkRoverError.serverError(message: "Network error"))
                .eraseToAnyPublisher()
        }
    }
}
