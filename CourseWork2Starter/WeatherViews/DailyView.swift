//
//  DailyView.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct DailyView: View {
    var day : Daily
    
    let mediumImageURL: String = "https://openweathermap.org/img/wn/%1$@@2x.png"
    let temperatureString = "%dºC / %dºC"
   
    var body: some View {
        let hasWeather : Bool = !day.weather.isEmpty
        let weather = hasWeather ? day.weather[0] : nil
        
        HStack {
            // weather icon fetched asyncronously
            if hasWeather {
                AsyncImage(url: URL(string: String(format: mediumImageURL, weather!.icon))){ content in
                    switch content {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .shadow(color: .black, radius: 2)
                    case .failure:
                        EmptyView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading){
                if hasWeather {
                    // weather description
                    Text(weather!.weatherDescription.capitalized)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                // date
                Text(Date(timeIntervalSince1970: TimeInterval(((Int)(day.dt))))
                    .formatted(.dateTime.day(.twoDigits).weekday(.wide)))
                .font(.body)
                .multilineTextAlignment(.leading)
            }
            Spacer()
            
            // temperature
            Text(String(format: temperatureString, (Int)(round(day.temp.min)), (Int)(round(day.temp.max))))
                .font(.body)
        }
    }
    
}

