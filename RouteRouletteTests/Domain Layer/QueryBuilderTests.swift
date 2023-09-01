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
        let expectedQueryString = expectedPlaceQuery(for: searchTerm)
        
        let generatedQuery = sut.build(for: .place(searchTerm: searchTerm))
        XCTAssertEqual(generatedQuery, expectedQueryString)
    }
    
    func testBuildPlaceQueryWithNilSearchTerm() {
        let expectedQueryString = expectedPlaceQuery(for: "")
        
        let generatedQuery = sut.build(for: .place(searchTerm: nil))
        XCTAssertEqual(generatedQuery, expectedQueryString)
    }
    
    func testBuildFlightQuery() {
        let sourceIds = ["ID1", "ID2"]
        let destinationIds = ["DEST1", "DEST2"]
        
        let generatedQuery = sut.build(for: .flight(sourceIdentifiers: sourceIds, destinationIdentifiers: destinationIds))
        XCTAssertEqual(generatedQuery, "") // Currently it should return an empty string
    }
    
    private func expectedPlaceQuery(for searchTerm: String) -> String {
        """
        query places {
            places(
                search: { term: "\(searchTerm)" },
                filter: {
                    onlyTypes: [AIRPORT, CITY],
                    groupByCity: true
                },
                options: { sortBy: RANK },
                first: 20
            ) {
                ... on PlaceConnection {
                    edges { node { id legacyId name gps { lat lng } } }
                }
            }
        }
        """
    }
}
