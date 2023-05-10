//
//  PollutionStructures.swift
//  CourseWork2Starter
//
//  Created by Ivan Palazzo on 09/05/2023.
//

import Foundation

// MARK: - PollutionData
struct PollutionData : Codable {
    let coord: Coordinates
    let list: [PollutionEntry]
}

// MARK: - Coordinates
struct Coordinates : Codable {
    let lon: Double
    let lat: Double
}

// MARK: - PollutionEntry
struct PollutionEntry : Codable {
    let main: Overview
    let components: Pollutants
    let dt: Int
}

// MARK: - Overview
struct Overview : Codable {
    let aqi: Int
}

struct Pollutants  : Codable {
    let carbonOxide: Double
    let nitrogenOxide: Double
    let nitrogenDioxide: Double
    let ozone: Double
    let sulfurDioxide: Double
    let pm2poin5: Double
    let pm10: Double
    let ammonia: Double
    
    enum CodingKeys: String, CodingKey {
        case carbonOxide = "co"
        case nitrogenOxide = "no"
        case nitrogenDioxide = "no2"
        case ozone = "o3"
        case sulfurDioxide = "so2"
        case pm2poin5 = "pm2_5"
        case pm10 = "pm10"
        case ammonia = "nh3"
    }
}

