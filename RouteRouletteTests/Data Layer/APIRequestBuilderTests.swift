//
//  DefaultAPIRequestBuilderTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import XCTest
@testable import RouteRoulette

final class APIRequestBuilderTests: XCTestCase {
    
    var sut: DefaultAPIRequestBuilder!
    
    override func setUp() {
        super.setUp()
        sut = DefaultAPIRequestBuilder()
    }
    
    func testRequestCreationWithDefaultBaseURL() {
        let queryString = "Test Query"
        
        do {
            let request = try sut.create(forQueryString: queryString)
            
            // Assert URL is correct
            XCTAssertEqual(request.url?.absoluteString, "https://api.skypicker.com/umbrella/v2/graphql")
            
            // Assert HTTP method is POST
            XCTAssertEqual(request.httpMethod, "POST")
            
            // Assert Content-Type header is application/json
            XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
            
            // Assert Body contains the query
            let body = try JSONSerialization.jsonObject(with: request.httpBody!, options: []) as? [String: String]
            XCTAssertEqual(body?["query"], queryString)
            
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testRequestCreationWithCustomBaseURL() {
        let customURL = "https://custom.com/endpoint"
        sut = DefaultAPIRequestBuilder(baseURL: customURL)
        
        do {
            let request = try sut.create(forQueryString: "Another Test Query")
            XCTAssertEqual(request.url?.absoluteString, customURL)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
    
    func testErrorForInvalidURL() {
        sut = DefaultAPIRequestBuilder(baseURL: "Not a valid URL")
        
        do {
            let _ = try sut.create(forQueryString: "Test Query")
            XCTFail("Expected to throw an error but it succeeded")
        } catch DefaultAPIRequestBuilder.HTTPError.invalidURL {
            // This is the expected error. Do nothing.
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
