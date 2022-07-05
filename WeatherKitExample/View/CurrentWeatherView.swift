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

//    private let dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .short
//        dateFormatter.calendar = Calendar(identifier: .gregorian)
//        dateFormatter.locale = .ja_JP
//        dateFormatter.timeZone = .jst
//        return dateFormatter
//    }()

    let temperatureStyle = Measurement<UnitTemperature>.FormatStyle(width: .narrow, locale: .ja_JP)   // 摂氏で表示
    let visibilityStyle = Measurement<UnitLength>.FormatStyle(width: .narrow, locale: .ja_JP)  // kmで表示

    var body: some View {
        VStack(alignment: .leading) {
//            Text("日時：" + dateFormatter.string(from: current.date))
            Text("日時：" + current.date.formatted(Date.FormatStyle(date: .numeric, time: .shortened, locale: .ja_JP, calendar: Calendar(identifier: .gregorian), timeZone: .jst!)))
            HStack {
                Text("天気：" + current.condition.description)
                Image(systemName: current.symbolName)  // 天気アイコン
            }
            Text("気温：" + current.temperature.formatted(temperatureStyle))  // 摂氏で表示
            Text("風向風速：" + current.wind.text)
            Text("湿度：" + current.humidity.formatted(.percent))  // %で表示
            Text("気圧：" + current.pressure.converted(to: .hectopascals).formatted())  // hPaで表示
            Text("視程：" + current.visibility.formatted(visibilityStyle))  // kmで表示
            Text("UV index：" + current.uvIndex.value.formatted())
            Text("雲量：" + current.cloudCover.formatted(.number.scale(10).precision(.fractionLength(0))))
            Spacer()
        }
    }
}
