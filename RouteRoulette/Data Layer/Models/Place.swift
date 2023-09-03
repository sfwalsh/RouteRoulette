//
//  Place.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

struct Place: Decodable, Equatable {
    enum CodingKeys: String, CodingKey {
        case id, legacyId, name, gps
    }
    
    let id: String
    let legacyId: String
    let name: String
    let gps: GPSCoordinate
}
