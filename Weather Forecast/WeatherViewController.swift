//
//  WeatherViewController.swift
//  Weather Forecast
//
//  Created by sana sajwan on 08/09/20.
//  Copyright © 2020 sana sajwan. All rights reserved.
//

import UIKit
import Kingfisher

class WeatherViewController: UIViewController {
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var tempratureLbl: UILabel!
    @IBOutlet weak var weatherTypeLbl: UILabel!
    var weatherData = NSDictionary()
    
    @IBOutlet weak var weatherIcon: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let now = Date()

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none

        let date = formatter.string(from: now)
        
        dateLbl.text  = date
        print(weatherData)

        getWeatherType()
        getCityName()
        getTemparatureName()
        getWeatherIcon()

        
    }
    
    func getWeatherType(){
        guard let weatherType = ((weatherData["weather"] as! NSArray)[0] as! NSDictionary).value(forKey: "description") else { return  }
        weatherTypeLbl.text = (weatherType as! String)
    }
    
    func getCityName(){
        guard let cityName = weatherData.value(forKey: "name") else { return  }
        cityLbl.text = (cityName as! String)
    }
    
    func getTemparatureName(){
        guard let temp = (weatherData.value(forKey: "main") as! NSDictionary).value(forKey: "temp") else { return }
        let kelvinTemp = (temp as! NSNumber).floatValue
        tempratureLbl.text = "\(kelvinTemp - 273.15)" + "°" + "C"
    }
    
    func getWeatherIcon(){
       //
        
    guard let weatherImage = ((weatherData["weather"] as! NSArray)[0] as! NSDictionary).value(forKey: "icon") else { return  }
        

        let url = URL(string: "http://openweathermap.org/img/wn/\(weatherImage)@2x.png");
        //weatherIcon.kf.setImage(with: url)
        weatherIcon.kf.setImage(with: url)
    }
    


    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
