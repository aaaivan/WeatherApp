//
//  NavBar.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct NavBar: View {
    @EnvironmentObject var modelData: ModelData
    @State  var userLocation: String = "No location"

    var body: some View {
        TabView{
            Home(userLocation: $userLocation)
                .tabItem{
                    Label{
                        Text("City")
                    } icon: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            CurrentWeatherView(userLocation: $userLocation)
                .tabItem {
                    Label{
                        Text("Weather Now")
                    } icon: {
                        Image(systemName: "sun.max.fill")
                    }
                }
            
            HourlyView(userLocation: $userLocation)
                .tabItem{
                    Label{
                        Text("Hourly")
                    } icon: {
                        Image(systemName: "clock.fill")
                    }
                }
            ForecastView()
                .tabItem {
                    Label{
                        Text("Forecast")
                    } icon: {
                        Image(systemName: "calendar")
                    }
                }
            PollutionView()
                .tabItem {
                    Label{
                        Text("Pollution")
                    } icon: {
                        Image(systemName: "aqi.high")
                    }
                }
        }
        .onAppear {
            UITabBar.appearance().isTranslucent = false
            if let forecast = modelData.forecast {
                Task.init {
                    self.userLocation = await getLocFromLatLong(lat: forecast.lat, lon: forecast.lon)
                }
            }
        }
    }
}

