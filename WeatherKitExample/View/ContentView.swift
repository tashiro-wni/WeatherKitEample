//
//  ContentView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/08.
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    @StateObject var model = WeatherModel()

    var body: some View {
        VStack() {
            if let weather = model.weather {
                NavigationView {
                    List {
                        NavigationLink(destination: CurrentWeatherView(current: weather.currentWeather)
                            .navigationTitle(Text("現在の天気"))
                        ) {
                            Text("現在の天気")
                        }
                        NavigationLink(destination: HourlyForecastView(hourlyForecast: weather.hourlyForecast)
                            .navigationTitle(Text("１時間ごとの天気"))
                        ) {
                            Text("１時間ごとの天気")
                        }
                        NavigationLink(destination: DailyForecastView(dailyForecast: weather.dailyForecast)
                            .navigationTitle(Text("週間予報"))
                        ) {
                            Text("週間予報")
                        }

                    }
                }
            } else {
                Text("読み込み中...")
            }
        }
        .alert(isPresented: $model.hasError) {
            // エラー時にはAlertを表示する
            Alert(title: Text("データが読み込めませんでした。"))
        }
    }
}

