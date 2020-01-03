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
     Get the neighbourhood details
     */
    
    public func getNeighbourhoodDetails(neighbourhood: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/\(neighbourhood)"

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
    
    public func getNeighbourhoodCrime(neighbourhood: KMAPoliceNeighbourhood, date: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/crimes-street/all-crime?poly=\(neighbourhood.polygonString)" // &date=\(date)
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
     Get the neighbourhood team
     */
    
    public func getNeighbourhoodTeam(neighbourhood: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/\(neighbourhood)/people"
        
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
                    print("Error: \(error.localizedDescription)")
                    completion("", error.localizedDescription)
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
    public var crimeDate = ""
    public var crimeItems = [[String: AnyObject]]()
    public var crimeString = ""
    public var polygonString = ""
    public var teamArray = [KMAPoliceman]()
    // JSON Strings
    public var identifiers = "" // stores the forceId and forceTeamId
    public var boundary = "" // stores the boundary data
    public var crime = "" // stores the full Crime information loaded
    public var team = "" // store the full Team information loaded
    
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
        
        // Get the polygon string
        self.getPolygonString()
    }
    
    /**
     Checking if the crime object is inside the boundary
     */
    
    public mutating func fillFrom(crime: String) {
        self.crimeArray = [KMACrimeObject]()
        self.crimeNearby = [KMACrimeObject]()
        let polygon = KMAUIUtilities.shared.getPolygon(bounds: self.bounds)
        self.crime = crime

        // Get the JSON array from the string
        if !crime.isEmpty, let dataFromString = crime.data(using: .utf8, allowLossyConversion: false), let json = try? JSON(data: dataFromString).array {
            for crimeValue in json {
                if let crimeValue = crimeValue.dictionary {
                    var crimeObject = KMACrimeObject()
                    crimeObject.fillFrom(json: crimeValue)

                    if KMAUIUtilities.shared.checkIf(crimeObject.location, areInside: polygon) {
                        self.crimeArray.append(crimeObject)
                    } else {
                        self.crimeNearby.append(crimeObject)
                    }
                }
            }
        }
        
        // Prepare categories
        self.prepareCrimeCategories()
    }
    
    /**
     Prepare an array of most common crime categories
     */
    
    public mutating func prepareCrimeCategories() {
        self.crimeItems = [[String: AnyObject]]()
        
        for crime in self.crimeArray {
            var exists = false
            
            for (index, item) in self.crimeItems.enumerated() {
                if let category = item["category"] as? String, category == crime.category, var ids = item["ids"] as? [String] {
                    var item = item
                    ids.append(crime.persistentId)
                    item["ids"] = ids as AnyObject
                    
                    if let count = item["count"] as? Int {
                        item["count"] = (count + 1) as AnyObject
                    }
                    
                    self.crimeItems[index] = item
                    exists = true
                    
                    break
                }
            }
            
            if !exists {
                var dict = [String: AnyObject]()
                dict["category"] = crime.category as AnyObject
                dict["ids"] = [crime.persistentId] as AnyObject
                dict["count"] = 1 as AnyObject
                self.crimeItems.append(dict)
            }
        }
        
        self.crimeItems = KMAUIUtilities.shared.orderCount(crimes: crimeItems)
        self.prepareCrimeString()
    }
    
    /**
     Prepare the crime items string
     */
    
    public mutating func prepareCrimeString() {
        // Prepare the crime string
        self.crimeString = ""
        
        for (index, crimeItem) in self.crimeItems.enumerated() {
            if let category = crimeItem["category"] as? String, let count = crimeItem["count"] as? Int {
                var endSymbol = ";"
                
                if index + 1 == self.crimeItems.count {
                    endSymbol = "."
                }
                
                if !self.crimeString.isEmpty {
                    self.crimeString += "\n"
                }
                
                self.crimeString += "• \(category.capitalized.replacingOccurrences(of: "-", with: " ")) – \(count)\(endSymbol)"
            }
        }
    }
    
    /**
     Get the polygon string
     */
    
    public mutating func getPolygonString() {
        let verticalDelta = maxLat - minLat
        let horizontalDelta = maxLong - minLong
        
        let point1 = "\(minLong):\(minLat)"
        let point2 = "\(minLong):\(minLat + verticalDelta)"
        let point3 = "\(minLong):\(maxLat)"
        let point4 = "\(minLong + horizontalDelta):\(maxLat)"
        let point5 = "\(maxLong):\(maxLat)"
        let point6 = "\(maxLong):\(maxLat - verticalDelta)"
        let point7 = "\(maxLong):\(minLat)"
        let point8 = "\(maxLong - horizontalDelta):\(minLat)"
        
        polygonString = "\(minLat),\(point1),\(point2),\(point3),\(point4),\(point5),\(point6),\(point7),\(point8),\(minLong)"
    }
    
    /**
     Get the team
     */
    
    public mutating func fillTeam() {
        if !team.isEmpty, let dataFromString = team.data(using: .utf8, allowLossyConversion: false), let json = try? JSON(data: dataFromString).array {
            self.teamArray = [KMAPoliceman]()
            
            for item in json {
                var policeman = KMAPoliceman()
                policeman.fillFrom(json: item)
                self.teamArray.append(policeman)
            }
        }
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

/**
 Police workers
 */

public struct KMAPoliceman {
    public var name = ""
    public var rank = ""
    public var bio = ""
    public var contact = ""
    
    public init() {
    }
    
    public mutating func fillFrom(json: JSON) {
        if let json = json.dictionary {
            if let rank = json["rank"]?.string {
                self.rank = rank
            }
            
            if let name = json["name"]?.string {
                self.name = name
            }
            
            if let bio = json["bio"]?.string {
                self.bio = bio
            }
            
            if let contactDetails = json["contact_details"]?.rawString() {
                self.contact = contactDetails
            }
        }
    }
}
