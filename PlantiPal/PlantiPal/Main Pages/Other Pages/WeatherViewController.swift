//
//  WeatherViewController.swift
//  PlantiPal
//
//  Created by Delia on 04/06/2023.
//  Copyright © 2023 Delia. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var lowestTemp: UILabel!
    @IBOutlet weak var highestTemp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    @IBOutlet weak var rnTemp: UILabel!
    @IBOutlet weak var conditionsText: UILabel!
    @IBOutlet weak var sunriseTime: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.location.text = locationCity
        self.spinner.startAnimating()
        fetchWeatherData() {
            print("Weather API call finished and view labels updated")
            self.spinner.stopAnimating()
        }
    }
    
    func fetchWeatherData (completion: @escaping () -> Void) {
        let session = URLSession.shared
        let url = URL(string: "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(replaceSpaces(withPercent20In: locationCity))?key=LPVY8Q73WVFLB2VJUGZKG6TN3")!
        
        let weatherTask = session.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else { return }
            
            let weather: WeatherData = try! JSONDecoder().decode(WeatherData.self, from: data)

            DispatchQueue.main.async {
                self.date.text = weather.days[0].datetime
                self.descriptionText.text = weather.description
                self.lowestTemp.text = String(Double((weather.days[0].tempmin - 32) * 5/9).rounded(toPlaces: 1))
                self.highestTemp.text = String(Double((weather.days[0].tempmax - 32) * 5/9).rounded(toPlaces: 1))
                self.feelsLikeTemp.text = String(Double((weather.days[0].feelslike - 32) * 5/9).rounded(toPlaces: 1))
                self.rnTemp.text = String(Double((weather.days[0].temp - 32) * 5/9).rounded(toPlaces: 1))
                var message: String
                if weather.days[0].snow > 0 {
                    message = "Today will have some snow precipitations. You should cover the plants you are storing outside, or protect them from the snow in any way possible."
                    isSnowy = true
                }
                else {
                    message = "No heavy precipitations today or snow, your outside plants will be happy today!"
                    isSnowy = false
                }
                self.conditionsText.text = weather.days[0].description + " " + message
                self.sunriseTime.text = weather.currentConditions.sunrise
                self.sunsetTime.text = weather.currentConditions.sunset
                
                completion()
            }
        }
        weatherTask.resume()
    }
    
    func replaceSpaces(withPercent20In string: String) -> String {
        let replacedString = string.replacingOccurrences(of: " ", with: "%20")
        return replacedString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension Double {
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

