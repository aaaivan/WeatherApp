//
//  PollutionStructures.swift
//  CourseWork2Starter
//
//  Created by Ivan Palazzo on 09/05/2023.
//

import Foundation

// MARK: - Welcome
struct PollutionData : Codable {
    let coord: [Int]
    let list: [PollutionEntry]
}

// MARK: - PollutionEntry
struct PollutionEntry : Codable {
    let dt: Int
    let main: Overview
    let components: Pollutants
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

