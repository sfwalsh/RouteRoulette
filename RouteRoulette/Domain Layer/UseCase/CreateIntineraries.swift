//
//  CreateIntineraries.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine


protocol CreateIntineraries: UseCase {
    typealias Default = DefaultCreateIntineraries
    func invoke(requestValues: CreateIntinerariesRequestValues) -> AnyPublisher<[FlightDTO], Error>
}

struct DefaultCreateIntineraries: CreateIntineraries {
    typealias T = CreateIntinerariesRequestValues
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
    
    func invoke(requestValues: CreateIntinerariesRequestValues) -> AnyPublisher<[FlightDTO], Error> {
        // Corner cutting note: Error handling should be implemented for the edge case where a valid value isn't returned from the
        // dateStringFormatter
        let dateRangeBeginning = dateStringFormatter.format(for: Date(), timeOfDay: .beginning) ?? ""
        let dateRangeEnd = dateStringFormatter.format(for: Date(), timeOfDay: .end) ?? ""
        
        return fetchPlaces.invoke(requestValues: .init(searchTerm: requestValues.searchTerm))
            .flatMap { places in
                self.fetchFlights.invoke(requestValues: .init(
                    sourcePlaces: places,
                    destinationPlaces: nil, // corner cutting note; destinationPlaces has been left blank for this destination, to get the most possible results
                    dateRangeBeginning: dateRangeBeginning,
                    dateRangeEnd: dateRangeEnd)
                )
            }
            .eraseToAnyPublisher()
    }
}

// MARK: RequestValues

struct CreateIntinerariesRequestValues {
    let searchTerm: String?
}
