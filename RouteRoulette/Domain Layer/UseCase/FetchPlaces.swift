//
//  FetchPlaces.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine

struct FetchPlaces: UseCase {
    typealias T = RequestValues
    typealias U = [Place]
    
    private let repository: PlaceRepository
    
    init(repository: PlaceRepository) {
        self.repository = repository
    }
    
    func invoke(requestValues: RequestValues) -> AnyPublisher<[Place], Error> {
        repository.fetch(forSearchTerm: requestValues.searchTerm)
    }
}

// MARK: RequestValues

extension FetchPlaces {
    struct RequestValues {
        let searchTerm: String?
    }
}
