//
//  SearchView.swift
//  CWK2_23_GL
//
//  Created by GirishALukka on 11/03/2023.
//

import SwiftUI
import CoreLocation

struct SearchView: View {
    @EnvironmentObject var modelData: ModelData
    @EnvironmentObject var pollutionModel: PollutionModel
    @Binding var isSearchOpen: Bool
    @State var location = ""
    @State var invalidLocationFlag = false
    
    let enterLocationTooltip = "Enter New Location"
    let invalidLocationText = "Location not found!"

    var body: some View {
        VStack{
            TextField(enterLocationTooltip, text: self.$location)
                .onChange(of: location) { newValue in
                    invalidLocationFlag = false
                }
                .onSubmit {
                    CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
                        if let lat = placemarks?.first?.location?.coordinate.latitude,
                           let lon = placemarks?.first?.location?.coordinate.longitude {
                            Task.init {
                                modelData.userLocation = await getLocFromLatLong(lat: lat, lon: lon)
                            }
                            Task.init {
                                await modelData.loadData(lat: lat, lon: lon)
                            }
                            Task.init {
                                await pollutionModel.loadData(lat: lat, lon: lon)
                            }
                            isSearchOpen.toggle()
                        }
                        else {
                            invalidLocationFlag = true
                        }
                    }//GEOCorder
                }
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .fixedSize()
                .font(.custom("Ariel", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(15) // TextField
            
            // invalid location message
            Text(invalidLocationFlag ? invalidLocationText : " ")
                .font(.title2)
                .shadow(color: .white, radius: 2)
                .onAppear {
                    invalidLocationFlag = false
                }
        }//VStak
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.teal, ignoresSafeAreaEdges: .all)
    }// Some
    
} //View
