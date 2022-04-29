//
//  ViewController.swift
//  weather
//
//  Created by Гость on 26.04.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    let lokationManager = CLLocationManager()
    var weatherData = WeatherData()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startLocationManager()
    }
    
    func startLocationManager(){
        lokationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            lokationManager.delegate = self
            lokationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            lokationManager.pausesLocationUpdatesAutomatically = false
            lokationManager.startUpdatingLocation()
        }
    }
    func updateView(){
        
    }
    func updateWeatherInfo(latitude: Double, longtitude: Double){
        let session = URLSession.shared
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&appid=d4e106082927edc4ff6a00fe69ff6196&units=metric&lang=ru")!
        let task = session.dataTask(with: url) {(data, response, error)in
            guard error == nil else{
                print("DataTask error: \(error!.localizedDescription)")
                return
            }
            do {
                self.weatherData = try JSONDecoder().decode(WeatherData.self, from: data!)
                DispatchQueue.main.async {
                    self.updateView()
                }
                print(self.weatherData)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }


}
extension ViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last{
            updateWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
        }
    }
    
}
