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
    @Published private(set) var currentWeather: CurrentWeather?
    @Published var hasError = false

    init() {
        load()
    }

    func load() {
        Task {
            do {
                let weatherService = WeatherService()
                let location = CLLocation(latitude: 35.5, longitude: 140.1)
                let weather = try await weatherService.weather(for: location)
                self.currentWeather = weather.currentWeather
            } catch {
                self.hasError = true
            }
        }
    }
}
