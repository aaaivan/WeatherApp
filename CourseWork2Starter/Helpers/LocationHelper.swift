//
//  LocationHelper.swift
//  Coursework2
//
//  Created by G Lukka.
//

import Foundation

import CoreLocation
func getLocFromLatLong(lat: Double, lon: Double) async -> String
{
    var locationString: String = ""
    var placemarks: [CLPlacemark]
    let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
    
    let ceo: CLGeocoder = CLGeocoder()
    
    let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    do {
        placemarks = try await ceo.reverseGeocodeLocation(loc)
        if placemarks.count > 0 {
            let mainPlace = placemarks[0]
            
            if let sublocality = mainPlace.subLocality {
                if !locationString.isEmpty {
                    locationString += ", "
                }
                locationString += sublocality
            }
            
            if let locality = mainPlace.locality {
                if !locationString.isEmpty {
                    locationString += ", "
                }
                locationString += locality
            }
            
            if let country = mainPlace.country {
                if !locationString.isEmpty {
                    locationString += ", "
                }
                locationString += country
            }
            
            if let name = mainPlace.name {
                if locationString.isEmpty && !name.isEmpty {
                    locationString = name
                }
            }
            
            return locationString.isEmpty ? "No City" : locationString
        }
    } catch {
        print("Reverse geodecoe fail: \(error.localizedDescription)")
        locationString = "No City, No Country"
       
        return locationString
    }
    
    return "Error getting Location"
}
