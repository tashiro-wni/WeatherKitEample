//
//  WeatherModel.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/08.
//

import Foundation
import CoreLocation
import WeatherKit

@MainActor
class WeatherModel: ObservableObject {
    let location = CLLocation(latitude: 35.6484764, longitude: 140.0397928)  // 海浜幕張
    @Published private(set) var weather: Weather?
    @Published var hasError = false

    init() {
        load()
    }

    func load() {
        Task {
            do {
                self.weather = try await WeatherService().weather(for: location)
            } catch {
                self.hasError = true
            }
        }
    }
}

extension Wind.CompassDirection {
    var directionText: String {
        switch self {
        case .northNortheast: return "NNE"
        case .northeast:      return "NE"
        case .eastNortheast:  return "ENE"
        case .east:           return "E"
        case .eastSoutheast:  return "ESE"
        case .southeast:      return "SE"
        case .southSoutheast: return "SSE"
        case .south:          return "S"
        case .southSouthwest: return "SSW"
        case .southwest:      return "SW"
        case .westSouthwest:  return "WSW"
        case .west:           return "W"
        case .westNorthwest:  return "WNW"
        case .northwest:      return "NW"
        case .northNorthwest: return "NNW"
        case .north:          return "N"
        }
    }
}
