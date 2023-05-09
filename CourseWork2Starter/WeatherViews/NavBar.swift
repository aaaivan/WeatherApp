//
//  NavBar.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct NavBar: View {
    
    var body: some View {
        TabView{
           Home()
                .tabItem{
                    
                    Text("City")
                }
            CurrentWeatherView()
                .tabItem {
                    
                    Text("WeatherNow")
                }
            
            HourlyView()
                .tabItem{
                    
                    Text("HourlyView")
                }
            ForecastView()
                .tabItem {
                    
                    Text("ForecastView")
                }
            PollutionView()
                .tabItem {
                    
                    Text("PollutionView")
                }
        }.onAppear {
            UITabBar.appearance().isTranslucent = false
        }
        
    }
        
}

