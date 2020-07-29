import Foundation

struct Weather: Codable {
    
    //MARK: - Coding keys enumeration
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case weatherDescription = "description"
    }
    
    //MARK: - Properties
    let id: Int
    let main: String
    let weatherDescription: String
    
    var displayWeatherDescription: String {
        return self.weatherDescription.capitalizingFirstLetter()
    }
}
