import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    //MARK: - @IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!

    //MARK: - Setter
    func renderCell(for data: DayWeatherModel, and forecastListType: ForecastListType) {
        var image: UIImage?
        switch forecastListType {
        case .daily:
            self.timeLabel.text = data.time
            image = UIImage.getWeatherIcon(by: data.mainDescription, and: data.time)
        case .week:
            self.timeLabel.text = data.dayName
            image = UIImage.getWeatherIcon(by: data.mainDescription)
        }
        
        self.weatherImage.image = image
        self.temperatureLabel.text = data.temperature
    }
}
