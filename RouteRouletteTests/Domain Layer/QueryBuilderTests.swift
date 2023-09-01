//
//  QueryBuilderTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import XCTest
@testable import RouteRoulette

final class QueryBuilderTests: XCTestCase {
    
    var sut: DefaultQueryBuilder!
    
    override func setUp() {
        super.setUp()
        sut = DefaultQueryBuilder()
    }
    
    func testBuildPlaceQueryWithValidSearchTerm() {
        let searchTerm = "Paris CDG"
        let generatedQuery = sut.build(for: .place(searchTerm: searchTerm))
        
        XCTAssertTrue(generatedQuery.contains("places("))
        XCTAssertTrue(generatedQuery.contains("term: \"\(searchTerm)\""))
    }
    
    func testBuildPlaceQueryWithNilSearchTerm() {
        let generatedQuery = sut.build(for: .place(searchTerm: nil))
        
        XCTAssertTrue(generatedQuery.contains("places("))
        XCTAssertTrue(generatedQuery.contains("term: \"\""))
    }
    
    func testBuildFlightQuery() {
        let sourceIds = ["ID1", "ID2"]
        let destinationIds = ["DEST1", "DEST2"]
        let startDate = "2023-07-01T00:00:00"
        let endDate = "2023-07-07T23:59:59"
        
        let generatedQuery = sut.build(for: .flight(sourceIdentifiers: sourceIds, destinationIdentifiers: destinationIds, dateRangeBeginning: startDate, dateRangeEnd: endDate))
        
        XCTAssertTrue(generatedQuery.contains("onewayItineraries("))
        XCTAssertTrue(generatedQuery.contains("ids: [\"ID1\", \"ID2\"]"))
        XCTAssertTrue(generatedQuery.contains("ids: [\"DEST1\", \"DEST2\"]"))
        XCTAssertTrue(generatedQuery.contains("start: \(startDate)"))
        XCTAssertTrue(generatedQuery.contains("end: \(endDate)"))
    }
}
