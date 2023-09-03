//
//  MockAPIRequestBuilder.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
@testable import RouteRoulette

final class MockAPIRequestBuilder: APIRequestBuilder {
    var shouldSucceed = true
    
    func create(forQueryString queryString: String) throws -> URLRequest {
        if shouldSucceed {
            return URLRequest(url: URL(string: "http://test.com")!)
        } else {
            throw APIRequestBuilder.Default.HTTPError.invalidURL
        }
    }
}
