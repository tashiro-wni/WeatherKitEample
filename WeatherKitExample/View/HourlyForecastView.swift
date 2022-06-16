//
//  HourlyForecastView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/16.
//

import SwiftUI
import WeatherKit

// 1時間ごとの天気
struct HourlyForecastView: View {
    let hourlyForecast: Forecast<HourWeather>

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d H:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "JST")
        return dateFormatter
    }()
    private let now = Date()

    var body: some View {
        GeometryReader() { geometry in
            ScrollView() {
                if hourlyForecast.forecast.isEmpty {
                    Text("データがありません")
                } else {
                    Grid(alignment: .trailing) {
                        GridRow() {
                            Text("時刻")
                            Text("天気")
                            Text("気温")
                            Text("降水\n確率")
                            Text("風向風速")
                            if geometry.size.width > 400 {
                                Text("湿度")
                                Text("気圧")
                                Text("視程")
                                Text("雲量")
                                Text("UV\nindex")
                            }
                        }.bold()

                        ForEach(hourlyForecast, id: \.date) { item in
                            if item.date > now {
                                GridRow() {
                                    Text(dateFormatter.string(from: item.date))
                                    Image(systemName: item.symbolName)  // 天気アイコン
                                    Text(item.temperature.formatted())
                                    Text("\(item.precipitationChance * 100, specifier: "%.0f%%")")
                                    Text(item.wind.text)
                                    if geometry.size.width > 400 {
                                        Text("\(item.humidity * 100, specifier: "%.0f%%")")
                                        Text(item.pressure.converted(to: .hectopascals).formatted())
                                        Text(item.visibility.formatted())
                                        Text("\(item.cloudCover * 10, specifier: "%.0f")")
                                        Text(item.uvIndex.value.formatted())
                                    }
                                }
                                .lineLimit(1)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
    }
}
