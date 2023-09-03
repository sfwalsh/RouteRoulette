//
//  ItineraryListItemView.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import SwiftUI

struct ItineraryListItemView: View {
    
    let viewModel: ItineraryListItemView.ViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text(viewModel.sourceName)
                    Image(systemName: "airplane")
                        .font(.system(size: 26.0, weight: .ultraLight))
                }
                
                Text(viewModel.destinationName)
            }.font(.system(size: 26, weight: .semibold, design: .serif))
            
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 4) {
                    if let subtitleText = viewModel.subtitleText {
                        Text(subtitleText)
                            .font(.system(size: 15, weight: .bold))
                    }
                    
                    Text(viewModel.departureDateText)
                        .font(.system(size: 15, weight: .regular))
                }
                Spacer()
                if let priceText = viewModel.priceText {
                    Text(priceText).font(.system(size: 26, weight: .bold))
                }
            }
        }.padding()
    }
}

struct ItineraryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryListItemView(viewModel:
                .init(from: .init(
                    id: "1234",
                    totalDuration: 123456,
                    priceEur: "2345",
                    stopCount: 1,
                    sourceName: "Toronto",
                    destinationName: "México",
                    departureDate: .now
                )
                )
        )
    }
}

extension ItineraryListItemView {
    struct ViewModel {
        private let durationFormatter: DateComponentsFormatter = {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute]
            formatter.unitsStyle = .abbreviated
            return formatter
        }()
        
        private let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = "€"
            formatter.maximumFractionDigits = 0
            return formatter
        }()
        
        private let flight: FlightDTO
        
        var sourceName: String {
            flight.sourceName
        }
        var destinationName: String {
            flight.destinationName
        }
        var subtitleText: String? {
            [durationText, stopText]
                .compactMap { $0 }
                .joined(separator: " • ")
        }
        private var durationText: String? {
            return durationFormatter.string(from: Double(flight.totalDuration))
        }
        private var stopText: String? {
            guard flight.stopCount > 0 else {
                return "Direct"
            }
            // corner cutting note: localization not implemented
            return "\(flight.stopCount) \(flight.stopCount == 1 ? "Stop" : "Stops")"
        }
        var departureDateText: String {
            format(forDate: flight.departureDate)
        }
        var priceText: String? {
            guard let priceNumber = Double(flight.priceEur) else { return nil }
            return priceFormatter.string(from: priceNumber as NSNumber)
        }
        
        init(from flight: FlightDTO) {
            self.flight = flight
        }
        
        private func format(forDate date: Date) -> String {
            // corner cutting note: dependency injection
            let calendar = Calendar.current
            let currentYear = calendar.component(.year, from: Date())
            let dateYear = calendar.component(.year, from: date)
            let currentDateMonth = calendar.component(.month, from: Date())
            let dateMonth = calendar.component(.month, from: date)

            let formatter = DateFormatter()

            if dateYear == currentYear && currentDateMonth <= dateMonth {
                formatter.dateFormat = "E, d MMM - HH:mm"
            } else {
                formatter.dateFormat = "E, d MMM yyyy - HH:mm"
            }
            return formatter.string(from: date)
        }
    }
}
