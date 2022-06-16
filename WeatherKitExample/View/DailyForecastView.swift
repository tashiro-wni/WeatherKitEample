//
//  DaylyForecastView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/16.
//

import SwiftUI
import WeatherKit
import Charts

// 週間予報
struct DailyForecastView: View {
    let dailyForecast: Forecast<DayWeather>

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d(E)"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "JST")
        return dateFormatter
    }()

    var body: some View {
        GeometryReader() { geometry in
            ScrollView() {
                VStack(spacing: 20) {
                    if dailyForecast.forecast.isEmpty {
                        Text("データがありません")
                    } else {
                        // 気温グラフ
                        Text("気温").bold()
                        Chart {
                            ForEach(dailyForecast, id: \.date) { item in
                                // 最高気温、最低気温
                                BarMark(
                                    x: .value("日付", dateFormatter.string(from: item.date)),
                                    yStart: .value("最低気温", item.lowTemperature.value),
                                    yEnd: .value("最高気温", item.highTemperature.value),
                                    width: .ratio(0.6)
                                )
                                .foregroundStyle(.red)
                                .opacity(0.3)

                                // 平均値
                                RectangleMark(
                                    x: .value("日付", dateFormatter.string(from: item.date)),
                                    y: .value("平均気温", (item.highTemperature.value + item.lowTemperature.value) / 2),
                                    width: .ratio(0.6),
                                    height: .fixed(2)
                                )
                                .foregroundStyle(.red)
                            }
                        }.frame(width: geometry.size.width - 40, height: 200)

                        Divider()

                        // 表
                        Grid(alignment: .trailing) {
                            GridRow() {
                                Text("時刻")
                                Text("天気")
                                Text("最高\n気温")
                                Text("最低\n気温")
                                Text("降水\n確率")
                                Text("風向風速")
                            }.bold()

                            ForEach(dailyForecast, id: \.date) { item in
                                GridRow() {
                                    Text(dateFormatter.string(from: item.date))
                                    Image(systemName: item.symbolName)  // 天気アイコン
                                    Text(item.highTemperature.formatted())
                                    Text(item.lowTemperature.formatted())
                                    Text("\(item.precipitationChance * 100, specifier: "%.0f%%")")
                                    Text(item.wind.text)
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
