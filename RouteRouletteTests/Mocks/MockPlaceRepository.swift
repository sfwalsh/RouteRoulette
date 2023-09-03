//
//  MockPlaceRepository.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine
@testable import RouteRoulette

final class MockPlaceRepository: PlaceRepository {
    var mockedSuccessResponse: [Place]? = nil
    var mockedError: Error? = nil
    var lastReceivedSearchTerm: String?
    
    func fetch(forSearchTerm searchTerm: String?) -> AnyPublisher<[Place], Error> {
        lastReceivedSearchTerm = searchTerm
        if let error = mockedError {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let places = mockedSuccessResponse {
            return Just(places).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        fatalError()
    }
}
