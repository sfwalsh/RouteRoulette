//
//  NetworkRoverError.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

enum NetworkRoverError: Error, Equatable {
    case invalidResponse
    case serverError(message: String?)
}
