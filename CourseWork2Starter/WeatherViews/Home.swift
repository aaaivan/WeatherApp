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
    @State  var userLocation: String = ""
    
    let mediumImageURL: String = "https://openweathermap.org/img/wn/%1$@@2x.png"
    let temperatureString = "Temperature: %dºC"
    let humidityString = "Humidity: %d%%"
    let pressureString = "Pressure: %dhPa"
    let errorMessage = "Something went wrong! 🌪️🌪️🌪️"

    
    var body: some View {
        VStack {
            // search location button
            Button {
                self.isSearchOpen.toggle()
            } label: {
                Text("Change Location")
                    .bold()
                    .font(.system(size: 30))
            }
            .padding(EdgeInsets(top: 50, leading: 0, bottom: 100, trailing: 0))
            .sheet(isPresented: $isSearchOpen) {
                SearchView(isSearchOpen: $isSearchOpen, userLocation: $userLocation)
            }
            
            // Screen content: to be displayed only if the forecast is available
            // If the forecast is not available display error message
            if let forecast = modelData.forecast {
                VStack{
                    // Location & Date section
                    VStack {
                        Text(userLocation)
                            .font(.title)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 0.5)
                            .multilineTextAlignment(.center)
                        
                        Text(Date(timeIntervalSince1970: TimeInterval(((Int)(forecast.current.dt))))
                            .formatted(.dateTime.year().hour().month().day()))
                        .padding()
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 1)
                    }
                    Spacer()

                    // weather section
                    VStack {
                        // temperature
                        Text(String(format: temperatureString, (Int)(forecast.current.temp)))
                            .padding()
                            .font(.title2)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 0.5)
                        
                        // humidity
                        Text(String(format: humidityString, (Int)(forecast.current.humidity)))
                            .padding()
                            .font(.title2)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 0.5)
                        
                        // pressure
                        Text(String(format: pressureString, (Int)(forecast.current.pressure)))
                            .padding()
                            .font(.title2)
                            .foregroundColor(.black)
                            .shadow(color: .black, radius: 0.5)
                        
                        // icon and description
                        if !forecast.current.weather.isEmpty {
                            let weather = forecast.current.weather[0]
                            HStack {
                                AsyncImage(url: URL(string: String(format: mediumImageURL, weather.icon))){ content in
                                    switch content {
                                        case .empty:
                                            ProgressView()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .frame(width: 80, height: 80)
                                        case .failure:
                                            EmptyView()
                                        @unknown default:
                                            EmptyView()
                                    }
                                }
                                Text(weather.weatherDescription.rawValue.capitalized)
                            }
                        }
                    }
                }
                .onAppear {
                    Task.init {
                        self.userLocation = await getLocFromLatLong(lat: forecast.lat, lon: forecast.lon)
                    }
                }
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
            .opacity(0.5)
            .ignoresSafeArea()
        )
    }
}
