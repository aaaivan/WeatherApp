//
//  HourCondition.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourCondition: View {
    var current : Current
    
    let mediumImageURL: String = "https://openweathermap.org/img/wn/%1$@@2x.png"
    let temperatureString = "%dºC"
    let errorMessage = "Someth🌪️ng went wrong!"
    
    var body: some View {
        let hasWeather : Bool = !current.weather.isEmpty
        let weather = hasWeather ? current.weather[0] : nil
        
        HStack {
            Text(Date(timeIntervalSince1970: TimeInterval(((Int)(current.dt))))
                    .formatted(.dateTime.weekday(.abbreviated).hour(.twoDigits(amPM: .abbreviated))))
            .font(.body)
            .frame(width: 60)
            
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
            
            // temperature
            Text(String(format: temperatureString, (Int)(round(current.temp))))
                .padding()
                .font(.body)
            Spacer()
            
            if hasWeather {
                Text(weather!.weatherDescription.capitalized)
                    .font(.body)
                    .multilineTextAlignment(.trailing)
            }
        }
        .padding(.vertical)
    }
}

struct HourCondition_Previews: PreviewProvider {
    static var hourly = ModelData().forecast!.hourly
    
    static var previews: some View {
        HourCondition(current: hourly[0])
    }
}
