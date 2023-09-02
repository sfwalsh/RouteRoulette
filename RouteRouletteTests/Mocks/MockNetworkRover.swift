//
//  MockNetworkRover.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine
@testable import RouteRoulette

final class MockNetworkRover: NetworkRover {
    var responseObject: Decodable?
    
    func fetchGraphQLData<T>(request: URLRequest) -> AnyPublisher<T, Error> where T : Decodable {
        
        if let responseObject = responseObject {
            return Just(responseObject as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: NetworkRoverError.serverError(message: "Network error"))
                .eraseToAnyPublisher()
        }
    }
}
