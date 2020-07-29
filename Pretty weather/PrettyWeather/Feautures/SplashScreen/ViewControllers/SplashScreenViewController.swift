import UIKit

class SplashScreenViewController: UIViewController {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.navigationController?.navigationBar.isHidden = true
        self.geWeatherForCurrentCity(completion: { [weak self] (presentingData) in
            guard let self = self else { return }
            self.pushMainScreen(presentingData: presentingData)
        })
    }
    
    //MARK: - Private methods
    private func geWeatherForCurrentCity(completion: @escaping (_ presentingDataModel: PresentingDataModel) -> Void) {
        LocationManager.shared.requestCurrentLocation { (coordinates, cityName) in
            let parameters = ["lon": coordinates.longitude.description,
                              "lat": coordinates.latitude.description]
            WeatherRequestManager.shared.requestWeather(
                parameters: parameters,
                completionHandler: { [weak self] (curentWeatherModel, forecastWeatherModel) in
                    guard let self = self else { return }
                    if let curentWeather = curentWeatherModel,
                       let forecastWeather = forecastWeatherModel {
                        let presentingData = PresentingDataModel(with: curentWeather,
                                                                 forecastWeather: forecastWeather,
                                                                 cityName: cityName)
                        completion(presentingData)
                    }
                    self.activityIndicator.stopAnimating()
            },
                errorHandler: { [weak self] (error) in
                    guard let self = self,
                        let error = error else { return }
                    self.activityIndicator.stopAnimating()
                    self.showAlert(with: error)
            })
        }
    }
    
    private func showAlert(with error: WeatherRequestManager.WeatherRequestError) {
        self.showDefaultAlert(title: "Error",
                              message: error.errorMessage,
                              preffedStyle: .alert,
                              okTitle: "Ok")
    }
    
    private func pushMainScreen(presentingData: PresentingDataModel) {
        if let mainScreen = self.storyboard?.instantiateViewController(
            identifier: StoryboardController.mainScreen.id) as? ViewController {
            mainScreen.setData(to: presentingData)
            self.navigationController?.pushViewController(mainScreen, animated: true)
        }
    }
}
