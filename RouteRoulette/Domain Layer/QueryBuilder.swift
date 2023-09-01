//
//  QueryBuilder.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

enum QueryType {
    case place(searchTerm: String?)
    case flight(sourceIdentifiers: [String], destinationIdentifiers: [String])
}

protocol QueryBuilder {
    typealias Default = DefaultQueryBuilder
    func build(for queryType: QueryType) -> String
}

struct DefaultQueryBuilder: QueryBuilder {
    func build(for queryType: QueryType) -> String {
        switch queryType {
        case .place(let searchTerm):
            return buildPlaceQuery(forSearchTerm: searchTerm)
        case .flight(let sourceIdentifiers, let destinationIdentifiers):
            return "" // todo
        }
    }
    
    private func buildPlaceQuery(forSearchTerm searchTerm: String?) -> String {
        // corner cutting: I don't really like using a String interpolation for injecting the search term here
        // In a real app I would probably opt for some sort of builder that takes in a json structure and outputs a graphql query
        // perhaps a library
        """
        query places {
            places(
                search: { term: "\(searchTerm ?? "")" },
                filter: {
                    onlyTypes: [AIRPORT, CITY],
                    groupByCity: true
                },
                options: { sortBy: RANK },
                first: 20
            ) {
                ... on PlaceConnection {
                    edges { node { id legacyId name gps { lat lng } } }
                }
            }
        }
        """
    }

}
