//
//  ActivityIndicator.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 03/09/2023.
//

import SwiftUI

struct ActivityIndicatorView: View {
    
    @State private var degrees: Double = 0
    var repeatingAnimation: Animation {
        Animation
            .linear(duration: 1)
            .repeatForever(autoreverses: false)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Palette.ActivityIndicator.background,
                    lineWidth: 5
                )
                .frame(width: 75)
                .padding()
            
            Circle()
                .trim(from: 0.05, to: 0.6)
                .stroke(
                    AngularGradient(
                        colors: [
                            Palette.Accent.two,
                            Palette.Accent.one,
                            Palette.Accent.two,
                        ],
                        center: .center
                    ),
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round
                    )
                )
                .rotationEffect(
                    .init(
                        degrees: degrees)
                ).onAppear() {
                    withAnimation(repeatingAnimation, {
                        self.degrees = 360
                    })
                }
                .frame(width: 75)
        }
    }
}

private struct ContentView: View {
    var body: some View {
        VStack {
            ActivityIndicatorView()
        }
    }
}

struct ActivityIndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
