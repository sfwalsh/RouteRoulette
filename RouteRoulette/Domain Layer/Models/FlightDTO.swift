//
//  FlightDTO.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation

struct FlightDTO: Equatable {
    
    /*
     Flattening the keys we need from the itinerary response into a single domain object for convenience
     */
    
    let id: String
    let totalDuration: Int
    let priceEur: String
    let stops: [FlightsResponse.Segment]
    
    init(from itinerary: FlightsResponse.Itinerary) {
        self.id = itinerary.id
        self.totalDuration = itinerary.duration
        self.priceEur = itinerary.priceEur.amount
        self.stops = itinerary.sector.sectorSegments.map { $0.segment }
    }
}
