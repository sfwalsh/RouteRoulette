//
//  ItineraryListModuleBuilder.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import Foundation

enum ItineraryListModuleBuilder {
    
    static func build() -> ItineraryListView? {
        let urlSession = URLSession.shared
        let jsonDecoder = JSONDecoder()
        let networkRover = NetworkRover.Default(urlSession: urlSession, decoder: jsonDecoder)
        let queryBuilder = QueryBuilder.Default()
        let apiRequestBuilder = APIRequestBuilder.Default()
        let flightDatasource = FlightDatasource.Default(
            networkRover: networkRover,
            queryBuilder: queryBuilder,
            apiRequestBuilder: apiRequestBuilder
        )
        let flightRepository = FlightRepository.Default(
            remoteDatasource: flightDatasource,
            stringToDateFormatter: StringToDateFormatter.Default(formatter: .init())
        )
        
        let placeDatasource = PlaceDatasource.Default(
            networkRover: networkRover,
            queryBuilder: queryBuilder,
            apiRequestBuilder: apiRequestBuilder
        )
        let placeRepository = PlaceRepository.Default(remoteDatasource: placeDatasource)
        let dateStringFormatter = DateStringFormatter.Default(calendar: .autoupdatingCurrent, formatter: .init())
        
        let createItineraries = CreateIntineraries.Default(
            fetchFlights: FetchFlights.Default(repository: flightRepository),
            fetchPlaces: FetchPlaces.Default(repository: placeRepository),
            dateStringFormatter: dateStringFormatter
        )
        
        let collection = SearchTermCollection.Default.create()
        let searchTermProvider = SearchTermProvider.Default(searchTerms: collection.searchTerms)
        
        let viewModel = ItineraryListViewModel(
            createItineraries: createItineraries,
            searchTermProvider: searchTermProvider
        )
        return ItineraryListView(viewModel: viewModel)
    }
}
    
