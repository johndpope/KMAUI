//
//  KMAUIFoursquare.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/// This class represents the method to communicate with the Foursquare Places API
public class KMAUIFoursquare {
    
    // Access variable
    public static let shared = KMAUIFoursquare()
    
    /**
     Get version value - this is a value required by Foursquare API to get the latest updated data, loading the current date
     */
    
    public func getVersion() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateValue = dateFormatter.string(from: Date())
        
        return dateValue
    }
    
    /**
     Get venues from places
     */
    
    public func getVenues(jsonString: String) -> [KMAFoursquareVenue] {
        var foursquareVenues = [KMAFoursquareVenue]()
        
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary,
            let response = json["response"]?.dictionary {

            if let group = response["group"]?.dictionary,
                let results = group["results"]?.array, !results.isEmpty {
                
                for venue in results {
                    var venueObject = KMAFoursquareVenue()
                    venueObject.fillFrom(venue: venue)
                    foursquareVenues.append(venueObject)
                }
            } else if let venues = response["venues"]?.array {
                for venue in venues {
                    if let venue = venue.dictionary {
                        var venueObject = KMAFoursquareVenue()
                        venueObject.setupData(venueData: venue)
                        foursquareVenues.append(venueObject)
                    }
                }
            }
        }
        
        return foursquareVenues
    }
    
    /**
     Get the nearby venues by the location is 1 km radius
     */
    
    public func foursquareVenues(location: String, completion: @escaping (_ places: [KMAFoursquareVenue], _ jsonString: String, _ error: String)->()) {
        let requestString =  "https://api.foursquare.com/v2/search/recommendations?ll=\(location)&radius=1000&categoryId=4d4b7105d754a06374d81259&limit=50&openNow=true&intent=food&client_id=\(KMAUIConstants.shared.foursquareClientKey)&client_secret=\(KMAUIConstants.shared.foursquareClientSecret)&v=\(KMAUIFoursquare.shared.getVersion())"

        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString() {
                        let venues = self.getVenues(jsonString: jsonString)
                        completion(venues, jsonString, "")
                    }
                } catch {
                    completion([KMAFoursquareVenue](), "", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get the venues in the bounds provided
     */
    
    public func foursquareVenues(bounds: String, completion: @escaping (_ venues: [JSON], _ places: [KMAFoursquareVenue], _ error: String)->()) {
        let requestString = "https://api.foursquare.com/v2/venues/search?\(bounds)&categoryId=4d4b7105d754a06374d81259&intent=browse&client_id=\(KMAUIConstants.shared.foursquareClientKey)&client_secret=\(KMAUIConstants.shared.foursquareClientSecret)&v=\(KMAUIFoursquare.shared.getVersion())"
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    var places = [KMAFoursquareVenue]()
                    
                    if let jsonString = json.rawString() {
                        places = self.getVenues(jsonString: jsonString)
                    }
                    
                    if let repsonseValue = json["response"].dictionary, let venues = repsonseValue["venues"]?.array, !venues.isEmpty {
                        completion(venues, places, "")
                    }
                } catch {
                    print([JSON](), [KMAFoursquareVenue](), error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Loading the Foursquare venue details
     */
    
    public func foursquareVenueDetails(foursquareId: String, completion: @escaping (_ venueDetails: String, _ error: String)->()) {
        // Preparing the request screen
        let requestString = "https://api.foursquare.com/v2/venues/\(foursquareId)?client_id=\(KMAUIConstants.shared.foursquareClientKey)&client_secret=\(KMAUIConstants.shared.foursquareClientSecret)&v=\(KMAUIFoursquare.shared.getVersion())"
        // The venues request
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)

                    if let jsonString = json.rawString(), !jsonString.isEmpty {
                        completion(jsonString, "")
                    } else {
                        print("", "Error")
                    }
                } catch {
                    print("", error.localizedDescription)
                }
            }
        }
    }
}

