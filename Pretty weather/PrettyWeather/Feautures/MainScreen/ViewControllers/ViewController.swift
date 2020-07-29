import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLable: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var thisWeekButton: UIButton!
    @IBOutlet weak var weatherColection: UICollectionView!
    
    //MARK: - Private properties
    private lazy var forecastListType: ForecastListType = .daily
    private lazy var isAlertShown: Bool = false
    private lazy var forecastList: [DayWeatherModel] = []
  
    private var presentingData: PresentingDataModel?
   
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setSelectedButton(button: todayButton)
        self.setUI()
    }
     
    //MARK: - Setter
    func setData(to data: PresentingDataModel) {
        self.presentingData = data
        self.forecastList = data.hourlyWeatherList
    }

    //MARK: - Private methods
    private func setUI() {
        self.weatherColection.delegate = self
        self.weatherColection.dataSource = self
        self.weatherColection.backgroundColor = .clear
        
        guard let presentingData = self.presentingData else  { return }
        self.temperatureLabel.text = presentingData.temperature
        self.cityLable.text = presentingData.cityName
        self.weatherDescription.text = presentingData.weatherDescription
        self.dateLabel.text = presentingData.mainDate
        self.backgroundImage.image = UIImage.getBackgroundImage(by: presentingData.mainDescription)
        self.weatherIcon.image = UIImage.getWeatherIcon(by: presentingData.mainDescription,
                                                        and: presentingData.hourlyDate)
    }
    
    private func setNavigationBar() {
       self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    private func setSelectedButton(button: UIButton) {
        button.isSelected = true
        button.setTitleColor(.white, for: .selected)
        button.tintColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    private func setUnselectedButton(button: UIButton) {
        button.isSelected = false
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
    }

    //MARK: - Actions
    @IBAction func touchTodayButton(_ sender: UIButton) {
        if !sender.isSelected {
            self.setSelectedButton(button: sender)
            self.setUnselectedButton(button: thisWeekButton)
            if let a = self.presentingData?.hourlyWeatherList {
                self.forecastList = a
                self.forecastListType = .daily
            }
            self.weatherColection.reloadData()
        }
    }
    
    @IBAction func touchThisWeekButton(_ sender: UIButton) {
        if !sender.isSelected {
            self.setSelectedButton(button: sender)
            self.setUnselectedButton(button: todayButton)
            if let a = self.presentingData?.dayWeatherList {
                self.forecastList = a
                self.forecastListType = .week
            }
            self.weatherColection.reloadData()
        }
    }
}

//MARK: - Buttons Extension
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.forecastList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eachDate = self.forecastList[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        (cell as? CustomCollectionViewCell)?.renderCell(for: eachDate, and: self.forecastListType)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: self.weatherColection.bounds.width / 4,
                           height: self.weatherColection.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
