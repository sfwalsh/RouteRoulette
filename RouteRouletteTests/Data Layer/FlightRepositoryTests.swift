//
//  FlightRepositoryTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import XCTest
import Combine
@testable import RouteRoulette

final class FlightRepositoryTests: XCTestCase {
    
    private var sut: DefaultFlightRepository!
    private var mockFlightDatasource: MockFlightDatasource!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockFlightDatasource = MockFlightDatasource()
        sut = DefaultFlightRepository(remoteDatasource: mockFlightDatasource)
        cancellables = []
    }
    
    func testSuccessfulFlightFetching() {
        let mockFlights = [
            FlightsResponse.Itinerary(
                id: "1",
                duration: 120,
                priceEur: FlightsResponse.Price(amount: "100.00"),
                sector: FlightsResponse.Sector(id: "sector1", duration: 60, sectorSegments: [])
            )
        ]
        
        let expectedDTOs = mockFlights.map { FlightDTO(from: $0) }
        
        mockFlightDatasource.mockedResponse = FlightsResponse(onewayItineraries: FlightsResponse.OnewayItineraries(itineraries: mockFlights))
        
        let expectation = XCTestExpectation(description: "Flights fetched successfully")
        
        sut.fetch(
            sourcePlaces: [Place(id: "source1", legacyId: "123", name: "Place A", gps: GPSCoordinate(lat: 0.0, long: 0.0))],
            destinationPlaces: [Place(id: "dest1", legacyId: "456", name: "Place B", gps: GPSCoordinate(lat: 1.0, long: 1.0))],
            dateRangeBeginning: "2023-07-01T00:00:00",
            dateRangeEnd: "2023-07-10T00:00:00"
        )
        .sink(receiveCompletion: { _ in }, receiveValue: { fetchedDTOs in
            XCTAssertEqual(fetchedDTOs, expectedDTOs)
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFailedFlightFetching() {
        mockFlightDatasource.shouldSucceed = false
        
        let expectation = XCTestExpectation(description: "Flights fetching failed")
        
        sut.fetch(
            sourcePlaces: [Place(id: "source1", legacyId: "123", name: "Place A", gps: GPSCoordinate(lat: 0.0, long: 0.0))],
            destinationPlaces: [Place(id: "dest1", legacyId: "456", name: "Place B", gps: GPSCoordinate(lat: 1.0, long: 1.0))],
            dateRangeBeginning: "2023-07-01T00:00:00",
            dateRangeEnd: "2023-07-10T00:00:00"
        )
        .sink(receiveCompletion: { completion in
            if case .failure = completion {
                expectation.fulfill()
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    override func tearDown() {
        sut = nil
        mockFlightDatasource = nil
        cancellables = nil
        super.tearDown()
    }
}
