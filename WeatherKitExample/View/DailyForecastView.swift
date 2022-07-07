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
        dateFormatter.locale = .ja_JP
        dateFormatter.timeZone = .jst
        return dateFormatter
    }()
    let temperatureStyle = Measurement<UnitTemperature>.FormatStyle(width: .narrow, locale: .ja_JP)   // 摂氏で表示

    var body: some View {
        ScrollView() {
            if dailyForecast.isEmpty {
                Text("データがありません")
            } else {
                // グラフ
                Text("気温").bold()
                DailyChartView(dailyForecast: dailyForecast)
                    .frame(height: 200)
                    .padding(20)
                Divider()
                        
                // 表
                Grid(alignment: .trailing) {
                    GridRow() {
                        Text("日付")
                        Text("天気")
                        Text("最高\n気温")
                        Text("最低\n気温")
                        Text("降水\n確率")
//                        Text("降水量")
                        Text("風向風速")
                    }.bold()
                    
                    ForEach(dailyForecast, id: \.date) { item in
                        GridRow() {
                            Text(dateFormatter.string(from: item.date))
                            Image(systemName: item.symbolName)  // 天気アイコン
                            Text(item.highTemperature.formatted(temperatureStyle))  // 摂氏で表示
                            Text(item.lowTemperature.formatted(temperatureStyle))  // 摂氏で表示
                            Text(item.precipitationChance.formatted(.percent))  // %で表示
//                            Text(item.rainfallAmount.converted(to: .millimeters).formatted())
                            Text(item.wind.text)
                        }
                        .lineLimit(1)
                    }
                }
            }
        }
    }
}

private struct DailyChartView: View {
    let dailyForecast: Forecast<DayWeather>
    
    var body: some View {
        if let min = dailyForecast.map({ $0.lowTemperature.value }).min(),
           let max = dailyForecast.map({ $0.highTemperature.value }).max() {
            // 気温グラフ
            Chart(dailyForecast, id: \.date) { item in
                // 最高気温、最低気温
                BarMark(
                    x: .value("日付", item.date, unit: .day),
                    yStart: .value("最低気温", item.lowTemperature.value),
                    yEnd: .value("最高気温", item.highTemperature.value),
                    width: .ratio(0.6)
                )
                .foregroundStyle(.red)
                .opacity(0.3)
                
                // 平均値
                RectangleMark(
                    x: .value("日付", item.date, unit: .day),
                    y: .value("平均気温", (item.highTemperature.value + item.lowTemperature.value) / 2),
                    width: .ratio(0.6),
                    height: .fixed(2)
                )
                .foregroundStyle(.red)
            }
            .chartYScale(domain: floor(min) ... ceil(max))
            .chartXAxis {  // X軸の表記を定義
                AxisMarks(values: .stride(by: .day)) { value in
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
