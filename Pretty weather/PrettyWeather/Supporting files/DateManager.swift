import Foundation

class DateManager {
    
    //MARK: - Singletone properties
    static let shared = DateManager()
    
    //MARK: - Dateformets enumeration
    enum DateFormats: String {
        case mainDateFormat = "EEEE d MMM"
        case hourlyDateFormat = "HH:mm"
        case dailyDateFormat = "EEEE"
        case incomeDateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    //MARK: - Private properties
    private lazy var dateFormatter = DateFormatter()
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Public methods
    func makeDateWith(format: DateFormats, with date: Int) -> String {
        guard let timeInterval = TimeInterval(exactly: Double(date)) else { return "" }
        let date = Date(timeIntervalSinceNow: timeInterval)
        self.dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: date)
    }
    
    func getCurrentTime() -> String {
        self.dateFormatter.dateFormat = DateFormats.hourlyDateFormat.rawValue
        return self.dateFormatter.string(from: Date())
    }
    
    func convertDateDrom( stringDate: String) -> String {
        self.dateFormatter.dateFormat = DateFormats.incomeDateFormat.rawValue
        guard let date = dateFormatter.date(from: stringDate) else { return "" }
        self.dateFormatter.dateFormat = DateFormats.hourlyDateFormat.rawValue
        return dateFormatter.string(from: date)
    }
    
    func makeDateWith(format: DateFormats, in timezone: Int) -> String {
        let timeZone = TimeZone(secondsFromGMT: timezone)
        self.dateFormatter.timeZone = timeZone
        self.dateFormatter.dateFormat = format.rawValue
        let date = dateFormatter.string(from: Date())
        return date
    }
}
