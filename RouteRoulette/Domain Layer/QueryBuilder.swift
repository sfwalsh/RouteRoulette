//
//  QueryBuilder.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation

enum QueryType {
    case place(searchTerm: String?)
    case flight(sourceIdentifiers: [String], destinationIdentifiers: [String]?, dateRangeBeginning: String, dateRangeEnd: String)
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
        case .flight(let sourceIdentifiers, let destinationIdentifiers, let dateRangeBeginning, let dateRangeEnd):
            return buildFlightQuery(
                sourceIdentifiers: sourceIdentifiers,
                destinationIdentifiers: destinationIdentifiers,
                dateRangeBeginning: dateRangeBeginning,
                dateRangeEnd: dateRangeEnd
            )
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
    
    private func buildFlightQuery(
        sourceIdentifiers: [String],
        destinationIdentifiers: [String]?,
        dateRangeBeginning: String,
        dateRangeEnd: String
    ) -> String {
        // corner cutting: similar to above
        let formattedSourceIdentifiers = format(for: sourceIdentifiers)
        let formattedDestinationIdentifiers = format(for: destinationIdentifiers)
        
        return """
        fragment stopDetails on Stop {
          utcTime
          localTime
          station {
            id
            name
            code
            type
            city {
              id
              legacyId
              name
              country {
                id
                name
              }
            }
          }
        }
        
        query onewayItineraries {
          onewayItineraries(
            filter: {allowChangeInboundSource: false, allowChangeInboundDestination: false, allowDifferentStationConnection: true, allowOvernightStopover: true, contentProviders: [KIWI], limit: 10, showNoCheckedBags: true, transportTypes: [FLIGHT]}
            options: {currency: "EUR", partner: "skypicker", sortBy: QUALITY, sortOrder: ASCENDING, sortVersion: 4, storeSearch: true}
            search: {cabinClass: {applyMixedClasses: true, cabinClass: ECONOMY}, itinerary: {source: {ids: \(formattedSourceIdentifiers)}, destination: {ids: \(formattedDestinationIdentifiers)}, outboundDepartureDate: {start: \(dateRangeBeginning), end: \(dateRangeEnd)}}, passengers: {adults: 1, adultsHandBags: [1], adultsHoldBags: [0]}}
          ) {
            ... on Itineraries {
              itineraries {
                ... on ItineraryOneWay {
                  id
                  duration
                  cabinClasses
                  priceEur {
                    amount
                  }
                  bookingOptions {
                    edges {
                      node {
                        bookingUrl
                        price {
                          amount
                          formattedValue
                        }
                      }
                    }
                  }
                  provider {
                    id
                    name
                    code
                  }
                  sector {
                    id
                    duration
                    sectorSegments {
                      segment {
                        id
                        duration
                        type
                        code
                        source {
                          ...stopDetails
                        }
                        destination {
                          ...stopDetails
                        }
                        carrier {
                          id
                          name
                          code
                        }
                        operatingCarrier {
                          id
                          name
                          code
                        }
                      }
                      layover {
                        duration
                        isBaggageRecheck
                        transferDuration
                        transferType
                      }
                      guarantee
                    }
                  }
                }
              }
            }
          }
        }
        """
    }
    
    private func format(for items: [String]?) -> String {
        guard let items = items else { return "[]" }
        return "[\"" + items.joined(separator: "\", \"") + "\"]"
    }
}
