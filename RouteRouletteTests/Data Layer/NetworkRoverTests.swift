//
//  DefaultNetworkRoverTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import XCTest
import Combine
@testable import RouteRoulette

final class NetworkRoverTests: XCTestCase {
    
    // Okay to force unwrap only in the test suite
    var cancellables: Set<AnyCancellable>!
    var mockSession: MockURLSession!
    var sut: DefaultNetworkRover!
    let urlString = "https://test.com"
    var url: URL {
        URL(string: urlString)!
    }
    var request: URLRequest {
        URLRequest(url: url)
    }
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockSession = MockURLSession()
        sut = DefaultNetworkRover(urlSession: mockSession, decoder: JSONDecoder())
    }
    
    func setupMockSession(data: Data?, responseStatusCode: Int) {
        mockSession.data = data
        mockSession.response = HTTPURLResponse(
            url: url,
            statusCode: responseStatusCode,
            httpVersion: nil,
            headerFields: nil
        )
    }
    
    func testSuccessfulDataRetrieval() {
        let id = String.randomAlphanumeric(of: 8)
        let name = String.randomAlphanumeric(of: 8)
        let legacyId = String.randomAlphanumeric(of: 8)
        let lat = 40.730610
        let long = -73.935242
        let mockDataResponse = """
            {
                "data": {
                    "places": {
                        "edges": [{
                            "node": {
                                "id": "\(id)",
                                "legacyId": "\(legacyId)",
                                "name": "\(name)",
                                "gps": {
                                    "lat": \(lat),
                                    "lng": \(long)
                                }
                            }
                        }]
                    }
                },
                "errors": null
            }
            """

        setupMockSession(data: mockDataResponse.data(using: .utf8)!, responseStatusCode: 200)

        let expectation = XCTestExpectation(description: "Successful data retrieval")

        sut.fetchGraphQLData(request: request)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error received: \(error)")
                }
            }, receiveValue: { (result: PlacesResponse) in
                // Compare the returned result with the mock data
                
                XCTAssertEqual(result.places.edges.first?.node.id, id)
                XCTAssertEqual(result.places.edges.first?.node.legacyId, legacyId)
                XCTAssertEqual(result.places.edges.first?.node.name, name)
                XCTAssertEqual(result.places.edges.first?.node.gps.lat, lat)
                XCTAssertEqual(result.places.edges.first?.node.gps.long, -73.935242)
                
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNon200HTTPResponse() {
        mockSession.data = nil
        mockSession.response = HTTPURLResponse(
            url: url,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = XCTestExpectation(description: "Expecting a bad server response error")
        sut.fetchGraphQLData(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case .failure(let error):
                    // Check if the received error is the expected URLError for bad server response.
                    if case URLError.badServerResponse = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Received unexpected error: \(error)")
                    }
                }
            }, receiveValue: { (_: PlacesResponse) in
                XCTFail("Unexpected success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGraphQLErrorResponse() {
        let errorMessage = "Some GraphQL error \(String.randomAlphanumeric(of: 10))"
        
        // Mocking a GraphQL error response using the error message.
        let errorResponse = """
        {
            "errors": [{
                "message": "\(errorMessage)"
            }]
        }
        """
        
        setupMockSession(data: errorResponse.data(using: .utf8)!, responseStatusCode: 200)
        
        let expectation = XCTestExpectation(description: "Expect a GraphQL error")
        sut.fetchGraphQLData(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case .failure(let error):
                    // Check if the received error matches the expected NetworkRoverError using the error message.
                    XCTAssertEqual(error as? NetworkRoverError, NetworkRoverError.serverError(message: errorMessage))
                    expectation.fulfill()
                }
            }, receiveValue: { (_: PlacesResponse) in
                XCTFail("Unexpected data received")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testInvalidGraphQlResponse() {
        // Mocking a GraphQL response without a value for the 'data' key.
        let invalidResponse = "{ }"
        
        setupMockSession(data: invalidResponse.data(using: .utf8)!, responseStatusCode: 200)

        let expectation = XCTestExpectation(description: "Expecting an invalid GraphQL response error")
        sut.fetchGraphQLData(request: request)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Unexpected success")
                case .failure(let error):
                    // Check if the received error matches the expected NetworkRoverError.
                    XCTAssertEqual(error as? NetworkRoverError, NetworkRoverError.invalidResponse)
                    expectation.fulfill()
                }
            }, receiveValue: { (_: PlacesResponse) in
                XCTFail("Unexpected data received")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testDecodingError() {
        let invalidData = String.randomAlphanumeric(of: 10)
            .data(using: .utf8)!
        setupMockSession(data: invalidData, responseStatusCode: 200)

        let expectation = XCTestExpectation(description: "Expecting a decoding error")

        sut.fetchGraphQLData(request: request)
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    // DecodingError is thrown when decoding fails
                    expectation.fulfill()
                }
            }, receiveValue: { (_: PlacesResponse) in
                XCTFail("Unexpected success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
