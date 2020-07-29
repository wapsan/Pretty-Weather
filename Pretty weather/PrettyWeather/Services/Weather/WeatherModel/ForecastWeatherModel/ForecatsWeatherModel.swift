import Foundation

struct ForecastWeatherModel: Codable {

    //MARK: - Private properties
    private let list: [DayWeatherModel]
    
    //MARK: - Properties
    var newDayWeatherList: [DayWeatherModel] {
        var newList: [DayWeatherModel] = []
        for (index, data) in self.list.enumerated() {
            if index % 8 == 0 {
                newList.append(data)
            }
        }
        return newList
    }
    
    var hourlyWeatherList: [DayWeatherModel] {
        var newList: [DayWeatherModel] = []
        for i in 1...8 {
            newList.append(self.list[i])
        }
        
        return newList
    }
}
