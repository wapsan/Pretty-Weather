import Foundation

enum StoryboardController: String {
    
    case mainScreen = "mainVIewController"
    case splashScreen = "splashScreenViewController"
    
    var id: String {
        return self.rawValue
    }
}
