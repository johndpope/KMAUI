//
//  KMAUIAccuWeather.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public class KMAUIAccuWeather {
    
    // Access variable
    public static let shared = KMAUIAccuWeather()
    
    /**
     Get the location key
     */
    
    public func getLocationKey(location: String, completion: @escaping (_ key: String, _ jsonString: String, _ error: String)->()) {
        let requestString = "https://dataservice.accuweather.com/locations/v1/cities/geoposition/search?apikey=\(KMAUIConstants.shared.accuweatherApiKey)&q=\(location)&language=en-us&details=false&toplevel=false"
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonDict = json.dictionary, let locationKey = jsonDict["Key"]?.string, !locationKey.isEmpty, let jsonString = json.rawString() {
                        completion(locationKey, jsonString, "")
                    } else {
                        completion("", "", "Error")
                    }
                } catch {
                    completion("", "", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get the current conditions for location key
     */
    
    public func getCurrentConditions(locationKey: String, completion: @escaping (_ weatherObject: KMAWeather,_ jsonString: String, _ error: String)->()) {
        let requestString = "https://dataservice.accuweather.com/currentconditions/v1/\(locationKey)?apikey=\(KMAUIConstants.shared.accuweatherApiKey)&details=true"
        
        AF.request(requestString).responseJSON { response in
            var jsonString = ""
            var errorString = ""
            
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonArray = json.array, !jsonArray.isEmpty, let jsonStringValue = json.rawString() {
                        jsonString = jsonStringValue
                    }
                } catch {
                    errorString = error.localizedDescription
                }
            } else {
                errorString = ""
            }
            
            completion(self.getReadableConditions(jsonString: jsonString), jsonString, errorString)
        }
    }
    
    /**
     Translate the current conditions jsonString into the readable format
     */
    
    public func getReadableConditions(jsonString: String) -> KMAWeather {
        if jsonString.isEmpty {
            // Should also have the completion handler here to display the error on the location cell
            var weatherError = KMAWeather()
            weatherError.title = "No weather data"
            weatherError.text = "We're not able to display the weather at this moment, please try reloading the screen."
            weatherError.image = "Error"
            
            return weatherError
        }
        
        var weatherObject = KMAWeather()
        weatherObject.fillFrom(jsonString: jsonString)
        
        return weatherObject
    }
}

// MARK: - Weather struct

public struct KMAWeather {
    public var title = ""
    public var text = ""
    public var image = ""
    
    public init() {
    }
    
//    public init(title: String, text: String, image: String) {
//        self.title = title
//        self.text = text
//        self.image = image
//    }
    
    public mutating func fillFrom(jsonString: String) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).array,
            !json.isEmpty, let jsonDict = json[0].dictionary {

            // Weather text + temperature
            if let weatherText = jsonDict["WeatherText"]?.string {
                self.title = weatherText
                
                if let temperature = jsonDict["Temperature"]?.dictionary,
                    let metrictDegrees = temperature["Metric"]?.dictionary,
                    let value = metrictDegrees["Value"]?.double {
                    self.title = weatherText + ", \((Double(Int(value * 10)) / 10))°C"
                }
            }
            
            // Real feel + wind
            if let realFeelTemperature = jsonDict["RealFeelTemperature"]?.dictionary,
                let metrictDegrees = realFeelTemperature["Metric"]?.dictionary,
                let value = metrictDegrees["Value"]?.double {
                var windSpeed = ""
                
                if let wind = jsonDict["Wind"]?.dictionary,
                    let speed = wind["Speed"]?.dictionary,
                    let metrictDegrees = speed["Metric"]?.dictionary,
                    let value = metrictDegrees["Value"]?.double {
                    windSpeed = ", Wind: \(value) km/h"
                }
                
                self.text = "RealFeel® \((Double(Int(value * 10)) / 10))°C" + windSpeed
            }
            
            if let weatherIcon = jsonDict["WeatherIcon"]?.int {
                var weatherIconString = "https://developer.accuweather.com/sites/default/files/\(weatherIcon)-s.png"
                
                if weatherIcon < 10 {
                    weatherIconString = "https://developer.accuweather.com/sites/default/files/0\(weatherIcon)-s.png"
                }
                
                self.image = weatherIconString
            }
        }
    }
}
