//
//  FetchFlightsTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation
import XCTest
import Combine
@testable import RouteRoulette

final class FetchFlightsTests: XCTestCase {
    
    private var sut: DefaultFetchFlights!
    private var mockFlightRepository: MockFlightRepository!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockFlightRepository = MockFlightRepository()
        sut = DefaultFetchFlights(repository: mockFlightRepository)
        cancellables = []
    }
    
    func testSuccessfulFlightFetching() {
        let mockFlightsDTOs = [
            FlightDTO(from: .init(id: "", duration: 1, priceEur: .init(amount: ""), sector: .init(id: "", duration: 1, sectorSegments: [])))
        ]
        
        mockFlightRepository.mockedResponse = mockFlightsDTOs
        
        let requestValues = FetchFlightsRequestValues(
            sourcePlaces: [Place(id: "source1", legacyId: "123", name: "Place A", gps: GPSCoordinate(lat: 0.0, long: 0.0))],
            destinationPlaces: [Place(id: "dest1", legacyId: "456", name: "Place B", gps: GPSCoordinate(lat: 1.0, long: 1.0))],
            dateRangeBeginning: "2023-07-01T00:00:00",
            dateRangeEnd: "2023-07-10T00:00:00"
        )
        
        let expectation = XCTestExpectation(description: "Flights fetched successfully")
        
        sut.invoke(requestValues: requestValues)
        .sink(receiveCompletion: { _ in }, receiveValue: { fetchedDTOs in
            XCTAssertEqual(fetchedDTOs, mockFlightsDTOs)
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFailedFlightFetching() {
        mockFlightRepository.shouldFail = true
        
        let requestValues = FetchFlightsRequestValues(
            sourcePlaces: [Place(id: "source1", legacyId: "123", name: "Place A", gps: GPSCoordinate(lat: 0.0, long: 0.0))],
            destinationPlaces: [Place(id: "dest1", legacyId: "456", name: "Place B", gps: GPSCoordinate(lat: 1.0, long: 1.0))],
            dateRangeBeginning: "2023-07-01T00:00:00",
            dateRangeEnd: "2023-07-10T00:00:00"
        )
        
        let expectation = XCTestExpectation(description: "Flights fetching failed")
        
        sut.invoke(requestValues: requestValues)
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
        mockFlightRepository = nil
        cancellables = nil
        super.tearDown()
    }
}
