//
//  HourlyForecastView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/16.
//

import SwiftUI
import WeatherKit
import Charts

// 1時間ごとの天気
struct HourlyForecastView: View {
    let hourlyForecast: Forecast<HourWeather>

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d H:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = .ja_JP
        dateFormatter.timeZone = .jst
        return dateFormatter
    }()
    private let now = Date()
    let temperatureStyle = Measurement<UnitTemperature>.FormatStyle(width: .narrow, locale: .ja_JP)   // 摂氏で表示
    let visibilityStyle = Measurement<UnitLength>.FormatStyle(width: .narrow, locale: .ja_JP)  // kmで表示
    let pressureStyle = Measurement<UnitPressure>.FormatStyle(width: .narrow, numberFormatStyle: .number.precision(.fractionLength(0)))  // hPa, 整数部のみ表示

    var body: some View {
        GeometryReader() { geometry in
            ScrollView() {
                if hourlyForecast.forecast.isEmpty {
                    Text("データがありません")
                } else {
                    // グラフ
                    Text("気温").bold()
                    HourlyChartView(hourlyForecast: hourlyForecast)
                        .frame(height: 200)
                        .padding(20)
                    Divider()

                    // 表
                    Grid(alignment: .trailing) {
                        GridRow() {
                            Text("時刻")
                            Text("天気")
                            Text("気温")
                            Text("降水\n確率")
                            Text("風向風速")
                            if geometry.size.width > geometry.size.height {
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
                                    Text(item.temperature.formatted(temperatureStyle))  // 摂氏で表示
                                    Text(item.precipitationChance.formatted(.percent))  // %で表示
                                    Text(item.wind.text)
                                    if geometry.size.width > geometry.size.height {
                                        Text(item.humidity.formatted(.percent))  // %で表示
                                        Text(item.pressure.converted(to: .hectopascals).formatted(pressureStyle))  // hPaで表示
                                        Text(item.visibility.formatted(visibilityStyle))  // kmで表示
                                        Text(item.cloudCover.formatted(.number.scale(10).precision(.fractionLength(0))))
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

private struct HourlyChartView: View {
    let hourlyForecast: Forecast<HourWeather>
    private let now = Date()
    
    var body: some View {
        if let min = hourlyForecast.map({ $0.temperature.value }).min(),
           let max = hourlyForecast.map({ $0.temperature.value }).max() {
            // 気温グラフ
            Chart(hourlyForecast, id: \.date) { item in
                if item.date > now {
                    LineMark(
                        x: .value("時刻", item.date, unit: .hour),
                        y: .value("気温", item.temperature.value)
                    )
                    .foregroundStyle(.red)
                }
            }
            .chartYScale(domain: floor(min) ... ceil(max))
            .chartXAxis {  // X軸の表記を定義
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisTick()
                    // see Date.FormatStyle
                    // https://developer.apple.com/documentation/foundation/date/formatstyle
                    AxisValueLabel(format: .dateTime.day())
                }
            }
        } else {
            EmptyView()
        }
    }
}
