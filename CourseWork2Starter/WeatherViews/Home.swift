//
//  HomeView.swift
//  CWK2_23_GL
//
//  Created by GirishALukka on 10/03/2023.
//

import SwiftUI
import CoreLocation

struct Home: View {
    @EnvironmentObject var modelData: ModelData

    @State var isSearchOpen: Bool = false
    
    let mediumImageURL: String = "https://openweathermap.org/img/wn/%1$@@2x.png"
    let temperatureString = "Temperature: %dºC"
    let humidityString = "Humidity: %d%%"
    let pressureString = "Pressure: %dhPa"
    let errorMessage = "Someth🌪️ng went wrong!"

    
    var body: some View {
        VStack {
            // search location button
            Button {
                self.isSearchOpen.toggle()
            } label: {
                Text("Change Location")
                    .bold()
                    .font(.system(size: 30))
                    .shadow(color: .white, radius: 2)
            }
            .padding(EdgeInsets(top: 50, leading: 0, bottom: 100, trailing: 0))
            .sheet(isPresented: $isSearchOpen) {
                SearchView(isSearchOpen: $isSearchOpen)
            }
            
            // selected location
            Text(modelData.userLocation)
                .font(.title)
                .shadow(color: .black, radius: 0.5)
                .multilineTextAlignment(.center)
            
            // Screen content: to be displayed only if the forecast is available
            // If the forecast is not available display error message
            if let forecast = modelData.forecast {
                let hasWeather : Bool = !forecast.current.weather.isEmpty
                let weather = hasWeather ? forecast.current.weather[0] : nil
                
                // date section
                Text(Date(timeIntervalSince1970: TimeInterval(((Int)(forecast.current.dt))))
                        .formatted(.dateTime.year().hour().month().day()))
                .padding()
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .shadow(color: .black, radius: 1)
                Spacer()
                
                // weather section
                VStack {
                    // temperature
                    Text(String(format: temperatureString, (Int)(round(forecast.current.temp))))
                        .padding()
                        .font(.title2)
                        .shadow(color: .black, radius: 0.5)
                    
                    // humidity
                    Text(String(format: humidityString, (Int)(forecast.current.humidity)))
                        .padding()
                        .font(.title2)
                        .shadow(color: .black, radius: 0.5)
                    
                    // pressure
                    Text(String(format: pressureString, (Int)(forecast.current.pressure)))
                        .padding()
                        .font(.title2)
                        .shadow(color: .black, radius: 0.5)
                    
                    // icon and description
                    if hasWeather {
                        HStack {
                            // weather icon fetched asyncronously
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
                            // weather description
                            Text(weather!.weatherDescription.capitalized)
                                .padding(.vertical)
                                .font(.body)
                                .shadow(color: .black, radius: 0.5)
                        }
                    }
                }
                
            }
            else {
                Spacer()
                // no forecast error message
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
}
