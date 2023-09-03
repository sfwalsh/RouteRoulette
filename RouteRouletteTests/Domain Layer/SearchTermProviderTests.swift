//
//  SearchTermProviderTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 03/09/2023.
//

import Foundation
import XCTest
@testable import RouteRoulette

final class SearchTermProviderTests: XCTestCase {
    
    var sut: DefaultSearchTermProvider!
    
    override func setUp() {
        super.setUp()
    }
    
    // corner cutting note: tests should be more verbose, and wouldn't normally test for a single term
    func testGenerateSearchTermWithExactYearLength() {
        let terms = Array(repeating: "TestTerm", count: 365)
        sut = DefaultSearchTermProvider(searchTerms: terms)
        
        let generatedTerm = sut.generate()
        XCTAssertNotNil(generatedTerm)
        XCTAssertEqual(generatedTerm, "TestTerm")
    }

    func testGenerateSearchTermWithSmallList() {
        let terms = ["A", "B", "C", "D", "E"]
        sut = DefaultSearchTermProvider(searchTerms: terms)
        
        let generatedTerm = sut.generate()
        XCTAssertNotNil(generatedTerm)
        XCTAssertTrue(terms.contains(generatedTerm))
    }
    
    func testDayNumberInRange() {
        let terms = ["A", "B", "C", "D", "E"]
        sut = DefaultSearchTermProvider(searchTerms: terms)
        let dayNumber = sut.dayNumberOfTheYear()
        XCTAssertNotNil(dayNumber)
        XCTAssertTrue(1...365 ~= dayNumber! || 1...366 ~= dayNumber!) // for leap years
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
