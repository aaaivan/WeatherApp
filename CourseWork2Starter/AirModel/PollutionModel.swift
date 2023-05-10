//
//  PollutionModel.swift
//  CourseWork2Starter
//
//  Created by Ivan Palazzo on 09/05/2023.
//

import Foundation

let jsonTest = """
    {
      "coord":[
        50,
        50
      ],
      "list":[
        {
          "dt":1605182400,
          "main":{
            "aqi":1
          },
          "components":{
            "co":201.94053649902344,
            "no":0.01877197064459324,
            "no2":0.7711350917816162,
            "o3":68.66455078125,
            "so2":0.6407499313354492,
            "pm2_5":0.5,
            "pm10":0.540438711643219,
            "nh3":0.12369127571582794
          }
        }
      ]
    }
""".data(using: .utf8)


class PollutionModel : ObservableObject {
    @Published var pollutionData: PollutionData?
    
    init() {
        let decoder = JSONDecoder()
        self.pollutionData = try? decoder.decode(PollutionData.self, from: jsonTest!)
    }
}
