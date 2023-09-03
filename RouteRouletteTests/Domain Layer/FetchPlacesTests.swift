//
//  FetchPlacesTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import XCTest
import Combine
@testable import RouteRoulette

final class FetchPlacesTests: XCTestCase {

    private var cancellables: Set<AnyCancellable>!
    private var useCase: FetchPlaces.Default!
    private var mockRepository: MockPlaceRepository!

    override func setUp() {
        super.setUp()
        cancellables = []
        mockRepository = MockPlaceRepository()
        useCase = FetchPlaces.Default(repository: mockRepository)
    }

    func testSuccessfulFetch() {
        // Arrange
        let mockPlace = Place(
            id: "testID",
            legacyId: "legacyTestID",
            name: "testPlace",
            gps: GPSCoordinate(lat: 40.0, long: -70.0)
        )
        mockRepository.mockedSuccessResponse = [mockPlace]

        let expectation = XCTestExpectation(description: "Fetch places successfully")

        // Act
        useCase.invoke(requestValues: FetchPlacesRequestValues(searchTerm: "test"))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success but got \(error)")
                }
            }, receiveValue: { places in
                XCTAssertEqual(places, [mockPlace])
                expectation.fulfill()
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedFetch() {
        // Arrange
        mockRepository.mockedError = NSError(domain: "test", code: 0, userInfo: nil)

        let expectation = XCTestExpectation(description: "Fetch places fails")

        // Act
        useCase.invoke(requestValues: FetchPlacesRequestValues(searchTerm: "test"))
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    XCTFail("Expected failure but completed successfully")
                case .failure:
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure but got places")
            })
            .store(in: &cancellables)

        // Assert
        wait(for: [expectation], timeout: 1.0)
    }

    func testSearchTermPassedCorrectly() {
        // Arrange
        let searchTerm = "testSearch"
        mockRepository.mockedSuccessResponse = []

        // Act
        useCase.invoke(requestValues: FetchPlacesRequestValues(searchTerm: searchTerm))
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)

        // Assert
        XCTAssertEqual(mockRepository.lastReceivedSearchTerm, searchTerm)
    }
}
