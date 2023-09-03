//
//  NetworkRover.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 31/08/2023.
//

import Foundation
import Combine

protocol NetworkRover {
    typealias Default = DefaultNetworkRover
    func fetchGraphQLData<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error>
}

struct DefaultNetworkRover: NetworkRover {
    
    private let urlSession: URLSessionDataTaskPublishing
    private let decoder: JSONDecoder
    
    init(
        urlSession: URLSessionDataTaskPublishing,
        decoder: JSONDecoder
    ) {
        self.urlSession = urlSession
        self.decoder = decoder
    }
    
    func fetchGraphQLData<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
        urlSession
            .customDataTaskPublisher(for: request) // to cater to the tests
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return try decodeResponse(for: data)
            }
            .eraseToAnyPublisher()
    }
    
    private func decodeResponse<T: Decodable>(for data: Data) throws -> T {
        let graphQLResponse = try decoder.decode(GraphQLResponse<T>.self, from: data)
        
        // Corner cutting note: error handling would be more verbose in a production app, incl. error localization as appropriate
        if let errors = graphQLResponse.errors, !errors.isEmpty {
            throw NetworkRoverError.serverError(message: errors.first?.message)
        }

        guard let responseData = graphQLResponse.data else {
            throw NetworkRoverError.invalidResponse
        }
        
        return responseData
    }
}
