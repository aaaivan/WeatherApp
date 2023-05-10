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
                // clear the invalid location error message on change
                .onChange(of: location) { newValue in
                    invalidLocationFlag = false
                }
                // fetch the coordinates of the place enterd, if it exists
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
                .font(.custom("Ariel", size: 24))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(10) // TextField
                .shadow(color: .blue, radius: 10)
                .padding(10)
            
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
