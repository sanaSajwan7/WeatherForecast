//
//  ViewController.swift
//  Weather Forecast
//
//  Created by sana sajwan on 08/09/20.
//  Copyright © 2020 sana sajwan. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    var currentLocation: CLLocation?
   // var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    var isViewPresented: Bool = false

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1
        locationManager.delegate = self

        // 2
        if CLLocationManager.locationServicesEnabled() {
          // 3
          locationManager.requestLocation()

          // 4
          mapView.isMyLocationEnabled = true
          mapView.settings.myLocationButton = true
            mapView.delegate = self
        } else {
          // 5
          locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func getWeatherData(coordinate: CLLocationCoordinate2D){
        let objHelper:iHelperClass = iHelperClass()
        
        
        let dicParam:NSMutableDictionary = NSMutableDictionary()
        dicParam.setObject("\(coordinate.latitude)", forKey: "lat" as NSCopying)
        dicParam.setObject("\(coordinate.longitude)", forKey: "long" as NSCopying)
        dicParam.setObject(weatherKey, forKey: "appid" as NSCopying)
        //

        objHelper.iHelperAPI_GET(urlMethodOrFile: "http://api.openweathermap.org/data/2.5/weather?lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(weatherKey)", parameters: nil,apiIdentifier: "get_identifier",delegate: self)
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

}

extension ViewController: iHelperClassDelegate{
    func iHelperResponseSuccess(ihelper: iHelperClass) {
                if(ihelper.apiIdentifier == "get_identifier")
        {
            let stringJson  =  String(data: ihelper.responseData! as Data, encoding: String.Encoding.utf8)
            
            print("wenservice GET response >>> \(String(describing: stringJson))")

            let weatherDict = convertToDictionary(text: stringJson!)
            
            DispatchQueue.main.async {
                if(!self.isViewPresented){
                    self.isViewPresented = true
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
                vc.weatherData = weatherDict! as NSDictionary
                    self.present(vc, animated: true) {
                        self.isViewPresented = false
                    }
                }
            }
        }


    }
    

    
    func iHelperResponseFail(error: NSError) {
                print("error : \(error)")
        DispatchQueue.main.async {
            let alert  =  UIAlertController(title: "Error", message: "ERROR : \(error)", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
        }

    }
    


// MARK: - CLLocationManagerDelegate
//1
extension ViewController: CLLocationManagerDelegate {
  // 2
  func locationManager(
    _ manager: CLLocationManager,
    didChangeAuthorization status: CLAuthorizationStatus
  ) {
    // 3
    guard status == .authorizedWhenInUse else {
      return
    }
    // 4
    locationManager.requestLocation()

    //5
    mapView.isMyLocationEnabled = true
    mapView.settings.myLocationButton = true
  }

  // 6
  func locationManager(
    _ manager: CLLocationManager,
    didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else {
      return
    }

    // 7
    mapView.camera = GMSCameraPosition(
      target: location.coordinate,
      zoom: 15,
      bearing: 0,
      viewingAngle: 0)
  }

  // 8
  func locationManager(
    _ manager: CLLocationManager,
    didFailWithError error: Error
  ) {
    print(error)
  }
}


extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        
        getWeatherData(coordinate: coordinate)
        
    }
}

