//
//  SearchTermCollections.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import Foundation

protocol SearchTermCollection {
    typealias Default = DefaultSearchTermCollection
    var id: String { get }
    var name: String { get }
    var searchTerms: [String] { get }
}

struct DefaultSearchTermCollection {
    let id: String
    let name: String
    let searchTerms: [String]
}

extension DefaultSearchTermCollection {
    static func createEurope() -> Self {
        // Corner cutting Note: localised strings should be used in a production app
        DefaultSearchTermCollection(id: "eu", name: "Europe", searchTerms: [
            "London",
            "Paris",
            "Rome",
            "Berlin",
            "Madrid",
            "Prague",
            "Athens",
            "Warsaw",
            "Dublin",
            "Stockholm"
        ]
        )
    }
    static func createNorthAmerica() -> Self {
        // Corner cutting Note: localised strings should be used in a production app
        DefaultSearchTermCollection(id: "na", name: "North America", searchTerms: [
            "Toronto",
            "Los Angeles",
            "New York",
            "Mexico City",
            "Chicago",
            "Vancouver",
            "Montreal",
            "Miami",
            "San Francisco",
            "Washington DC"
        ]
        )
    }
    static func createAsia() -> Self {
        // Corner cutting Note: localised strings should be used in a production app
        DefaultSearchTermCollection(id: "asia", name: "Asia", searchTerms: [
            "Tokyo",
            "Mumbai",
            "Beijing",
            "Bangkok",
            "Singapore",
            "Seoul",
            "Jakarta",
            "Kuala Lumpur",
            "Shanghai",
            "Hong Kong"
        ]
        )
    }
    static func createAfrica() -> Self {
        // Corner cutting Note: localised strings should be used in a production app
        DefaultSearchTermCollection(id: "africa", name: "Africa", searchTerms: [
            "Cape Town",
            "Cairo",
            "Nairobi",
            "Lagos",
            "Casablanca",
            "Johannesburg",
            "Addis Ababa",
            "Dar es Salaam",
            "Accra",
            "Tunis"
        ]
        )
    }
    static func createSouthAmerica() -> Self {
        // Corner cutting Note: localised strings should be used in a production app
        DefaultSearchTermCollection(id: "sa", name: "South America", searchTerms:  [
            "Rio de Janeiro",
            "Buenos Aires",
            "Lima",
            "Santiago",
            "Bogotá",
            "Caracas",
            "Brasília",
            "Quito",
            "Montevideo",
            "Asunción"
        ]
        )
    }
}
