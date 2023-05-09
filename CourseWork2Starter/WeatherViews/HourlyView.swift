//
//  Hourly.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourlyView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding  var userLocation: String

    let errorMessage = "Someth🌪️ng went wrong!"

    var body: some View {
        VStack{
            Text(userLocation)
                .font(.title)
                .shadow(color: .black, radius: 0.5)
                .multilineTextAlignment(.center)
            
            // Screen content: to be displayed only if the forecast is available
            // If the forecast is not available display error message
            if modelData.forecast != nil {
                List {
                    ForEach(modelData.forecast!.hourly) { hour in
                        HourCondition(current: hour)
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
            Image("background")
            .resizable()
            .scaledToFill()
            .opacity(0.5)
            .ignoresSafeArea()
        )
    }
}
