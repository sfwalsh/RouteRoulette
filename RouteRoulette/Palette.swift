//
//  Palette.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import SwiftUI

enum Palette {
    
    enum ActivityIndicator {
        private static let setName = "ActivityIndicator"
        static let background = Color(setName+"Background")
    }
    
    enum Accent {
        private static let setName = "Accent"
        static let one = Color(setName+"One")
        static let two = Color(setName+"Two")
    }
}
