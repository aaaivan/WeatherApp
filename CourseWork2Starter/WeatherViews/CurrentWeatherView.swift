//
//  Conditions.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding  var userLocation: String

    let mediumImageURL: String = "https://openweathermap.org/img/wn/%1$@@2x.png"
    let temperatureString = "%dºC"
    let highTempString = "High: %dºC"
    let lowTempString = "Low: %dºC"
    let percievedTempString = "Feels Like: %dºC"
    let humidityString = "Humidity: %d%%"
    let pressureString = "Pressure: %dhPa"
    let windSpeedString = "Wind Speed: %dm/s"
    let windDirString = "Direction: %1$@"
    let errorMessage = "Someth🌪️ng went wrong!"
    let windDirections = ["N","NNE","NE","ENE","E","ESE","SE","SSE","S","SSW","SW","WSW","W","WNW","NW","NNW","N"]
    let windAngleIncrement = 360.0 / 16
    
    var body: some View {
        VStack{
            Text(userLocation)
                .font(.title)
                .shadow(color: .black, radius: 0.5)
                .multilineTextAlignment(.center)
                .padding(.top, 50)

            // Screen content: to be displayed only if the forecast is available
            // If the forecast is not available display error message
            if let forecast = modelData.forecast {
                let hasWeather : Bool = !forecast.current.weather.isEmpty
                let hasDaily : Bool = !forecast.daily.isEmpty
                let weather = hasWeather ? forecast.current.weather[0] : nil
                let dayDetails = hasDaily ? forecast.daily[0] : nil
                
                Spacer()
                // temperature section
                VStack {
                    // temperature
                    Text(String(format: temperatureString, (Int)(round(forecast.current.temp))))
                        .font(.largeTitle)
                        .shadow(color: .black, radius: 1)
                    
                    // icon and description
                    if hasWeather {
                        HStack {
                            AsyncImage(url: URL(string: String(format: mediumImageURL, weather!.icon))){ content in
                                switch content {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 80, height: 80)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .shadow(color: .black, radius: 2)
                                case .failure:
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            Text(weather!.weatherDescription.rawValue.capitalized)
                                .padding()
                                .font(.body)
                                .shadow(color: .black, radius: 0.5)
                        }
                    }
                    
                    // high and low temperature
                    if hasDaily {
                        HStack {
                            Spacer()
                            Text(String(format: highTempString, (Int)(round(dayDetails!.temp.max))))
                                .padding(.horizontal)
                                .font(.body)
                                .shadow(color: .black, radius: 0.5)
                            Spacer()
                            
                            Text(String(format: lowTempString, (Int)(round(dayDetails!.temp.min))))
                                .padding(.horizontal)
                                .font(.body)
                                .shadow(color: .black, radius: 0.5)
                            Spacer()
                        }
                        .padding(.top)
                        .padding(.bottom, 5)
                    }
                    
                    // percieved temperature
                    Text(String(format: percievedTempString, (Int)(round(forecast.current.feelsLike))))
                        .padding(.top, 5)
                        .padding(.bottom)
                        .font(.body)
                        .shadow(color: .black, radius: 0.5)
                }
                
                // wind section
                HStack {
                    Spacer()
                    Text(String(format: windSpeedString, (Int)(round(forecast.current.windSpeed))))
                        .padding()
                        .font(.title3)
                        .shadow(color: .black, radius: 0.5)
                    Spacer()
                    Text(String(format: windDirString, WindCompassDirectionFromDegrees(deg: forecast.current.windDeg)))
                        .padding()
                        .font(.title3)
                        .shadow(color: .black, radius: 0.5)
                    Spacer()
                }
                .padding(.vertical)
                
                // humidity/pressure section
                HStack {
                    Spacer()
                    Text(String(format: humidityString, (Int)(forecast.current.humidity)))
                        .padding()
                        .font(.title3)
                        .shadow(color: .black, radius: 0.5)
                    Spacer()
                    Text(String(format: pressureString, (Int)(forecast.current.pressure)))
                        .padding()
                        .font(.title3)
                        .shadow(color: .black, radius: 0.5)
                    Spacer()
                }
                
                // sunrise/sunset section
                if hasDaily {
                    HStack {
                        Spacer()
                        Image(systemName: "sunrise.fill")
                            .resizable()
                            .renderingMode(.original)
                            .shadow(color: .black, radius: 2)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                        Text(Date(timeIntervalSince1970: TimeInterval(((Int)(dayDetails!.sunrise))))
                                .formatted(.dateTime.hour().minute()))
                            .padding(.vertical)
                            .font(.title3)
                            .shadow(color: .black, radius: 0.5)
                        Spacer()
                        
                        Image(systemName: "sunset.fill")
                            .resizable()
                            .renderingMode(.original)
                            .shadow(color: .black, radius: 2)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40)
                        Text(Date(timeIntervalSince1970: TimeInterval(((Int)(dayDetails!.sunset))))
                                .formatted(.dateTime.hour().minute()))
                            .padding(.vertical)
                            .font(.title3)
                            .shadow(color: .black, radius: 0.5)
                        Spacer()
                    }
                }
                Spacer()
            }
            else {
                Spacer()
                Text(errorMessage)
                    .font(.title2)
                    .shadow(color: .black, radius: 0.5)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
        // set background image for the view
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("background2")
            .resizable()
            .scaledToFill()
            .opacity(0.8)
            .ignoresSafeArea()
        )
    }
    
    func WindCompassDirectionFromDegrees(deg: Int) -> String {
        // normalize angle to a value in [0, 360)
        var angle = Double(deg % 360)
        angle = angle < 0 ? angle + 360 : angle
        
        // match the angle to the compass direction
        for i in 0..<windDirections.count {
            let treshholdAngle = (Double)(i) * windAngleIncrement + windAngleIncrement/2
            if(angle < treshholdAngle) {
                return windDirections[i]
            }
        }
        return windDirections[0]
    }
}
