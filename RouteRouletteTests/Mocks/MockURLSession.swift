//
//  MockURLSession.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine

@testable import RouteRoulette

final class MockURLSession: URLSessionDataTaskPublishing {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    func customDataTaskPublisher(for request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        if let error = error {
            return Fail(outputType: URLSession.DataTaskPublisher.Output.self, failure: error as! URLSession.DataTaskPublisher.Failure).eraseToAnyPublisher()
        } else {
            let output = (data: data ?? Data(), response: response ?? URLResponse())
            return Just(output).setFailureType(to: URLSession.DataTaskPublisher.Failure.self).eraseToAnyPublisher()
        }
    }
}
