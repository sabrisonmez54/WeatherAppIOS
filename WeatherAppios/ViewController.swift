//
//  ViewController.swift
//  WeatherAppios
//
//  Created by Sabri on 1/10/19.
//  Copyright © 2019 Sabri. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import NVActivityIndicatorView
import CoreLocation



class ViewController: UIViewController , CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    
    let gradientLayer = CAGradientLayer()
    
    let apiKey = "1b506fabc2b96e94873a94f81d5923e8"
    
    var lat = 11.344533
    var long = 104.33322
    
    var activityIndicator: NVActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backgroundView.layer.addSublayer(gradientLayer)
        
        let indicatorSize: CGFloat = 78
        let indicatorFrame = CGRect(x: (view.frame.width-indicatorSize)/2, y: (view.frame.width-indicatorSize)/2, width: indicatorSize, height: indicatorSize)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.white, padding: 20.0)
        activityIndicator.backgroundColor = UIColor.black
        view.addSubview(activityIndicator)
        
        locationManager.requestWhenInUseAuthorization()
        
        activityIndicator.startAnimating()
        if(CLLocationManager.locationServicesEnabled()){
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        setBlueGradientBackground()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiKey)&units=metric").responseJSON {
            response in
            self.activityIndicator.stopAnimating()
            if let responseStr = response.result.value {
                let jsonResponse = JSON(responseStr)
                let jsonWeather = jsonResponse["weather"].array![0]
                let jsonTemp = jsonResponse["main"]
                let iconName = jsonWeather["icon"].stringValue
                
                self.locationLabel.text = jsonResponse["name"].stringValue
                self.conditionImageView.image = UIImage(named: iconName)
                self.conditionLabel.text = jsonWeather["main"].stringValue
                self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
                
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE"
                self.dayLabel.text = dateFormatter.string(from: date)
                
                let suffix = iconName.suffix(1)
                if(suffix == "n"){
                    self.setGrayGradientBackground()
                }else{
                    self.setBlueGradientBackground()
                }
            }
        }
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    func setBlueGradientBackground(){
        
        let colorTop = UIColor(red: 95.0 / 255.0, green: 165.0 / 255.0, blue: 1.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 72.0 / 255.0, green: 114.0 / 255.0, blue: 184.0 / 255.0, alpha: 1.0).cgColor
        
      gradientLayer.frame = view.bounds
      gradientLayer.colors = [colorTop,colorBottom]
        
    }
    
    func setGrayGradientBackground(){
    
        let colorTop = UIColor(red: 151.0 / 255.0, green: 151.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 72.0 / 255.0, green: 72.0 / 255.0, blue: 72.0 / 255.0, alpha: 1.0).cgColor
        
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [colorBottom,colorTop]
    }
        
    
    
    
    
    
}

