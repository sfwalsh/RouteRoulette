//
//  GPSCoordinate.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

struct GPSCoordinate: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case lat
        case long = "lng"
    }
    
    let lat: Double
    let long: Double
}
