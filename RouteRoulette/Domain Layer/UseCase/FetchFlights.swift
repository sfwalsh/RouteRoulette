//
//  FetchFlights.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine

struct FetchFlights: UseCase {
    typealias T = RequestValues
    typealias U = [FlightDTO]
    
    private let repository: FlightRepository
    
    init(repository: FlightRepository) {
        self.repository = repository
    }
    
    func invoke(requestValues: RequestValues) -> AnyPublisher<[FlightDTO], Error> {
        repository.fetch(
            sourcePlaces: requestValues.sourcePlaces,
            destinationPlaces: requestValues.destinationPlaces,
            dateRangeBeginning: requestValues.dateRangeBeginning,
            dateRangeEnd: requestValues.dateRangeEnd
        )
    }
}

// MARK: RequestValues

extension FetchFlights {
    struct RequestValues {
        let sourcePlaces: [Place]
        let destinationPlaces: [Place]?
        let dateRangeBeginning: String
        let dateRangeEnd: String
    }
}
