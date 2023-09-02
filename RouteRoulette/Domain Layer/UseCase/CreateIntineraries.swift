//
//  CreateIntineraries.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine

struct CreateIntineraries: UseCase {
    typealias T = RequestValues
    typealias U = [FlightDTO]
    
    // MARK: Use cases
    private let fetchFlights: any FetchFlights
    private let fetchPlaces: any FetchPlaces
    private let dateStringFormatter: DateStringFormatter
    
    init(
        fetchFlights: any FetchFlights,
        fetchPlaces: any FetchPlaces,
        dateStringFormatter: DateStringFormatter
    ) {
        self.fetchFlights = fetchFlights
        self.fetchPlaces = fetchPlaces
        self.dateStringFormatter = dateStringFormatter
    }
    
    func invoke(requestValues: RequestValues) -> AnyPublisher<[FlightDTO], Error> {
        // Corner cutting note: Error handling should be implemented for the edge case where a valid value isn't returned from the
        // dateStringFormatter
        let dateRangeBeginning = dateStringFormatter.format(for: Date(), timeOfDay: .beginning) ?? ""
        let dateRangeEnd = dateStringFormatter.format(for: Date(), timeOfDay: .end) ?? ""
        
        return fetchPlaces.invoke(requestValues: .init(searchTerm: requestValues.searchTerm))
            .flatMap { places in
                self.fetchFlights.invoke(requestValues: .init(
                    sourcePlaces: places,
                    destinationPlaces: nil,
                    dateRangeBeginning: dateRangeBeginning,
                    dateRangeEnd: dateRangeEnd)
                )
            }
            .eraseToAnyPublisher()
    }
}

// MARK: RequestValues

extension CreateIntineraries {
    struct RequestValues {
        let searchTerm: String?
    }
}
