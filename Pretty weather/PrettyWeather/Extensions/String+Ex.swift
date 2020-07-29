extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + self.dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
   func toIntValue() -> Int {
       let strirngArray = self.map{ String($0) }
       var clearTimeArray: [String] = []
       for index in 0..<2 {
           clearTimeArray.append(strirngArray[index])
       }
       let clearTime = clearTimeArray.reduce("", +)
       return Int(clearTime) ?? 0
   }
}
