import Foundation

struct CurentWeatherModel: Codable {
    
    //MARK: - Coding keys enumeration
    enum CodingKeys: String, CodingKey {
        case _weather = "weather"
        case main
        case dt
        case timezone
        case id
        case name
        case cod
    }
    
    private let _weather: [Weather]
    
    let main: Main
    let dt: Int
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
    
    var weather: Weather? {
        return self._weather.first
    }
}

struct Main: Codable {
    
    //MARK: - Properties
    var displayTemperature: String {
        let celsiumInt = Int(self.temp.rounded() - self.kelvinsBase)
        return String(celsiumInt) + " C°"
    }
    
    //MARK: - Private properties
    private let temp: Double
    private let kelvinsBase: Double = 273
}
