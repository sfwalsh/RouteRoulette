//
//  API.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

protocol APIRequestBuilder {
    typealias Default = DefaultAPIRequestBuilder
    func create(forQueryString queryString: String) throws -> URLRequest
}

struct DefaultAPIRequestBuilder: APIRequestBuilder {
    
    private let baseURL: String
    
    init(baseURL: String = "https://api.skypicker.com/umbrella/v2/graphql") {
        self.baseURL = baseURL
    }
    
    func create(forQueryString queryString: String) throws -> URLRequest {
        guard let url = URL(string: baseURL) else {
            throw HTTPError.invalidURL
        }
        
        // Corner cutting note: for extensibility in the future, urlcomponents could be used here, to share functionality between different request types, for example GraphQL requests and regular API requests may have shared code
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPActions.post.rawValue
        request.addValue(HTTPHeaders.applicationJSON.rawValue, forHTTPHeaderField: HTTPHeaders.contentType.rawValue)
        
        let body = [RequestBodyKeys.query.rawValue: queryString]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        return request
    }
}

// MARK: Internal helpers for tidiness

extension DefaultAPIRequestBuilder {
    
    private static let graphQLBaseURLString = ""
    
    private enum HTTPActions: String {
        case post = "POST"
    }
    
    private enum HTTPHeaders: String {
        case applicationJSON = "application/json"
        case contentType = "Content-Type"
    }
    
    private enum RequestBodyKeys: String {
        case query
    }
    
    // Corner cutting note: error handling not implemented
    enum HTTPError: Error {
        case invalidURL
    }
}
