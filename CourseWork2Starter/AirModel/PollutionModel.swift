//
//  PollutionModel.swift
//  CourseWork2Starter
//
//  Created by Ivan Palazzo on 09/05/2023.
//

import Foundation

class PollutionModel : ObservableObject {
    @Published var pollutionData: PollutionData?
    let apiURL = "https://api.openweathermap.org/data/2.5/air_pollution?lat=%f&lon=%f&appid=70b5348ce1afed7a929a9b23eec7ce2a"
    
    init() {
        self.pollutionData = nil
    }
    
    func loadData(lat: Double, lon: Double) async {
        let url = URL(string: String(format: apiURL, lat, lon))
        let session = URLSession(configuration: .default)
        
        do {
            let (data, _) = try await session.data(from: url!)
            // print(String(decoding: data, as: UTF8.self))
            let pollutionData = try JSONDecoder().decode(PollutionData.self, from: data)
            DispatchQueue.main.async {
                self.pollutionData = pollutionData
            }
        } catch {
            print(error.localizedDescription.debugDescription)
            DispatchQueue.main.async {
                self.pollutionData = nil
            }
        }
    }
}
