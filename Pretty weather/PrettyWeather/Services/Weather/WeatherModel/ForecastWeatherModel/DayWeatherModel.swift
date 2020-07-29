import Foundation

struct DayWeatherModel: Codable {
    
    //MARK: - Coding keys enumerations
    enum CodingKeys: String, CodingKey {
        case _time = "dt_txt"
        case _weather = "weather"
        case dt
        case main
    }
    
    //MARK: - Private properties
    private let _time: String
    private let dt: Int
    private let main: Main
    
    //MARK: - Properties
    let _weather: [Weather]
    
    var weather: Weather? {
        return self._weather.first
    }
    
    var mainDescription: String {
        return self.weather?.main ?? "--"
    }
    
    var temperature: String {
        return self.main.displayTemperature
    }
    
    var dayName: String {
        return DateManager.shared.makeDateWith(format: .dailyDateFormat, with: self.dt)
    }
    
    var time: String {
        return DateManager.shared.convertDateDrom(stringDate: self._time)
    }
}
