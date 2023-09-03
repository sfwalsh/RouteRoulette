//
//  URLSessionDataTaskPublishing.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine

protocol URLSessionDataTaskPublishing {
    func customDataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
}


// MARK: URLSession conformance, for allowing injection of a mock in the test suite

extension URLSession: URLSessionDataTaskPublishing {
    func customDataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        return self.dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}
