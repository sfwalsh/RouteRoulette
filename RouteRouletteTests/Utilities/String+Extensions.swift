//
//  String+Extensions.swift
//  RouteRouletteTests
//
//  Created by Stephen Walsh on 31/08/2023.
//

import Foundation

extension String {
    
    static let alphaNumerics = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    init?(character: Character?) {
        guard let c = character else { return nil }
        self = String(c)
    }
    
    static func randomAlphanumeric(of length: Int) -> String {
        return (0..<length)
            .map{ _ in
                String(character: Self.alphaNumerics.randomElement())
            }
            .compactMap{ $0 }
            .reduce("", +)
    }
}
