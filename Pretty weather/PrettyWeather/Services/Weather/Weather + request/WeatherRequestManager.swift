import Foundation
import  Alamofire

class WeatherRequestManager {
    
    //MARK: - WeatherRequestError
    enum WeatherRequestError {
        case incorrectUrl
        case networkError(error: Error)
        case serverError(statusCode: Int)
        case parsingError(error: Error)
        case unknown
        
        var errorMessage: String {
            switch self {
            case .incorrectUrl:
                return "Incorect URL"
            case .networkError(error: let error):
                return "Netwotk error - " + error.localizedDescription
            case .serverError(statusCode: let statusCode):
                return "Server error: code " + String(statusCode)
            case .parsingError(error: let error):
                return error.localizedDescription
            case .unknown:
                return "Unknown error"
            }
        }
    }
    
    //MARK: - Singletone propertie
    static let shared = WeatherRequestManager()
    
    //MARK: - Properties
    private lazy var dispatchGroup = DispatchGroup()
    private lazy var parameters: [String: String] = ["appid": self.apiKey]
    private let sessionManager: Alamofire.Session = Session.default
    private let baseURL = "http://api.openweathermap.org/data/2.5/"
    private let apiKey = "69c1790e8b48a558c7234d574dac3e6f"
    
    //MARK: - Public methods
    func requestWeather(parameters: [String: String]? = nil,
                        completionHandler: @escaping (CurentWeatherModel?, ForecastWeatherModel?) -> Void,
                        errorHandler: @escaping (WeatherRequestError?) -> Void) {
        
        var currentWeatherModel: CurentWeatherModel?
        var foreCastWeatherModel: ForecastWeatherModel?
        
        var urlParameters = self.parameters
        if let parameters = parameters {
            for paramater in parameters {
                urlParameters[paramater.key] = paramater.value
            }
        }
        
        guard let currentWeatherURL = self.getUrlWith(
            url: self.baseURL,
            path: URLPath.currentWather,
            params: urlParameters) else {
                errorHandler(.incorrectUrl)
                return
        }
        
        guard let forecastWeatherURL = self.getUrlWith(
            url: self.baseURL,
            path: URLPath.forecatWeather,
            params: urlParameters) else {
                errorHandler(.incorrectUrl)
                return
        }
        
        self.dispatchGroup.enter()
        self.sessionManager.request(currentWeatherURL).responseJSON { (response) in
            if let error = response.error {
                errorHandler(.networkError(error: error))
                self.dispatchGroup.leave()
                return
            } else if let _ = response.value as? [String: AnyObject],
                let httpResponse = response.response {
                switch httpResponse.statusCode {
                case 200...300:
                    if let data = response.data,
                        let currentWeatherData = try? JSONDecoder().decode(
                            CurentWeatherModel.self,
                            from: data) {
                        currentWeatherModel = currentWeatherData
                        self.dispatchGroup.leave()
                    }
                case 401, 404:
                    self.dispatchGroup.leave()
                    print("code 401 or 404")
                default:
                    self.dispatchGroup.leave()
                    errorHandler(.serverError(statusCode: httpResponse.statusCode))
                }
            } else {
                self.dispatchGroup.leave()
                errorHandler(.unknown)
            }
        }
        
        self.dispatchGroup.enter()
        self.sessionManager.request(forecastWeatherURL).responseJSON { (response) in
            if let error = response.error {
                errorHandler(.networkError(error: error))
                self.dispatchGroup.leave()
                return
            } else if let _ = response.value as? [String: AnyObject],
                let httpResponse = response.response {
                switch httpResponse.statusCode {
                case 200...300:
                    if let data = response.data,
                        let forecastWeatherData = try? JSONDecoder().decode(
                            ForecastWeatherModel.self,
                            from: data) {
                        foreCastWeatherModel = forecastWeatherData
                        self.dispatchGroup.leave()
                    }
                case 401, 404:
                    self.dispatchGroup.leave()
                default:
                    self.dispatchGroup.leave()
                    errorHandler(.serverError(statusCode: httpResponse.statusCode))
                }
            } else {
                self.dispatchGroup.leave()
                errorHandler(.unknown)
            }
        }
        
        self.dispatchGroup.notify(queue: .main, execute: {
            completionHandler(currentWeatherModel, foreCastWeatherModel)
        })
    }
}

private extension WeatherRequestManager {
    
    func getUrlWith(url: String, path: String, params: [String: String]? = nil) -> URL? {
        guard var components = URLComponents(string: url + path) else { return nil }
        if let params = params {
            components.queryItems = params.map({
                URLQueryItem(name: $0.key, value: $0.value)
            })
        }
        return components.url
    }
}
