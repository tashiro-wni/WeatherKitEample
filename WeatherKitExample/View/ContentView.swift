//
//  ContentView.swift
//  WeatherKitExample
//
//  Created by Tomohiro Tashiro on 2022/06/08.
//

import SwiftUI
import WeatherKit

struct ContentView: View {
    @Environment(\.scenePhase) private var phase
    @StateObject var model = WeatherModel()

    var body: some View {
        VStack() {
            if let weather = model.weather {
                NavigationView {
                    List {
                        Section {
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
                        } footer: {
                            // ロゴ・data source
                            if let attribution = model.attribution {
                                Link(destination: attribution.legalPageURL) {
                                    HStack() {
                                        Spacer()
                                        AsyncImage(url: attribution.squareMarkURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 120)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        Spacer()
                                    }
                                }
                            }
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
        .onChange(of: phase) { newPhase in
            if newPhase == .active {
                model.load()
            }
        }
    }
}


