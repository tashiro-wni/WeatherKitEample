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
