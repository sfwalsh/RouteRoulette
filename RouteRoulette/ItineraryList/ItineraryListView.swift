//
//  ItineraryListView.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 31/08/2023.
//

import SwiftUI

struct ItineraryListView: View {
    
    @StateObject private var viewModel: ItineraryListViewModel
    
    init(viewModel: ItineraryListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            ZStack {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.items) { item in
                            ItineraryListItemView(viewModel: item)
                        }
                    }
                    .refreshable {
                        viewModel.onAppear()
                    }
                }
                
                if viewModel.loadingIndicatorActive {
                    ActivityIndicatorView()
                        .frame(width: 20, height: 20)
                }
            }
            
        }.onAppear {
            viewModel.onAppear()
        }.navigationTitle(viewModel.title)
    }
}

struct ItineraryListView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryListModuleBuilder.build()
    }
}
