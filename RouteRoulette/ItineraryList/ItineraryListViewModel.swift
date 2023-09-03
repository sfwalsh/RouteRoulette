//
//  ItineraryListViewModel.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import Foundation
import Combine

final class ItineraryListViewModel: ObservableObject {
    
    // Published Properties
    @Published var title: String
    @Published var loadingIndicatorActive: Bool
    @Published var items: [ItineraryListItemView.ViewModel]
    
    private var cancellables = Set<AnyCancellable>()
    
    // Use Cases
    
    private let createItineraries: any CreateIntineraries
    private let searchTermProvider: any SearchTermProvider
    
    init(
        title: String = String(localized: "itineraryViewTitleName"),
        loadingIndicatorActive: Bool = true,
        cancellables: Set<AnyCancellable> = Set<AnyCancellable>(),
        createItineraries: any CreateIntineraries,
        searchTermProvider: any SearchTermProvider,
        items: [ItineraryListItemView.ViewModel] = []
    ) {
        self.title = title
        self.loadingIndicatorActive = loadingIndicatorActive
        self.cancellables = cancellables
        self.createItineraries = createItineraries
        self.searchTermProvider = searchTermProvider
        self.items = items
    }
    
    func onAppear() {
        fetchItineraries()
    }
}

// MARK: private helpers

extension ItineraryListViewModel{
    private func fetchItineraries() {
        loadingIndicatorActive = true
        
        let searchTerm = searchTermProvider.generate()
        createItineraries.invoke(requestValues: .init(searchTerm: searchTerm))
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                defer { self?.loadingIndicatorActive = false }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    // corner cutting note: error handling not implemented
                    // should present error to user
                    // should log to Crashlytics or Sentry, etc.
                    print("error: \(error)")
                }
            } receiveValue: { [weak self] itineraries in
                self?.items = itineraries.map { ItineraryListItemView.ViewModel(from: $0) }
            }
            .store(in: &cancellables)
    }
}
