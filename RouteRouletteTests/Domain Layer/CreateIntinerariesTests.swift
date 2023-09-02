//
//  CreateIntinerariesTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import XCTest
import Combine
@testable import RouteRoulette

final class CreateIntinerariesTests: XCTestCase {
    
    private var createIntineraries: CreateIntineraries!
    private var mockFetchFlights: MockFetchFlights!
    private var mockFetchPlaces: MockFetchPlaces!
    private var mockDateStringFormatter: MockDateStringFormatter!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        
        mockFetchFlights = MockFetchFlights()
        mockFetchPlaces = MockFetchPlaces()
        mockDateStringFormatter = MockDateStringFormatter()
        
        createIntineraries = CreateIntineraries(
            fetchFlights: mockFetchFlights,
            fetchPlaces: mockFetchPlaces,
            dateStringFormatter: mockDateStringFormatter
        )
        
        cancellables = []
    }
    
    func testInvokeFetchesPlacesAndFlights() {
        // Given
        
        // corner cutting note - mock objects could have some sort of autopopulating dummy static function for the tests
        let mockPlace = Place(
            id: .randomAlphanumeric(of: 2),
            legacyId: .randomAlphanumeric(of: 4),
            name: .randomAlphanumeric(of: 8),
            gps: .init(lat: 1, long: 2)
        )
        let mockFlight = FlightDTO(
            from: .init(
                id: .randomAlphanumeric(of: 2),
                duration: 2,
                priceEur: .init(amount: .randomAlphanumeric(of: 2)),
                sector: .init(id: .randomAlphanumeric(of: 2),
                              duration: 2,
                              sectorSegments: [])
            )
        )
        mockFetchPlaces.result = .success(
            [
                mockPlace
            ]
        )
        
        
        mockFetchFlights.result = .success(
            [
                mockFlight
            ]
        )
        
        let expectation = self.expectation(description: "Intineraries fetched successfully")
        
        // When
        createIntineraries.invoke(requestValues: .init(searchTerm: "TestTerm"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Expected successful fetch, but got \(completion)")
                }
            }, receiveValue: { flights in
                XCTAssertEqual(flights, [mockFlight])
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}
