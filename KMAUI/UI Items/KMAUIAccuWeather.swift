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

