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

public class KMAUIPolice {
    
    // Access variable
    public static let shared = KMAUIPolice()
    
    // MARK: - Police.uk API
    
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

