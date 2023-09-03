//
//  PlacesResponse.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

struct PlacesResponse: Decodable, Equatable {
    let places: PlaceConnection

    init(places: PlaceConnection) {
        self.places = places
    }
}

// MARK: Grouped under the same name space for tidiness
extension PlacesResponse {
    
    struct PlaceConnection: Decodable, Equatable {
        let edges: [PlaceEdge]
        init(edges: [PlaceEdge]) {
            self.edges = edges
        }
    }

    struct PlaceEdge: Decodable, Equatable {
        let node: Place
        init(node: Place) {
            self.node = node
        }
    }
}
