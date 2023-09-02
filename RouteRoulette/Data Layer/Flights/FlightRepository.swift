//
//  FlightRepository.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine

protocol FlightRepository {
    typealias Default = DefaultFlightRepository
    func fetch(
        sourcePlaces: [Place],
        destinationPlaces: [Place]?,
        dateRangeBeginning: String,
        dateRangeEnd: String
    ) -> AnyPublisher<[FlightDTO], Error>
}

struct DefaultFlightRepository: FlightRepository {
    
    // Corner Cutting Note: Normally would cache the results from `remoteDatasource` to a localDatasource to minimise network calls
    private let remoteDatasource: FlightDatasource
    
    init(remoteDatasource: FlightDatasource) {
        self.remoteDatasource = remoteDatasource
    }
    
    func fetch(
        sourcePlaces: [Place],
        destinationPlaces: [Place]?,
        dateRangeBeginning: String,
        dateRangeEnd: String
    ) -> AnyPublisher<[FlightDTO], Error> {
        remoteDatasource
            .fetch(
                sourcePlaces: sourcePlaces,
                destinationPlaces: destinationPlaces,
                dateRangeBeginning: dateRangeBeginning,
                dateRangeEnd: dateRangeEnd
            )
            .map { response in
                response.onewayItineraries.itineraries.map { FlightDTO(from: $0) }
            }
            .eraseToAnyPublisher()
    }
}
