//
//  FetchPlaces.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine

protocol FetchPlaces: UseCase {
    typealias Default = DefaultFetchPlaces
    func invoke(requestValues: FetchPlacesRequestValues) -> AnyPublisher<[Place], Error>
}

struct DefaultFetchPlaces: FetchPlaces {
    typealias T = FetchPlacesRequestValues
    typealias U = [Place]
    
    private let repository: PlaceRepository
    
    init(repository: PlaceRepository) {
        self.repository = repository
    }
    
    func invoke(requestValues: FetchPlacesRequestValues) -> AnyPublisher<[Place], Error> {
        repository.fetch(forSearchTerm: requestValues.searchTerm)
    }
}

// MARK: RequestValues

struct FetchPlacesRequestValues {
    let searchTerm: String?
}
