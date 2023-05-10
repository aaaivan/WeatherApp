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
    
    var body: some View {
        Spacer()
        ZStack {
            Color.teal
                .ignoresSafeArea()
            
            VStack{
                TextField("Enter New Location", text: self.$location, onCommit: {
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
                    }//GEOCorder
                })// TextField
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .fixedSize()
                .font(.custom("Ariel", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                //.background(Color("background"))
                .cornerRadius(15) // TextField
                
            }//VStak
            
            
        }// Zstack
        Spacer()
    }// Some
    
} //View
