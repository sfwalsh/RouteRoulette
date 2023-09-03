//
//  FlightDTOTests.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 03/09/2023.
//

import Foundation
import XCTest
@testable import RouteRoulette

final class FlightDTOTests: XCTestCase {
    
    func testInitializationFromItinerary() {
        let price = FlightsResponse.Price(amount: "150")
        let station = FlightsResponse.Station(id: "ST1", name: "TestStation", code: "TS", type: "Airport", city: FlightsResponse.City(id: "C1", legacyId: "LC1", name: "City1", country: FlightsResponse.Country(id: "CO1", name: "Country1")))
        let stopDetail = FlightsResponse.StopDetail(utcTime: "12:00", localTime: "14:00", station: station)
        let carrier = FlightsResponse.Carrier(id: "CA1", name: "Carrier1", code: "C1")
        let segment = FlightsResponse.Segment(id: "SG1", duration: 120, source: stopDetail, destination: stopDetail, carrier: carrier)
        let sectorSegment = FlightsResponse.SectorSegment(segment: segment)
        let sector = FlightsResponse.Sector(id: "SEC1", duration: 240, sectorSegments: [sectorSegment])
        let itinerary = FlightsResponse.Itinerary(id: "IT1", duration: 240, priceEur: price, sector: sector)

        let dto = FlightDTO(from: itinerary)

        XCTAssertEqual(dto.id, "IT1")
        XCTAssertEqual(dto.totalDuration, 240)
        XCTAssertEqual(dto.priceEur, "150")
        XCTAssertEqual(dto.stops, [segment])
    }
}
