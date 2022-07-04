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
        dateFormatter.locale = .ja_JP
        dateFormatter.timeZone = .jst
        return dateFormatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Text("日時：" + dateFormatter.string(from: current.date))
            HStack {
                Text("天気：" + current.condition.description)
                Image(systemName: current.symbolName)  // 天気アイコン
            }
            Text("気温：" + current.temperature.formatted())
            Text("風向風速：" + current.wind.text)
            Text("湿度：" + current.humidity.formatted(.percent))
            Text("気圧：" + current.pressure.converted(to: .hectopascals).formatted())
            Text("視程：" + current.visibility.formatted())
            Text("UV index：" + current.uvIndex.value.formatted())
            Text("雲量：" + current.cloudCover.formatted(.number.scale(10).precision(.fractionLength(0))))
            Spacer()
        }
    }
}
