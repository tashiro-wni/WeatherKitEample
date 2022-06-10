//
//  ContentView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/08.
//

import SwiftUI
import WeatherKit

extension Wind.CompassDirection {
    var directionText: String {
        switch self {
        case .northNortheast: return "NNE"
        case .northeast:      return "NE"
        case .eastNortheast:  return "ENE"
        case .east:           return "E"
        case .eastSoutheast:  return "ESE"
        case .southeast:      return "SE"
        case .southSoutheast: return "SSE"
        case .south:          return "S"
        case .southSouthwest: return "SSW"
        case .southwest:      return "SW"
        case .westSouthwest:  return "WSW"
        case .west:           return "W"
        case .westNorthwest:  return "WNW"
        case .northwest:      return "NW"
        case .northNorthwest: return "NNW"
        case .north:          return "N"
        }
    }
}

struct ContentView: View {
    @StateObject var model = WeatherModel()

    var body: some View {
        VStack(alignment: .leading) {
            if let weather = model.weather {
                GeometryReader { geometry in
                    ScrollView {
                        CurrentWeatherView(current: weather.currentWeather)
                        Divider()
                        HourlyWeatherView(hourlyForecast: weather.hourlyForecast, width: geometry.size.width)
                    }
                }
            } else {
                Text("Loading...")
            }
        }
        .padding(20)
        .alert(isPresented: $model.hasError) {
            // エラー時にはAlertを表示する
            Alert(title: Text("データが読み込めませんでした。"))
        }
    }
}

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
            Text("現在の天気")
                .font(.title)
                .frame(alignment: .center)
            Text("日時：" + dateFormatter.string(from: current.date))
            HStack {
                Text("天気：" + current.condition.description)
                Image(systemName: current.symbolName)
            }
            Text(String(format: "気温：%.1f%@", current.temperature.value, current.temperature.unit.symbol))
            Text(String(format: "風向風速：%@ %.1f%@", current.wind.compassDirection.directionText, current.wind.speed.value, current.wind.speed.unit.symbol))
            Text(String(format: "湿度：%.0f%@", current.humidity * 100, "%"))
            Text(String(format: "気圧：%.1f%@", current.pressure.value, current.pressure.unit.symbol))
            Text(String(format: "UV index：%d", current.uvIndex.value))
            Text(String(format: "雲量：%.1f", current.cloudCover))
        }
    }
}

// 1時間ごと
struct HourlyWeatherView: View {
    let hourlyForecast: Forecast<HourWeather>
    let width: CGFloat

    private var hasWideWidth: Bool {
        width > 400
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d H:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "JST")
        return dateFormatter
    }()

    var body: some View {
        VStack() {
            if hourlyForecast.forecast.isEmpty {
                EmptyView()
            } else {
                Text("1時間ごとの天気")
                    .font(.title)
                    .frame(alignment: .center)

                // 表で表示する
                Grid(alignment: .trailing) {
                    GridRow() {
                        Text("時刻")
                        Text("天気")
                        Text("気温")
                        Text("降水\n確率")
                        Text("風向風速")
                        if hasWideWidth {
                            Text("湿度")
                            Text("気圧")
                        }
                    }

                    ForEach(hourlyForecast.startIndex ..< hourlyForecast.endIndex, id: \.self) { index in
                        let item = hourlyForecast[index]
                        GridRow() {
                            Text(dateFormatter.string(from: item.date))
                            Image(systemName: item.symbolName)
                            Text(String(format: "%.1f%@", item.temperature.value, item.temperature.unit.symbol))
                            Text(String(format: "%.0f%@", item.precipitationChance * 100, "%"))
                            Text(String(format: "%@ %.1f%@", item.wind.compassDirection.directionText, item.wind.speed.value, item.wind.speed.unit.symbol))
                            if hasWideWidth {
                                Text(String(format: "%.0f%@", item.humidity * 100, "%"))
                                Text(String(format: "%.1f%@", item.pressure.value, item.pressure.unit.symbol))
                            }
                        }
                        .lineLimit(1)
                    }
                }
            }
        }
    }
}
