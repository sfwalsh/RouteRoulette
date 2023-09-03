//
//  FlightsResponse.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 02/09/2023.
//

import Foundation

struct FlightsResponse: Decodable, Equatable {
    let onewayItineraries: OnewayItineraries
}

// MARK: Grouped under the same name space for tidiness
extension FlightsResponse {
    
    /* Corner cutting note: Models aren't complete representations of the response returned from the backend,
     many keys are omitted for brevity
     */
    struct OnewayItineraries: Decodable, Equatable {
        let itineraries: [Itinerary]
    }

    struct Itinerary: Decodable, Equatable {
        let id: String
        let duration: Int
        let priceEur: Price
        let sector: Sector
    }
    
    struct Price: Decodable, Equatable {
        let amount: String
    }
    
    struct Sector: Decodable, Equatable {
        let id: String
        let duration: Int
        let sectorSegments: [SectorSegment]
    }
    
    struct SectorSegment: Decodable, Equatable {
        let segment: Segment
    }
    
    struct Segment: Decodable, Equatable {
        let id: String
        let duration: Int
        let source: StopDetail
        let destination: StopDetail
        let carrier: Carrier
    }
    
    struct Carrier: Decodable, Equatable {
        let id, name, code: String
    }
    
    struct StopDetail: Decodable, Equatable {
        let utcTime, localTime: String
        let station: Station
    }
    
    struct Station: Decodable, Equatable {
        let id, name, code, type: String
        let city: City
    }
    
    struct City: Decodable, Equatable {
        let id, legacyId, name: String
        let country: Country
    }
    
    struct Country: Decodable, Equatable {
        let id, name: String
    }
}
