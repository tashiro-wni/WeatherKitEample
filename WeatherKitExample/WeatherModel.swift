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
final class WeatherModel: ObservableObject {
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

extension Locale {
    static let ja_JP = Locale(identifier: "ja_JP")
}

extension TimeZone {
    static let jst = TimeZone(identifier: "JST")
}

// 風向風速を「NNE 13km/h」のように整形する
extension Wind {
    var text: String {
        String(format: "%@ %.1f%@",
               compassDirection.abbreviation,
               speed.converted(to: .metersPerSecond).value,
               speed.converted(to: .metersPerSecond).unit.symbol)

//        let windSpeedStyle = Measurement<UnitSpeed>.FormatStyle(width: .narrow, locale: .ja_JP)
//        return compassDirection.abbreviation + " " + speed.converted(to: .metersPerSecond).formatted()  // m/s への変換が機能しない
    }
}
