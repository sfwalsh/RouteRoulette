//
//  DefaultPlaceRepositoryTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import XCTest
import Combine
@testable import RouteRoulette

final class PlaceRepositoryTests: XCTestCase {
    
    var mockDatasource: MockPlaceDatasource!
    var sut: DefaultPlaceRepository!
    var cancellables: Set<AnyCancellable>!
    
    let mockPlace: Place = {
        Place(
            id: String.randomAlphanumeric(of: 6),
            legacyId: String.randomAlphanumeric(of: 10),
            name: String.randomAlphanumeric(of: 12),
            gps: GPSCoordinate(lat: 150.0, long: -150.0)
        )
    }()
    
    var mockResponse: PlacesResponse {
        let mockEdge = PlacesResponse.PlaceEdge(node: mockPlace)
        let mockConnection = PlacesResponse.PlaceConnection(edges: [mockEdge])
        return PlacesResponse(places: mockConnection)
    }
    
    override func setUp() {
        super.setUp()
        mockDatasource = MockPlaceDatasource()
        sut = DefaultPlaceRepository(remoteDatasource: mockDatasource)
        cancellables = []
    }
    
    func testFetchForSearchTerm() {
        let searchTerm = String.randomAlphanumeric(of: 12)
        mockDatasource.mockedPlacesResponse = mockResponse
        let expectation = XCTestExpectation(description: "Fetch places for valid term")
        
        sut.fetch(forSearchTerm: searchTerm)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            }, receiveValue: { places in
                XCTAssertEqual(places, [self.mockPlace])
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchForBlankTerm() {
        mockDatasource.mockedPlacesResponse = mockResponse
        
        let expectation = XCTestExpectation(description: "Fetch places for empty term")
        
        sut.fetch(forSearchTerm: nil)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Unexpected error: \(error)")
                }
            }, receiveValue: { places in
                XCTAssertEqual(places, [self.mockPlace])
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
}
