//
//  PollutionView.swift
//  Coursework2
//
//  Created by GirishALukka on 30/12/2022.
//

import SwiftUI

struct PollutionView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var pollutionModel: PollutionModel
    @Binding  var userLocation: String

    let mediumImageURL: String = "https://openweathermap.org/img/wn/%1$@@2x.png"
    let temperatureString = "%dºC"
    let highTempString = "High: %dºC"
    let lowTempString = "Low: %dºC"
    let percievedTempString = "Feels Like: %dºC"
    let errorMessage = "Someth🌪️ng went wrong!"
    let airQualityHeading = "Air Quality Data:"
    let pollutionErrorMessage = "No pollution data"

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
                .padding(.top, 40)
                Spacer()

                VStack {
                    Text(airQualityHeading)
                        .font(.largeTitle)
                        .shadow(color: .black, radius: 1)
                    
                    // pollution section
                    if let pollutionList = pollutionModel.pollutionData {
                        let hasPollution : Bool = !pollutionList.list.isEmpty
                        let pollution = hasPollution ? pollutionList.list[0] : nil
                        
                        if hasPollution {
                            HStack {
                                VStack {
                                    Image("so2")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .black, radius: 2)
                                    Text(String(format: "%.2f", pollution!.components.sulfurDioxide))
                                        .font(.body)
                                        .shadow(color: .black, radius: 0.5)
                                }
                                Spacer()
                                
                                VStack {
                                    Image("no")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .black, radius: 2)
                                    let nitrogenOxidesTotal = pollution!.components.nitrogenOxide + pollution!.components.nitrogenDioxide
                                    Text(String(format: "%.2f", nitrogenOxidesTotal))
                                        .font(.body)
                                        .shadow(color: .black, radius: 0.5)
                                }
                                Spacer()

                                VStack {
                                    Image("voc")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .black, radius: 2)
                                    Text(String(format: "%.2f", pollution!.components.carbonOxide))
                                        .font(.body)
                                        .shadow(color: .black, radius: 0.5)
                                }
                                Spacer()

                                VStack {
                                    Image("pm")
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .shadow(color: .black, radius: 2)
                                    Text(String(format: "%.2f", pollution!.components.sulfurDioxide))
                                        .font(.body)
                                        .shadow(color: .black, radius: 0.5)
                                }
                            }
                            .padding(.all)
                        }
                        else {
                            Text(pollutionErrorMessage)
                                .font(.title2)
                                .shadow(color: .black, radius: 0.5)
                                .multilineTextAlignment(.center)
                        }
                    }
                    else {
                        Text(pollutionErrorMessage)
                            .font(.title2)
                            .shadow(color: .black, radius: 0.5)
                            .multilineTextAlignment(.center)
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
            Image("background")
            .resizable()
            .scaledToFill()
            .opacity(0.8)
            .ignoresSafeArea()
        )
    }
}
