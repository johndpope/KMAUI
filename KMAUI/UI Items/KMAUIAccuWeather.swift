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

class KMAUIAccuWeather {
    
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
}
