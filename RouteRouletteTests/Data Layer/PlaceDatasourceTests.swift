//
//  PlaceDatasourceTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 31/08/2023.
//

import XCTest
import Combine
@testable import RouteRoulette

final class PlaceDatasourceTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockNetworkRover: MockNetworkRover!
    var mockQueryBuilder: MockQueryBuilder!
    var mockAPIRequestBuilder: MockAPIRequestBuilder!
    var sut: DefaultPlaceDatasource!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockNetworkRover = MockNetworkRover()
        mockQueryBuilder = MockQueryBuilder()
        mockAPIRequestBuilder = MockAPIRequestBuilder()
        sut = DefaultPlaceDatasource(networkRover: mockNetworkRover,
                                            queryBuilder: mockQueryBuilder,
                                            apiRequestBuilder: mockAPIRequestBuilder)
    }
    
    func testSuccessfulFetch() {
        let searchTerm = String.randomAlphanumeric(of: 9)
        let expectedQueryString = "query: {\(searchTerm)}"
        mockQueryBuilder.returnedString = expectedQueryString
        mockAPIRequestBuilder.shouldSucceed = true
        mockNetworkRover.shouldSucceed = true
        
        let expectation = XCTestExpectation(description: "Successful fetch")
        
        sut.fetch(forSearchTerm: searchTerm)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Error received: \(error)")
                }
            }, receiveValue: { _ in
                XCTAssertEqual(self.mockQueryBuilder.lastSearchTerm, searchTerm)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAPIRequestBuilderFailure() {
        let searchTerm = "testTerm"
        mockAPIRequestBuilder.shouldSucceed = false
        
        let expectation = XCTestExpectation(description: "Expecting an API request builder error")
        
        sut.fetch(forSearchTerm: searchTerm)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? APIRequestBuilder.Default.HTTPError, .invalidURL)
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected success")
                }
            }, receiveValue: { _ in
                XCTFail("Unexpected success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNetworkRoverFailure() {
        let searchTerm = String.randomAlphanumeric(of: 9)
        let expectedQueryString = "query: {\(searchTerm)}"
        mockQueryBuilder.returnedString = expectedQueryString
        mockAPIRequestBuilder.shouldSucceed = true
        mockNetworkRover.shouldSucceed = false
        
        let expectation = XCTestExpectation(description: "Expecting a network rover error")
        
        sut.fetch(forSearchTerm: searchTerm)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error as? NetworkRoverError, NetworkRoverError.serverError(message: "Network error"))
                    expectation.fulfill()
                } else {
                    XCTFail("Unexpected success")
                }
            }, receiveValue: { _ in
                XCTFail("Unexpected success")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
