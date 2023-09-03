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
    
    static func create() -> Self {
        // Corner cutting Note: localised strings should be used in a production app.
        // I had intended to "Spotlight" on a particular region depending on the month of the year, e.g Central America, or the Arabian Peninusla, but ran out of time to implement this logic
        let cities = [
            // Europe
            "London", "Paris", "Rome", "Berlin", "Madrid", "Prague", "Athens", "Warsaw", "Dublin", "Stockholm",
            "Vienna", "Oslo", "Copenhagen", "Helsinki", "Lisbon", "Budapest", "Bucharest", "Zurich", "Barcelona", "Geneva",
            "Amsterdam", "Brussels", "Marseille", "Milan", "Munich", "Frankfurt", "Edinburgh", "Glasgow", "Birmingham", "Saint Petersburg",
            "Kiev", "Belgrade", "Riga", "Vilnius", "Sofia",
            
            // North America
            "Toronto", "Los Angeles", "New York", "Mexico City", "Chicago", "Vancouver", "Montreal", "Miami", "San Francisco", "Washington DC",
            "Houston", "Philadelphia", "Dallas", "San Diego", "Phoenix", "Nashville", "Denver", "Austin", "Boston", "Seattle",
            "Las Vegas", "Atlanta", "Orlando", "Saint Louis", "Indianapolis", "Columbus", "San Antonio", "Portland", "Pittsburgh", "Charlotte",
            
            // Asia
            "Tokyo", "Mumbai", "Beijing", "Bangkok", "Singapore", "Seoul", "Jakarta", "Kuala Lumpur", "Shanghai", "Hong Kong",
            "Manila", "Ho Chi Minh City", "Chengdu", "Tianjin", "Delhi", "Dhaka", "Osaka", "Karachi", "Taipei", "Guangzhou",
            "Shenzhen", "Bangalore", "Kolkata", "Lahore", "Chennai", "Chongqing", "Hangzhou", "Wuhan", "Tehran", "Ahmedabad",
            
            // Africa
            "Cape Town", "Cairo", "Nairobi", "Lagos", "Casablanca", "Johannesburg", "Addis Ababa", "Dar es Salaam", "Accra", "Tunis",
            "Algiers", "Khartoum", "Luanda", "Tripoli", "Windhoek", "Gaborone", "Lusaka", "Maputo", "Hargeisa", "Mogadishu",
            "Lilongwe", "Bamako", "Ouagadougou", "Maseru", "Rabat", "Freetown", "Djibouti", "Kigali", "Bissau", "Monrovia",
            
            // South America
            "Rio de Janeiro", "Buenos Aires", "Lima", "Santiago", "Bogotá", "Caracas", "Brasília", "Quito", "Montevideo", "Asunción",
            "La Paz", "Georgetown", "Paramaribo", "Sucre", "Lima", "Santa Fe", "Valparaíso", "Córdoba", "Salvador", "Fortaleza",
            "Recife", "Manaus", "Curitiba", "Belém", "Goiania", "Guayaquil", "Barranquilla", "Rosario", "Mendoza", "Medellín",
            
            // Oceania
            "Sydney", "Melbourne", "Brisbane", "Perth", "Adelaide", "Gold Coast", "Canberra", "Auckland", "Wellington", "Christchurch",
            "Dunedin", "Fiji", "Suva", "Papeete", "Noumea", "Hobart", "Launceston", "Wollongong", "Geelong", "Newcastle"
        ]

        return DefaultSearchTermCollection(id: "all", name: "All", searchTerms: cities)
    }
}
