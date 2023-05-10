import Foundation

class ModelData: ObservableObject {
    @Published var forecast: Forecast?
    @Published var userLocation: String = "No location"
    let apiURL = "https://api.openweathermap.org/data/3.0/onecall?lat=%f&lon=%f&units=metric&appid=70b5348ce1afed7a929a9b23eec7ce2a"
    
    init() {
        self.forecast = load("london.json")
    }
    
    // asyncronous API call to fetch the pollution data
    func loadData(lat: Double, lon: Double) async {
        let url = URL(string: String(format: apiURL, lat, lon))
        let session = URLSession(configuration: .default)
        
        do {
            let (data, _) = try await session.data(from: url!)
            // print(String(decoding: data, as: UTF8.self)) // debug code
            let forecastData = try JSONDecoder().decode(Forecast.self, from: data)
            
            DispatchQueue.main.async {
                self.forecast = forecastData
            }
        } catch {
            print(error.localizedDescription.debugDescription)
            
            // clear the forecast data if API call failed so that we can display an error message
            DispatchQueue.main.async {
                self.forecast = nil
            }
        }
    }
    
    func load<Forecast: Decodable>(_ filename: String) -> Forecast {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(Forecast.self):\n\(error)")
        }
    }
}
