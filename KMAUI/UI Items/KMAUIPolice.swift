//
//  KMAUIPolice.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 27.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MapKit
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
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
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
     Get the neighbourhood bounds
     */
    
    public func getNeighbourhoodBounds(neighbourhood: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/\(neighbourhood)/boundary"

        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
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
     Get crime in bounds
     */
    
    public func getCrime(neighbourhood: KMAPoliceNeighbourhood, date: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let point1 = "\(neighbourhood.minLong):\(neighbourhood.minLat)"
        let point2 = "\(neighbourhood.maxLong):\(neighbourhood.minLat)"
        let point3 = "\(neighbourhood.maxLong):\(neighbourhood.maxLat)"
        let point4 = "\(neighbourhood.minLong):\(neighbourhood.maxLat)"
        let requestString = "https://data.police.uk/api/crimes-street/all-crime?poly=\(neighbourhood.minLat),\(point1),\(point2),\(point3),\(point4),\(neighbourhood.minLong)&date=\(date)"
        print("Crime data request: \(requestString)")
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
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
    public var location = ""
    public var bounds = [CLLocationCoordinate2D]()
    public var minLat: Double = 0
    public var maxLat: Double = 0
    public var minLong: Double = 0
    public var maxLong: Double = 0
    public var crimeNearby = [KMACrimeObject]()
    public var crimeArray = [KMACrimeObject]()
    // JSON Strings
    public var identifiers = "" // stores the forceId and forceTeamId
    public var boundary = "" // stores the boundary data
    public var crime = "" // stores the full Crime information loaded
    
    public init() {
    }
    
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
    
    public mutating func fillFrom(boundary: String) {
        self.boundary = boundary
        // Clear the data
        self.bounds = [CLLocationCoordinate2D]()
        self.minLat = 0
        self.maxLat = 0
        self.minLong = 0
        self.maxLong = 0
        // Get the JSON array from the string
        if !boundary.isEmpty, let dataFromString = boundary.data(using: .utf8, allowLossyConversion: false), let json = try? JSON(data: dataFromString).array {
            // Preparing the data from the JSON array
            for location in json {
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
    
    /**
     Checking if the crime object is inside the boundary
     */
    
    public mutating func fillFrom(crime: String) {
        self.crimeArray = [KMACrimeObject]()
        self.crimeNearby = [KMACrimeObject]()
        let polygon = KMAUIUtilities.shared.getPolygon(bounds: self.bounds)
        self.crime = crime
        print("We have the boundary of \(bounds.count) coordinates.")
        print("Checking if the location is inside the boundary.")
        // Get the JSON array from the string
        if !crime.isEmpty, let dataFromString = crime.data(using: .utf8, allowLossyConversion: false), let json = try? JSON(data: dataFromString).array {
            print("CRIME OBJECTS RETURNED: \(json.count)")
            for crimeValue in json {
                if let crimeValue = crimeValue.dictionary {
                    var crimeObject = KMACrimeObject()
                    crimeObject.fillFrom(json: crimeValue)

                    if KMAUIUtilities.shared.checkIf(crimeObject.location, areInside: polygon) {
//                        print("Location: \(crimeObject.location), INSIDE")
                        self.crimeArray.append(crimeObject)
                    } else {
//                        print("Location: \(crimeObject.location), OUTSIDE")
                    }
                    
                    self.crimeNearby.append(crimeObject)
                }
            }
        }
        
        print("TOTAL CRIME OBJECTS VERIFIED: \(crimeArray.count)")
    }
}


public struct KMACrimeObject {
    public var crimeId = 0
    public var persistentId = ""
    public var locationType = ""
    public var locationSubtype = ""
    public var location = CLLocationCoordinate2D()
    public var streetName = ""
    public var streetId = 0
    public var category = ""
    public var outcomeCategory = ""
    public var outcomeDate = ""
    public var context = ""
    public var month = ""
    
    public init() {
    }
    
    public mutating func fillFrom(json: [String: JSON]) {
        if let id = json["id"]?.int {
            self.crimeId = id
        }
        
        if let category = json["category"]?.string {
            self.category = category
        }
        
        if let location = json["location"]?.dictionary {
            var latitudeDouble: Double = 0
            var longitudeDouble: Double = 0
            
            if let latitude = location["latitude"]?.string, let latitudeValue = Double(latitude) {
                latitudeDouble = latitudeValue
            }
            
            if let longitude = location["longitude"]?.string, let longitudeValue = Double(longitude) {
                longitudeDouble = longitudeValue
            }
            
            self.location = CLLocationCoordinate2D(latitude: latitudeDouble, longitude: longitudeDouble)
            
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

