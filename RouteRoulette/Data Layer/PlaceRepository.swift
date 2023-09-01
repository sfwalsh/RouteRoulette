//
//  PlaceRepository.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine

protocol PlaceRepository {
    typealias Default = DefaultPlaceRepository
    func fetch(forSearchTerm searchTerm: String?) -> AnyPublisher<[Place], Error>
}

struct DefaultPlaceRepository: PlaceRepository {
    
    // Corner Cutting Note: Normally would cache the results from `remoteDatasource` to a localDatasource to minimise network calls
    private let remoteDatasource: PlaceDatasource
    
    init(remoteDatasource: PlaceDatasource) {
        self.remoteDatasource = remoteDatasource
    }
    
    func fetch(forSearchTerm searchTerm: String?) -> AnyPublisher<[Place], Error> {
        remoteDatasource
            .fetch(forSearchTerm: searchTerm)
            .map { response in
                response.places.edges.map { $0.node }
            }
            .eraseToAnyPublisher()
    }
}
