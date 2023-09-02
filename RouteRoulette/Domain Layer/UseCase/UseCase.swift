//
//  UseCase.swift
//  RouteRoulette
//
//  Created by Stephen Walsh on 01/09/2023.
//

import Foundation
import Combine

protocol UseCase {
    associatedtype T
    associatedtype U
    func invoke(requestValues: T) -> AnyPublisher<U, Error>
}
