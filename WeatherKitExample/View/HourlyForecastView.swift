//
//  HourlyForecastView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/16.
//

import SwiftUI
import WeatherKit

// 1時間ごと
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

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack() {
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
                                }
                            }

                            ForEach(hourlyForecast.startIndex ..< hourlyForecast.endIndex, id: \.self) { index in
                                let item = hourlyForecast[index]
                                GridRow() {
                                    Text(dateFormatter.string(from: item.date))
                                    Image(systemName: item.symbolName)
                                    Text(item.temperature.formatted())
                                    Text(String(format: "%.0f%@", item.precipitationChance * 100, "%"))
                                    Text(item.wind.compassDirection.directionText + " " + item.wind.speed.formatted())
                                    if geometry.size.width > 400 {
                                        Text(String(format: "%.0f%@", item.humidity * 100, "%"))
                                        Text(item.pressure.formatted())
                                    }
                                }
                                .lineLimit(1)
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
    }
}
