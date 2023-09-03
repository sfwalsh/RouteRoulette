//
//  FlightDatasourceTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import XCTest
import Combine
@testable import RouteRoulette

final class FlightDatasourceTests: XCTestCase {
    
    var sut: DefaultFlightDatasource!
    var mockNetworkRover: MockNetworkRover!
    var mockQueryBuilder: MockQueryBuilder!
    var mockAPIRequestBuilder: MockAPIRequestBuilder!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockNetworkRover = MockNetworkRover()
        mockQueryBuilder = MockQueryBuilder()
        mockAPIRequestBuilder = MockAPIRequestBuilder()
        
        sut = DefaultFlightDatasource(
            networkRover: mockNetworkRover,
            queryBuilder: mockQueryBuilder,
            apiRequestBuilder: mockAPIRequestBuilder
        )
        
        cancellables = []
    }
    
    func testSuccessfulFlightDataFetching() {
        let expectedResponse = FlightsResponse(onewayItineraries: FlightsResponse.OnewayItineraries(itineraries: []))
        mockNetworkRover.responseObject = expectedResponse
        
        let result = sut.fetch(sourcePlaces: [], destinationPlaces: nil, dateRangeBeginning: "", dateRangeEnd: "")
        
        result.sink(receiveCompletion: { completion in
            switch completion {
            case .failure:
                XCTFail("Expected success but got failure")
            case .finished:
                break
            }
        }, receiveValue: { response in
            XCTAssertEqual(response, expectedResponse)
        })
        .store(in: &cancellables)
    }
    
    func testNetworkRoverFailure() {
        mockNetworkRover.responseObject = nil // nil denotes a failure in the network response
        
        let result = sut.fetch(sourcePlaces: [], destinationPlaces: nil, dateRangeBeginning: "", dateRangeEnd: "")
        
        result.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTAssertEqual(error as? NetworkRoverError, NetworkRoverError.serverError(message: "Network error"))
            case .finished:
                XCTFail("Expected failure but got success")
            }
        }, receiveValue: { _ in
            XCTFail("Expected failure but got value")
        })
        .store(in: &cancellables)
    }
    
    func testAPIRequestBuilderFailure() {
        mockAPIRequestBuilder.shouldSucceed = false
        
        let result = sut.fetch(sourcePlaces: [], destinationPlaces: nil, dateRangeBeginning: "", dateRangeEnd: "")
        
        result.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                XCTAssertEqual(error as? APIRequestBuilder.Default.HTTPError, APIRequestBuilder.Default.HTTPError.invalidURL)
            case .finished:
                XCTFail("Expected failure but got success")
            }
        }, receiveValue: { _ in
            XCTFail("Expected failure but got value")
        })
        .store(in: &cancellables)
    }
}
