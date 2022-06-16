//
//  DaylyForecastView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/16.
//

import SwiftUI
import WeatherKit

struct DailyForecastView: View {
    let dailyForecast: Forecast<DayWeather>

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "JST")
        return dateFormatter
    }()

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack() {
                    if dailyForecast.forecast.isEmpty {
                        Text("データがありません")
                    } else {
                        Grid(alignment: .trailing) {
                            GridRow() {
                                Text("時刻")
                                Text("天気")
                                Text("最高\n気温")
                                Text("最低\n気温")
                                Text("降水\n確率")
                                //if geometry.size.width > 400 {
                                    Text("風向風速")
                                //}
                            }

                            ForEach(dailyForecast.startIndex ..< dailyForecast.endIndex, id: \.self) { index in
                                let item = dailyForecast[index]
                                GridRow() {
                                    Text(dateFormatter.string(from: item.date))
                                    Image(systemName: item.symbolName)
                                    Text(item.highTemperature.formatted())
                                    Text(item.lowTemperature.formatted())
                                    Text(String(format: "%.0f%@", item.precipitationChance * 100, "%"))
                                    //if geometry.size.width > 400 {
                                        Text(item.wind.compassDirection.directionText + " " + item.wind.speed.formatted())
                                    //}
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