//
//  File.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 31/08/2023.
//

import Foundation
import Combine

protocol PlaceDatasource {
    typealias Default = DefaultPlaceDatasource
    func fetch(forSearchTerm searchTerm: String?) -> AnyPublisher<PlacesResponse, Error>
}

struct DefaultPlaceDatasource: PlaceDatasource {
    
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
    
    func fetch(forSearchTerm searchTerm: String?) -> AnyPublisher<PlacesResponse, Error> {
        let queryString = queryBuilder.build(for: .place(searchTerm: searchTerm))
        do {
            let request = try apiRequestBuilder.create(forQueryString: queryString)
            return networkRover.fetchGraphQLData(request: request)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
}
