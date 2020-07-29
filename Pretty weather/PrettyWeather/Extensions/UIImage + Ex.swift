import UIKit

enum WeatherDescription: String {
    
    case thunderstorm = "Thunderstorm"
    case drizzle = "Drizzle"
    case rain = "Rain"
    case snow = "Snow"
    case clear = "Clear"
    case clouds = "Clouds"
    
}

extension UIImage {
    
    static let whiteBackground = UIImage(named: "whiteBackground.png")
    static let greenBackground = UIImage(named: "greenBackground.png")
    static let blueBackground = UIImage(named: "blueBackground.png")
    static let orangeBackground = UIImage(named: "orangeBackground")
    
    static func getBackgroundImage(by weatherDescription: String) -> UIImage? {
        let description = WeatherDescription.init(rawValue: weatherDescription)
        if let weatherDescription = description {
            switch weatherDescription {
            case .thunderstorm:
                return UIImage.blueBackground
            case .drizzle:
                return UIImage.whiteBackground
            case .rain:
                return UIImage.blueBackground
            case .snow:
                return UIImage.whiteBackground
            case .clear:
                return UIImage.greenBackground
            case .clouds:
                return UIImage.blueBackground
            }
        } else {
            return UIImage.orangeBackground
        }
    }
    
    static func getWeatherIcon(by weatherDescription: String, and time: String = "12:00") -> UIImage? {
        let description = WeatherDescription.init(rawValue: weatherDescription)
        
        var isDay: Bool {
            let dayTimes = Array(6...20)
            if dayTimes.contains(time.toIntValue()) {
                return true
            } else {
                return false
            }
        }
        guard let weatherDescription = description else { return UIImage(named: "sunny.png") }
        if isDay {
            switch weatherDescription {
            case .thunderstorm:
                return UIImage(named: "storm.png")
            case .drizzle:
                return UIImage(named: "sunny.png")
            case .rain:
                return UIImage(named: "rain.png")
            case .snow:
                return UIImage(named: "snow.png")
            case .clear:
                return UIImage(named: "sunny.png")
            case .clouds:
                return UIImage(named: "partyNightDay.png")
            }
        } else {
            switch weatherDescription {
            case .thunderstorm:
                return UIImage(named: "storm.png")
            case .drizzle:
                return UIImage(named: "moon.png")
            case .rain:
                return UIImage(named: "rain.png")
            case .snow:
                return UIImage(named: "snow.png")
            case .clear:
                return UIImage(named: "moon.png")
            case .clouds:
                return UIImage(named: "partyCloudNight.png")
            }
        }
    }
}
