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
            let response = json["response"]?.dictionary,
            let group = response["group"]?.dictionary,
            let results = group["results"]?.array, !results.isEmpty {
            
            for venue in results {
                var venueObject = KMAFoursquareVenue()
                venueObject.fillFrom(venue: venue)
                foursquareVenues.append(venueObject)
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
    
    public func foursquareVenues(bounds: String, completion: @escaping (_ venues: [JSON], _ error: String)->()) {
        let requestString = "https://api.foursquare.com/v2/venues/search?\(bounds)&categoryId=4d4b7105d754a06374d81259&intent=browse&client_id=\(KMAUIConstants.shared.foursquareClientKey)&client_secret=\(KMAUIConstants.shared.foursquareClientSecret)&v=\(KMAUIFoursquare.shared.getVersion())"
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let repsonseValue = json["response"].dictionary, let venues = repsonseValue["venues"]?.array, !venues.isEmpty {
                        completion(venues, "")
                    }
                } catch {
                    print([JSON](), error.localizedDescription)
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

// MARK: - Foursquare venue struct

public struct KMAFoursquareVenue {
    public var name = ""
    public var category = ""
    public var categoryPrefix = ""
    public var categorySuffix = ""
    public var latitude: Double = 0.0
    public var longitude: Double = 0.0
    public var distance: Int = 0
    public var address = ""
    public var prefix = ""
    public var suffix = ""
    public var venueId = ""
    // Details data
    public var createdAt = Date()
    public var contact = "" // the JSON object of place's contacts
    public var ratingSignals = 0 // count of ratings
    public var likes = 0 // likes count
    public var photos = "" // photos dictionary
    public var timeZone = "" // the text with the time zone name for the place location
    public var categories = "" // the JSON for the place categories, may be multiple categories
    public var hours = "" // the JSON for the working hours
    public var url = "" // the website
    public var shortUrl = "" // the shortened url for a website
    public var tips = "" // the JSON for the tips leaved by visitors
    public var popular = "" // the JSON for the popular visiting times
    public var hasMenu = false // indicates if we have a menu data
    public var menu = "" // the JSON for the place menu
    public var rating: Double = 0 // the place rating
    public var canonicalUrl = "" // the url for place on Foursquare website
    public var location = "" // the JSON for a location
    public var ratingColor = "" // the HEX value for a rating color
    public var bestPhoto = "" // the JSON for a best photo prepared by the Foursquare
    public var price = "" // the JSON for a price
    public var attributes = "" // the JSON for a place attributes
    public var description = "" // the description
    public var hierarchy = "" // the hierarcy JSON, if the place is inside of another place, for example: mall
    public var parent = "" // the parent JSON, the info for a place in which the current place in
    public var detailsLoaded = false
    
    public init() {
    }
    
    public init(name: String, category: String, categoryPrefix: String, categorySuffix: String, latitude: Double, longitude: Double, address: String, prefix: String, suffix: String, venueId: String) {
        // The main variables from recommendations
        self.name = name
        self.category = category
        self.categoryPrefix = categoryPrefix
        self.categorySuffix = categorySuffix
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.prefix = prefix
        self.suffix = suffix
        self.venueId = venueId
        // The details additional variables
    }
    
    public mutating func fillFrom(venue: JSON) {
        if let venue = venue.dictionary {
            if let venueData = venue["venue"]?.dictionary {
                if let id = venueData["id"]?.string {
                    self.venueId = id
                }
                
                // name
                if let name = venueData["name"]?.string {
                    self.name = name
                }
                // category
                if let categories = venueData["categories"]?.array {
                    for category in categories {
                        if let category = category.dictionary, let primary = category["primary"]?.bool, primary, let categoryName = category["name"]?.string {
                            self.category = categoryName
                            
                            if let icon = category["icon"]?.dictionary {
                                if let prefix = icon["prefix"]?.string {
                                    self.categoryPrefix = prefix
                                }
                                
                                if let suffix = icon["suffix"]?.string {
                                    self.categorySuffix = suffix
                                }
                            }
                        }
                    }
                }
                // address
                if let location = venueData["location"]?.dictionary {
                    // latitude
                    if let lat = location["lat"]?.double {
                        self.latitude = lat
                    }
                    // longitude
                    if let lng = location["lng"]?.double {
                        self.longitude = lng
                    }
                    // formatted address
                    if let formattedAddress = location["formattedAddress"]?.array {
                        var address = ""
                        
                        for addressLine in formattedAddress {
                            if let addressLine = addressLine.string, !addressLine.isEmpty {
                                if address.isEmpty {
                                    address = addressLine
                                } else {
                                    address += ", " + addressLine
                                }
                            }
                        }
                        
                        self.address = address
                    }
                    // distance
                    if let distance = location["distance"]?.int {
                        self.distance = distance
                    }
                }
                
            }
            
            // photo
            if let photoDict = venue["photo"]?.dictionary {
                // prefix
                if let prefix = photoDict["prefix"]?.string {
                    self.prefix = prefix
                }
                // suffix
                if let suffix = photoDict["suffix"]?.string {
                    self.suffix = suffix
                }
            }
        }
    }
    
    public mutating func fillFrom(jsonString: String) {
        if !jsonString.isEmpty, let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            
            if let response = json["response"]?.dictionary, let venueObject = response["venue"]?.dictionary {
                // createdAt
                if let createdAt = venueObject["createdAt"]?.int {
                    self.createdAt = Date(timeIntervalSince1970: Double(createdAt))
                }
                
                // contact
                if let contact = venueObject["contact"]?.rawString() {
                    self.contact = contact
                }
                
                // ratingSignals
                if let ratingSignals = venueObject["ratingSignals"]?.int {
                    self.ratingSignals = ratingSignals
                }
                
                // likes
                if let likes = venueObject["likes"]?.dictionary, let likesCount = likes["count"]?.int {
                    self.likes = likesCount
                }
                
                // photos
                if let photos = venueObject["photos"]?.rawString() {
                    self.photos = photos
                }
                
                // timeZone
                if let timeZone = venueObject["timeZone"]?.string {
                    self.timeZone = timeZone
                }
                
                // categories
                if let categories = venueObject["categories"]?.rawString() {
                    self.categories = categories
                }
                
                // hours
                if let hours = venueObject["hours"]?.rawString() {
                    self.hours = hours
                }
                
                // url
                if let url = venueObject["url"]?.string {
                    self.url = url
                }
                
                // shortUrl
                if let shortUrl = venueObject["shortUrl"]?.string {
                    self.shortUrl = shortUrl
                }
                
                // tips
                if let tips = venueObject["tips"]?.rawString() {
                    self.tips = tips
                }
                
                // popular
                if let popular = venueObject["popular"]?.rawString() {
                    self.popular = popular
                }
                
                // hasMenu
                if let hasMenu = venueObject["hasMenu"]?.bool {
                    self.hasMenu = hasMenu
                }
                
                // menu
                if let menu = venueObject["menu"]?.rawString() {
                    self.menu = menu
                }
                
                // name
                if let name = venueObject["name"]?.string {
                    self.name = name
                }
                
                // rating
                if let rating = venueObject["rating"]?.double {
                    self.rating = rating
                }
                
                // canonicalUrl
                if let canonicalUrl = venueObject["canonicalUrl"]?.string {
                    self.canonicalUrl = canonicalUrl
                }
                
                // location
                if let location = venueObject["location"]?.rawString() {
                    self.location = location
                }
                
                // ratingColor
                if let ratingColor = venueObject["ratingColor"]?.string {
                    self.ratingColor = ratingColor
                }
                
                // bestPhoto
                if let bestPhoto = venueObject["bestPhoto"]?.rawString() {
                    self.bestPhoto = bestPhoto
                }
                
                // price
                if let price = venueObject["price"]?.rawString() {
                    self.price = price
                }
                
                // attributes
                if let attributes = venueObject["attributes"]?.rawString() {
                    self.attributes = attributes
                }
                
                // description
                if let description = venueObject["description"]?.string {
                    self.description = description
                }
                
                // hierarchy
                if let hierarchy = venueObject["hierarchy"]?.rawString() {
                    self.hierarchy = hierarchy
                }
                
                // parent
                if let parent = venueObject["parent"]?.rawString() {
                    self.parent = parent
                }
                
                // details loaded
                detailsLoaded = true
            }
        }
    }
    
    // MARK: - Data methods
    
    public func getDetails() -> String {
        var details = "\(category), \(distance)m"
        
        if !price.isEmpty,
            let dataFromString = price.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary, let tier = json["tier"]?.int, tier > 0, let currency = json["currency"]?.string {
            var value = ""
            
            for _ in 0..<tier {
                value += currency
            }
            
            details = "\(category), \(distance)m, \(value)"
        }
        
        return details
    }
    
    public func getImageString() -> (String, String) {
        var imageString = ""
        var captionString = ""
        
        if !bestPhoto.isEmpty, let dataFromString = bestPhoto.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            // loading image from parts
            if let prefix = json["prefix"]?.string, let suffix = json["suffix"]?.string, let width = json["width"]?.int, let height = json["height"]?.int {
                let urlString = prefix + "\(width)x\(height)" + suffix
                imageString = urlString
            }
            // loading the caption, image source
            if let source = json["source"]?.dictionary, let name = source["name"]?.string {
                captionString = name
            }
        } else  if !prefix.isEmpty, !suffix.isEmpty {
            imageString = prefix + "288x193" + suffix
        }
        
        return (imageString, captionString)
    }
    
    public func getAttributes() -> ([String], [String]) {
        var yesArray = [String]()
        var noArray = [String]()
        
        if !attributes.isEmpty,
            let dataFromString = attributes.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary, let groups = json["groups"]?.array {
            var yesArray = [String]()
            var noArray = [String]()
            
            for group in groups {
                if let group = group.dictionary, let items = group["items"]?.array, !items.isEmpty {
                    for item in items {
                        if let item = item.dictionary, let displayName = item["displayName"]?.string, let displayValue = item["displayValue"]?.string {
                            if displayValue.starts(with: "Yes") {
                                yesArray.append(displayName)
                            } else if displayValue.starts(with: "No") {
                                noArray.append(displayName)
                            }
                        }
                    }
                }
            }
        }
        
        return (yesArray, noArray)
    }
}
