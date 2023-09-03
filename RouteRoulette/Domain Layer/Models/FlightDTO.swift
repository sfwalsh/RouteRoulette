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
    let stopCount: Int
    let sourceName: String
    let destinationName: String
    let departureDate: Date
    
    init(id: String, totalDuration: Int, priceEur: String, stopCount: Int, sourceName: String, destinationName: String, departureDate: Date) {
        self.id = id
        self.totalDuration = totalDuration
        self.priceEur = priceEur
        self.stopCount = stopCount
        self.sourceName = sourceName
        self.destinationName = destinationName
        self.departureDate = departureDate
    }
    
    init?(from itinerary: FlightsResponse.Itinerary, stringToDateFormatter: StringToDateFormatter) {
        guard let sourceSegment = itinerary.sector.sectorSegments.first,
              let destinationSegment = itinerary.sector.sectorSegments.first else {
            // assuming that every journey has a beginning and an end 😀
            return nil
        }
        
        self.id = itinerary.id
        self.totalDuration = itinerary.duration
        self.priceEur = itinerary.priceEur.amount
        
        self.stopCount = max(0, itinerary.sector.sectorSegments.count - 2) // subtracting two to account for the source and destination segments
        
        self.sourceName = sourceSegment.segment.source.station.name
        self.destinationName = destinationSegment.segment.destination.station.name
        
        self.departureDate = stringToDateFormatter
            .format(forDateString: sourceSegment.segment.source.localTime) ?? Date()
    }
}
