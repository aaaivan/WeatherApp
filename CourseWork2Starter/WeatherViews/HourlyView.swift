//
//  Hourly.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourlyView: View {
    @EnvironmentObject var modelData: ModelData

    let errorMessage = "Someth🌪️ng went wrong!"
    
    var body: some View {
        VStack{
            // selected location
            Text(modelData.userLocation)
                .font(.title)
                .shadow(color: .black, radius: 0.5)
                .multilineTextAlignment(.center)
            
            // Screen content: to be displayed only if the forecast is available
            // If the forecast is not available display error message
            if let forecast = modelData.forecast {
                List {
                    ForEach(forecast.hourly) { hour in
                        HourCondition(current: hour)
                    }
                    .listRowBackground(Color.white.opacity(0.5))
                }
                .scrollContentBackground(.hidden)
                .background(Color.white.opacity(0.6))
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
            Image("background")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .opacity(0.8)
        )
    }
}
