//
//  FlightDatasource.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import Combine

protocol FlightDatasource {
    typealias Default = DefaultFlightDatasource
    
    func fetch(
        sourcePlaces: [Place],
        destinationPlaces: [Place]?,
        dateRangeBeginning: String,
        dateRangeEnd: String
    ) -> AnyPublisher<FlightsResponse, Error>
}

struct DefaultFlightDatasource: FlightDatasource {
    
    private let networkRover: NetworkRover
    private let queryBuilder: QueryBuilder
    private let apiRequestBuilder: APIRequestBuilder
    
    init(
        networkRover: NetworkRover,
        queryBuilder: QueryBuilder,
        apiRequestBuilder: APIRequestBuilder
    ) {
        self.networkRover = networkRover
        self.queryBuilder = queryBuilder
        self.apiRequestBuilder = apiRequestBuilder
    }
    
    func fetch(
        sourcePlaces: [Place],
        destinationPlaces: [Place]?,
        dateRangeBeginning: String,
        dateRangeEnd: String
    ) -> AnyPublisher<FlightsResponse, Error> {
        let queryString = queryBuilder.build(for: .flight(
            sourceIdentifiers: sourcePlaces.map { $0.id },
            destinationIdentifiers: destinationPlaces?.map { $0.id },
            dateRangeBeginning: dateRangeBeginning,
            dateRangeEnd: dateRangeEnd)
        )
        do {
            let request = try apiRequestBuilder.create(forQueryString: queryString)
            return networkRover.fetchGraphQLData(request: request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
