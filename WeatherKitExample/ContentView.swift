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
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M月d日(E) H:mm"
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "JST")
        return dateFormatter
    }()


    var body: some View {
        VStack {
            if let weather = model.currentWeather {
                Text("日時：\(dateFormatter.string(from: weather.date))")
                Text("天気：\(weather.condition.rawValue), \(weather.condition.description)")
                Image(systemName: weather.symbolName)
                Text("気温：\(weather.temperature)")

            } else {
                Text("Loading...")
            }
        }
        .alert(isPresented: $model.hasError) {
            // エラー時にはAlertを表示する
            Alert(title: Text("データが読み込めませんでした。"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
