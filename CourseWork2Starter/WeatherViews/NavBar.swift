//
//  NavBar.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct NavBar: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var pollutionModel: PollutionModel = PollutionModel()

    var body: some View {
        TabView{
            Home()
                .tabItem{
                    Label{
                        Text("City")
                    } icon: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            CurrentWeatherView()
                .tabItem {
                    Label{
                        Text("Weather Now")
                    } icon: {
                        Image(systemName: "sun.max.fill")
                    }
                }
            
            HourlyView()
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
                .environmentObject(pollutionModel)
        }
        .onAppear {
            UITabBar.appearance().isTranslucent = false
            if let forecast = modelData.forecast {
                Task.init {
                    modelData.userLocation = await getLocFromLatLong(lat: forecast.lat, lon: forecast.lon)
                }
            }
        }
    }
}

