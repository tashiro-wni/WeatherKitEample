//
//  CurrentWeatherView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/16.
//

import SwiftUI
import WeatherKit

// 現在の天気
struct CurrentWeatherView: View {
    let current: CurrentWeather

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "JST")
        return dateFormatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text("日時：" + dateFormatter.string(from: current.date))
            HStack {
                Text("天気：" + current.condition.description)
                Image(systemName: current.symbolName)
            }
            Text("気温：" + current.temperature.formatted())
            Text("風向風速：" + current.wind.compassDirection.directionText + " " + current.wind.speed.formatted())
            Text(String(format: "湿度：%.0f%@", current.humidity * 100, "%"))
            Text("気圧：" + current.pressure.formatted())
            Text("UV index：" + current.uvIndex.value.formatted())
            Text(String(format: "雲量：%.1f", current.cloudCover))
            Spacer()
        }
    }
}
