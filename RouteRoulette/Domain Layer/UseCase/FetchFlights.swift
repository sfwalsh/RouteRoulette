//
//  FetchFlights.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine

protocol FetchFlights: UseCase {
    typealias Default = DefaultFetchFlights
    func invoke(requestValues: FetchFlightsRequestValues) -> AnyPublisher<[FlightDTO], Error>
}

struct DefaultFetchFlights: FetchFlights {
    typealias T = FetchFlightsRequestValues
    typealias U = [FlightDTO]
    
    private let repository: FlightRepository
    
    init(repository: FlightRepository) {
        self.repository = repository
    }
    
    func invoke(requestValues: FetchFlightsRequestValues) -> AnyPublisher<[FlightDTO], Error> {
        repository.fetch(
            sourcePlaces: requestValues.sourcePlaces,
            destinationPlaces: requestValues.destinationPlaces,
            dateRangeBeginning: requestValues.dateRangeBeginning,
            dateRangeEnd: requestValues.dateRangeEnd
        )
    }
}

// MARK: RequestValues

struct FetchFlightsRequestValues {
    let sourcePlaces: [Place]
    let destinationPlaces: [Place]?
    let dateRangeBeginning: String
    let dateRangeEnd: String
}
