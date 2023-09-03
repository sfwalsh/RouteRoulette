//
//  RouteRouletteApp.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 31/08/2023.
//

import SwiftUI

@main
struct RouteRouletteApp: App {
    var body: some Scene {
        WindowGroup {
            ItineraryListModuleBuilder.build()
        }
    }
}
