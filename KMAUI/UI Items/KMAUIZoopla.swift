//
//  KMAUIZoopla.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

public class KMAUIZoopla {

    // Access variable
    public static let shared = KMAUIZoopla()
    
    /**
     Get the average formatted details from the KMAZooplaProperty array
     */
    
    public func getAverage(propertyArray: [KMAZooplaProperty]) -> (String, String, Int, Int) {
        var averageRent = "Not available"
        var averageSale = "Not available"
        
        // Sale data
        var saleProperty = [KMAZooplaProperty]()
        var saleBedrooms = 0
        var salePrice = 0
        // Rent data
        var rentProperty = [KMAZooplaProperty]()
        var rentBedrooms = 0
        var rentPrice = 0

        for property in propertyArray {
            if property.status == "rent" {
                rentProperty.append(property)
                rentBedrooms += property.numBedrooms
                rentPrice += property.rentMonth
            } else if property.status == "sale" {
                saleProperty.append(property)
                saleBedrooms += property.numBedrooms
                salePrice += property.salePrice
            }
        }
        
        var averageRentValue = 0
        var averageSaleValue = 0
        
        // Rent analysis
        if !saleProperty.isEmpty {
            averageRentValue = rentPrice/rentProperty.count
            averageRent = "£\(averageRentValue.withCommas()) pcm (\(rentProperty.count))"
        }

        // Sale analysis
        if !saleProperty.isEmpty {
            averageSaleValue = salePrice/saleProperty.count
            averageSale = "£\(averageSaleValue.withCommas()) (\(saleProperty.count))"
        }
        
        return (averageRent, averageSale, averageRentValue, averageSaleValue)
    }
    
    /**
     Get property items
     */
    
    public func getPropertyItems(jsonString: String) -> [KMAZooplaProperty] {
        var zooplaPropertyArray = [KMAZooplaProperty]()
        
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary,
            let listing = json["listing"]?.array {
            
            for propertyItem in listing {
                var zooplaProperty = KMAZooplaProperty()
                zooplaProperty.fillFrom(propertyItem: propertyItem)
                zooplaPropertyArray.append(zooplaProperty)
            }
        }
        
        return zooplaPropertyArray
    }
    
    /**
     Get the property list around the provided property
     */
    
    public func zooplaProperty(location: String, completion: @escaping (_ property: [KMAZooplaProperty], _ jsonString: String, _ error: String)->()) {
        let requestString = "https://api.zoopla.co.uk/api/v1/property_listings.js?\(location)&radius=0.62&order_by=age&ordering=descending&page_size=100&api_key=\(KMAUIConstants.shared.zooplaApiKey)" // 1 km radius around user's property
        // The venues request
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString() {
                        let places = self.getPropertyItems(jsonString: jsonString)
                        completion(places, jsonString, "")
                    }
                } catch {
                    completion([KMAZooplaProperty](), "", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get the property pins inside the provided bounds
     */
    
    public func zooplaProperty(bounds: String, completion: @escaping (_ property: [JSON], _ places: [KMAZooplaProperty], _ error: String)->()) {
        // Preparing the request string
        let requestString = "https://api.zoopla.co.uk/api/v1/property_listings.js?\(bounds)&page_size=100&api_key=z2jerfddwxkye3w653muzfjy"
        // The venues request
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    var places = [KMAZooplaProperty]()
                    
                    if let jsonString = json.rawString() {
                        places = self.getPropertyItems(jsonString: jsonString)
                    }
                    
                    if let listing = json["listing"].array {
                        completion(listing, places, "")
                    }
                } catch {
                    completion([JSON](), [KMAZooplaProperty](), error.localizedDescription)
                }
            }
        }
    }
}


