//
//  KMAUIPolice.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 27.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

public class KMAUIPolice {
    
    // Access variable
    public static let shared = KMAUIPolice()
    
    // MARK: - Police.uk API
    
    /**
     Get the neighbourhood data for location
     */
    
    public func getNeighbourhood(location: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/locate-neighbourhood?q=\(location)"
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString() {
                        completion(jsonString, "")
                    } else {
                        completion("", "Error")
                    }
                } catch {
                    completion("", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get crime data for a location
     */
    
    public func getCrimeData(location: String, completion: @escaping (_ crimeData: [KMACrimeObject], _ error: String)->()) {
        let requestString = "https://data.police.uk/api/crimes-street/all-crime?\(location)" // limited to the previous month
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    var crimeData = [KMACrimeObject]()
                    
                    if let crimeArray = json.array {
                        for crimeValue in crimeArray {
                            if let crimeValue = crimeValue.dictionary {
                                var crimeObject = KMACrimeObject()
                                crimeObject.fillFrom(json: crimeValue)
                                crimeData.append(crimeObject)
                            }
                        }
                    }
                    
                    completion(crimeData, "")
                } catch {
                    print("Error: \(error.localizedDescription)")
                    completion([KMACrimeObject](), error.localizedDescription)
                }
            }
        }
    }
}

public struct KMAPoliceNeighbourhood {
    public var forceId = ""
    public var forceTeamId = ""
    public var bounds = [CLLocationCoordinate2D]()
    public var minLat: Double = 0
    public var maxLat: Double = 0
    public var minLong: Double = 0
    public var maxLong: Double = 0
    // JSON Strings
    public var identifiers = "" // stores the forceId and forceTeamId
    
    public mutating func setupIdentifiers() {
        if !identifiers.isEmpty,
            let dataFromString = identifiers.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            // Get force
            if let force = json["force"]?.string {
                self.forceId = force
            }
            // get id
            if let neighbourhood = json["neighbourhood"]?.string {
                self.forceTeamId = neighbourhood
            }
        }
    }
    
    public mutating func fillFrom(bounds: [JSON]) {
        self.bounds = [CLLocationCoordinate2D]()
        minLat = 0
        maxLat = 0
        minLong = 0
        maxLong = 0
        
        for location in bounds {
            if let location = location.dictionary, let latitude = location["latitude"]?.string, let latitudeValue = Double(latitude), let longitude = location["longitude"]?.string, let longitudeValue = Double(longitude) {
                self.bounds.append(CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue))
                
                // Getting the bounds
                if minLat > latitudeValue || minLat == 0 {
                    minLat = latitudeValue
                }
                
                if maxLat < latitudeValue || maxLat == 0 {
                    maxLat = latitudeValue
                }
                
                if minLong > longitudeValue || minLong == 0 {
                    minLong = longitudeValue
                }
                
                if maxLong < longitudeValue || maxLong == 0 {
                    maxLong = longitudeValue
                }
            }
        }
    }
}


public struct KMACrimeObject {
    public var crimeId = 0
    public var persistentId = ""
    public var locationType = ""
    public var locationSubtype = ""
    public var latitude: Double = 0
    public var longitude: Double = 0
    public var streetName = ""
    public var streetId = 0
    public var category = ""
    public var outcomeCategory = ""
    public var outcomeDate = ""
    public var context = ""
    public var month = ""
    
    public mutating func fillFrom(json: [String: JSON]) {
        if let id = json["id"]?.int {
            self.crimeId = id
        }
        
        if let category = json["category"]?.string {
            self.category = category
        }
        
        if let location = json["location"]?.dictionary {
            if let latitude = location["latitude"]?.string, let latitudeValue = Double(latitude) {
                self.latitude = latitudeValue
            }
            
            if let longitude = location["longitude"]?.string, let longitudeValue = Double(longitude) {
                self.longitude = longitudeValue
            }
            
            if let street = location["street"]?.dictionary {
                if let streetName = street["name"]?.string {
                    self.streetName = streetName
                }
                
                if let streetId = street["id"]?.int {
                    self.streetId = streetId
                }
            }
        }
        
        if let outcomeStatus = json["outcome_status"]?.dictionary {
            if let outcomeCategory = outcomeStatus["category"]?.string {
                self.outcomeCategory = outcomeCategory
            }
            
            if let outcomeDate = outcomeStatus["date"]?.string {
                self.outcomeDate = outcomeDate
            }
        }
        
        if let persistentId = json["persistent_id"]?.string {
            self.persistentId = persistentId
        }
        
        if let locationType = json["location_type"]?.string {
            self.locationType = locationType
        }
        
        if let locationSubtype = json["location_subtype"]?.string, !locationSubtype.isEmpty {
            self.locationSubtype = locationSubtype
        }
        
        if let context = json["context"]?.string {
            self.context = context
        }
        
        if let month = json["month"]?.string {
            self.month = month
        }
    }
}

