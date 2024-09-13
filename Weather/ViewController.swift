//
//  ViewController.swift
//  Weather
//
//  Created by Ivan Yanishevskyi on 10/09/24.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var getWeatherButton: UIButton!
    let locationManager: CLLocationManager = CLLocationManager()
    var CurrCordinates:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Location manager intializaion
        locationManager.delegate = self
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
            
        getWeatherButton.addTarget(self, action: #selector(didTapGetWeather), for: .touchUpInside)
    }
    //Weather function initialization
    @objc func didTapGetWeather(){
        guard let coordinates = CurrCordinates else {
                print("Missing coordinates")
                return
            }
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true"
        let url = URL(string: urlString)
        guard let url = url else {
            print("Service is unavaliable")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with:request){data,response,error in
            if let data,let weather = try? JSONDecoder().decode(WeatherData.self, from: data){
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(weather.currentWeather.temperature) °C"
                }
            }else{
                print("no parsed")
            }
        }
        task.resume()
        didTapGetLocation()
    }
    //Location reversed geo function
    @objc func didTapGetLocation(){
        guard let coordinates = CurrCordinates else {
                print("Missing coordinates")
                return
            }
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        let urlString = "https://us1.locationiq.com/v1/reverse?key=pk.57b1e3c9a5d56c9b4e7d88388ee0c332&lat=\(latitude)&lon=\(longitude)&format=json"
        let url = URL(string: urlString)
        guard let url = url else {
            print("Service is unavaliable")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let locationData = try? JSONDecoder().decode(LocationData.self, from: data) {
                DispatchQueue.main.async {
                    // check if state exists
                    let city = locationData.address.city ?? "Unknown city"
                    let country = locationData.address.country ?? "Unknown country"
                    if let state = locationData.address.state{
                        self.locationLabel.text = "\(city), \(state), \(country)"

                    }else{
                        //if not show only country and city
                        self.locationLabel.text = "\(city), \(country)"
                    }
                }
            }
        }
        task.resume()

    }
    //CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last as! CLLocation
        if(currentLocation.horizontalAccuracy > 0){
            let cords =  CLLocationCoordinate2DMake( currentLocation.coordinate.latitude,currentLocation.coordinate.longitude)
            CurrCordinates = cords
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
        print("Cant find your location")
    }
}
