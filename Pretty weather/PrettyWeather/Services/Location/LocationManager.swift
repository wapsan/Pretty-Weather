import CoreLocation

class LocationManager: NSObject {
    
    //MARK: - Singletone propetie
    static let shared = LocationManager()
    
    //MARK: - Properties
    var requestLocetionCompletion: ((CLLocationCoordinate2D, String) -> Void)?
    var updateLocetionCompletion: ((CLLocationCoordinate2D, String) -> Void)?
    private let locationManager = CLLocationManager()
    
    //MARK: - Initialization
    override private init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    //MARK: - Public methods
    func requestCurrentLocation(completion: @escaping (CLLocationCoordinate2D, String) -> Void ){
        self.requestLocetionCompletion = completion
    }
}

//MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          let userLocation: CLLocation = locations[0]
          let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,                                            longitude: userLocation.coordinate.longitude)
          
          let geoCoder = CLGeocoder()
          let location = CLLocation(latitude: userLocation.coordinate.latitude,
                                    longitude: userLocation.coordinate.longitude)

          geoCoder.reverseGeocodeLocation(location, completionHandler: { placemarks, error in
              guard let locationCity = placemarks?[0].locality else { return }
           
              if self.requestLocetionCompletion != nil {
                  self.requestLocetionCompletion!(coordinations, locationCity)
              }
          })
          locationManager.stopUpdatingLocation()
      }
}
