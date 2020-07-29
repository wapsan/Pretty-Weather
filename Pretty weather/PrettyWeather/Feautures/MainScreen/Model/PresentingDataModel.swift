import Foundation

struct PresentingDataModel {
    
    //MARK: - Properties
    let cityName: String
    let hourlyDate: String
    let mainDate: String
    let weatherDescription: String
    let temperature: String
    let hourlyWeatherList: [DayWeatherModel]
    let dayWeatherList: [DayWeatherModel]
    let mainDescription: String
    
    //MARK: - Initialization
    init(with curentWeather: CurentWeatherModel,
         forecastWeather: ForecastWeatherModel,
         cityName: String) {
        
        self.mainDescription = curentWeather.weather?.main ?? "--"
        self.temperature = curentWeather.main.displayTemperature
        self.mainDate = DateManager.shared.makeDateWith(format: .mainDateFormat,
                                                        in: curentWeather.timezone)
        self.hourlyDate = DateManager.shared.makeDateWith(format: .hourlyDateFormat,
                                                          in: curentWeather.timezone)
        self.weatherDescription = curentWeather
            .weather?
            .weatherDescription
            .capitalizingFirstLetter() ?? "--"
        
        self.hourlyWeatherList = forecastWeather.hourlyWeatherList
        self.dayWeatherList = forecastWeather.newDayWeatherList
        
        self.cityName = cityName
    }
}
