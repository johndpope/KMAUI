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
    
    public func getAverage(propertyArray: [KMAZooplaProperty]) -> (String, String) {
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
        
        // Rent analysis
        if !saleProperty.isEmpty {
            let averageRentValue = rentPrice/rentProperty.count
            averageRent = "£\(averageRentValue.withCommas()) pcm (\(rentProperty.count))"
        }

        // Sale analysis
        if !saleProperty.isEmpty {
            let averageSaleValue = salePrice/saleProperty.count
            averageSale = "£\(averageSaleValue.withCommas()) (\(saleProperty.count))"
        }
        
        return (averageRent, averageSale)
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
                print("\nPROPERTY: \(propertyItem)\n")
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
    
    public func zooplaProperty(bounds: String, completion: @escaping (_ property: [JSON], _ error: String)->()) {
        // Preparing the request string
        let requestString = "https://api.zoopla.co.uk/api/v1/property_listings.js?\(bounds)&page_size=100&api_key=z2jerfddwxkye3w653muzfjy"
        // The venues request
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let listing = json["listing"].array {
                        completion(listing, "")
                    }
                } catch {
                    print([JSON](), error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Zoopla Propety struct

public struct KMAZooplaProperty {
    public var latitude: Double = 0 // 51.542496
    public var longitude: Double = 0 // -0.000534
    public var image50x38 = "" // image url
    public var image354x255 = "" // image url
    public var image645x430 = "" // image url
    public var image80x60 = "" // image url
    public var image150x113 = "" // image url
    public var image = "" // image url
    public var thumbnail = "" // image url
    public var imageCaption = "" // preview image caption
    public var availableFrom = "" // Available from 17th Dec 2019, Available immediately
    public var listingId = "" // 53472590
    public var description = "" // full description
    public var shortDescription = "" // short description
    public var type = "" // Flat, Maisonette, Terraced house, Semi-detached house, Studio,
    public var address = "" // Granite Apartments, 39 Windmill Lane, London E15
    public var status = "" // rent, sale
    public var category = "" // Residential
    public var numFloors = 0 // 1, 2, 3
    public var numBathrooms = 0 // 1, 2, 3
    public var numBedrooms = 0 // 1, 2, 3
    public var detailsURL = "" // https://www.zoopla.co.uk/to-rent/details/44440070?utm_source=v1:7OaVHSXLChfP5Rizees94WCsIgAk0bKW&utm_medium=api
    public var firstPublishedDate: Double = 0 // timeInterval value since 1970
    public var lastPublishedDate: Double = 0 // timeInterval value since 1970
    public var lettingFees = "" // payment description in html format
    public var floorPlan = [String]() // an array of plan images
    public var salePrice = 0 // Int value in UK pounds
    public var rentWeek = 0 // Int value in UK pounds
    public var rentMonth = 0 // Int value in UK pounds
    public var priceChange = "" // the array of price change details, includes price, percent, date and direction
    /*
     [
     {
     "percent" : "0%",
     "price" : "312",
     "date" : "2014-12-22 19:07:08",
     "direction" : ""
     },
     {
     "percent" : "24%",
     "price" : "387",
     "date" : "2019-12-10 19:25:14",
     "direction" : "up"
     }
     ]
     */
    public var priceChangeSummary = "" // the summary for a price change, includes last updated date, percent and direction
    /*
     {
     "last_updated_date" : "2019-11-27 21:46:11",
     "percent" : "-0.5%",
     "direction" : "down"
     }
     */
    public var billsIncluded = false // true if buills included into price
    public var newHome = false // true if it's a new home
    public var minFloorArea = "" // the minimum floor area details
    /*
     {
     "value" : "699",
     "units" : "sq_feet"
     }
     */
    public var maxFloorArea = "" // the maximum floor area details
    /*
     {
     "units" : "sq_feet",
     "value" : 592.01507291903499
     }
     */
    
    public init() {
    }
    
    public init(latitude: Double, longitude: Double, image50x38: String, image354x255: String, image645x430: String, image80x60: String, image150x113: String, image: String, imageCaption: String, thumbnail: String, availableFrom: String, listingId: String, description: String, shortDescription: String, type: String, address: String, status: String, category: String, numFloors: Int, numBathrooms: Int, numBedrooms: Int, detailsURL: String, firstPublishedDate: Double, lastPublishedDate: Double, lettingFees: String, floorPlan: [String], salePrice: Int, rentWeek: Int, rentMonth: Int, priceChange: String, priceChangeSummary: String, billsIncluded: Bool, newHome: Bool, minFloorArea: String, maxFloorArea: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.image50x38 = image50x38
        self.image354x255 = image354x255
        self.image645x430 = image645x430
        self.image80x60 = image80x60
        self.image150x113 = image150x113
        self.image = image
        self.imageCaption = imageCaption
        self.thumbnail = thumbnail
        self.availableFrom = availableFrom
        self.listingId = listingId
        self.description = description
        self.shortDescription = shortDescription
        self.type = type
        self.address = address
        self.status = status
        self.category = category
        self.numFloors = numFloors
        self.numBathrooms = numBathrooms
        self.numBedrooms = numBedrooms
        self.detailsURL = detailsURL
        self.firstPublishedDate = firstPublishedDate
        self.lastPublishedDate = lastPublishedDate
        self.lettingFees = lettingFees
        self.floorPlan = floorPlan
        self.salePrice = salePrice
        self.rentWeek = rentWeek
        self.rentMonth = rentMonth
        self.priceChange = priceChange
        self.priceChangeSummary = priceChangeSummary
        self.billsIncluded = billsIncluded
        self.newHome = newHome
        self.minFloorArea = minFloorArea
        self.maxFloorArea = maxFloorArea
    }
    
    public func getPropertyDescription() -> (String, String) {
        var propertyDescription = ""
        var priceString = ""
        
        // bedrooms
        if numBedrooms > 0 {
            propertyDescription = "\(numBedrooms) bedroom"
        }
        
        // type
        if !type.isEmpty {
            if propertyDescription.isEmpty {
                propertyDescription = type
            } else {
                propertyDescription += " " + type.lowercased()
            }
        }
        
        // status
        if !status.isEmpty {
            if propertyDescription.isEmpty {
                if status == "rent" {
                    propertyDescription = "To rent"
                    priceString = "£\(rentMonth.withCommas()) pcm"
                } else if status == "sale" {
                    propertyDescription = "For sale"
                    priceString = "£\(salePrice.withCommas())"
                }
            } else {
                if status == "rent" {
                    propertyDescription += " to rent"
                    priceString = "£\(rentMonth.withCommas()) pcm"
                } else if status == "sale" {
                    propertyDescription += " for sale\n£\(salePrice.withCommas())"
                    priceString = "£\(salePrice.withCommas())"
                }
            }
        }
        
        if propertyDescription.isEmpty {
            propertyDescription = "Property"
        }
        
        return (propertyDescription, priceString)
    }
    
    public mutating func fillFrom(propertyItem: JSON) {
        if let propertyItem = propertyItem.dictionary {
            // Location
            
            // Latitude
            if let latitude = propertyItem["latitude"]?.double {
                self.latitude = latitude
            }
            
            // Longitude
            if let longitude = propertyItem["longitude"]?.double {
                self.longitude = longitude
            }
            
            // Image
            
            // Image 50x38
            if let image50x38 = propertyItem["image_50_38_url"]?.string {
                self.image50x38 = image50x38
            }
            
            // Image 354x255
            if let image354x255 = propertyItem["image_354_255_url"]?.string {
                self.image354x255 = image354x255
            }
            
            // Image 645x430
            if let image645x430 = propertyItem["image_645_430_url"]?.string {
                self.image645x430 = image645x430
            }
            
            // Image 80x60
            if let image80x60 = propertyItem["image_80_60_url"]?.string {
                self.image80x60 = image80x60
            }
            
            // Image 80x60
            if let image150x113 = propertyItem["image_150_113_url"]?.string {
                self.image150x113 = image150x113
            }
            
            // Image
            if let image = propertyItem["image_url"]?.string {
                self.image = image
            }
            
            // Thumbnail
            if let thumbnail = propertyItem["thumbnail_url"]?.string {
                self.thumbnail = thumbnail
            }
            
            // Image
            if let imageCaption = propertyItem["image_caption"]?.string {
                self.imageCaption = imageCaption
            }
            
            // Data
            
            // L
            if let availableFrom = propertyItem["available_from_display"]?.string {
                self.availableFrom = availableFrom
            }
            
            if let listingId = propertyItem["listing_id"]?.string {
                self.listingId = listingId
            }
            
            if let description = propertyItem["description"]?.string {
                self.description = description
            }
            
            if let shortDescription = propertyItem["short_description"]?.string {
                self.shortDescription = shortDescription
            }
            
            if let type = propertyItem["property_type"]?.string {
                self.type = type
            }
            
            if let address = propertyItem["displayable_address"]?.string {
                self.address = address
            }
            
            if let status = propertyItem["listing_status"]?.string {
                self.status = status
            }
            
            if let category = propertyItem["category"]?.string {
                self.category = category
            }
            
            if let numFloors = propertyItem["num_floors"]?.string, let num = Int(numFloors) {
                self.numFloors = num
            }
            
            if let numBathrooms = propertyItem["num_bathrooms"]?.string, let num = Int(numBathrooms) {
                self.numBathrooms = num
            }
            
            if let numBedrooms = propertyItem["num_bedrooms"]?.string, let num = Int(numBedrooms) {
                self.numBedrooms = num
            }
            
            if let detailsURL = propertyItem["details_url"]?.string {
                self.detailsURL = detailsURL
            }
            
            // Date formatted
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh-mm-ss"
            let timeZone = TimeZone(identifier: "Europe/London")
            dateFormatter.timeZone = timeZone
            
            if let firstPublishedDate = propertyItem["first_published_date"]?.string, let date = dateFormatter.date(from: firstPublishedDate) {
                self.firstPublishedDate = date.timeIntervalSince1970
            }
            
            if let lastPublishedDate = propertyItem["last_published_date"]?.string, let date = dateFormatter.date(from: lastPublishedDate) {
                self.lastPublishedDate = date.timeIntervalSince1970
            }
            
            if let lettingFees = propertyItem["letting_fees"]?.string {
                self.lettingFees = lettingFees
            }
            
            if let floorPlan = propertyItem["floor_plan"]?.array {
                self.floorPlan = [String]()
                
                for image in floorPlan {
                    if let image = image.string {
                        self.floorPlan.append(image)
                    }
                }
            }
            
            if self.status == "sale", let price = propertyItem["price"]?.string, let num = Int(price) {
                salePrice = num
            } else if self.status == "rent", let rentalPrices = propertyItem["rental_prices"]?.dictionary {
                if let perMonth = rentalPrices["per_month"]?.int {
                    self.rentMonth = perMonth
                }
                
                if let perWeek = rentalPrices["per_week"]?.int {
                    self.rentWeek = perWeek
                }
            }
            
            if let priceChange = propertyItem["price_change"], let priceChangeString = priceChange.rawString() {
                self.priceChange = priceChangeString
            }
            
            if let priceChangeSummary = propertyItem["price_change_summary"]?.rawString() {
                self.priceChangeSummary = priceChangeSummary
            }
            
            if let billsIncluded = propertyItem["bills_included"]?.int, billsIncluded > 0 {
                self.billsIncluded = true
            }
            
            if let newHome = propertyItem["new_home"]?.string, newHome == "true" {
                self.newHome = true
            }
            
            if let floorArea = propertyItem["floor_area"]?.dictionary {
                if let minFloorArea = floorArea["min_floor_area"]?.rawString() {
                    self.minFloorArea = minFloorArea
                }
                
                if let maxFloorArea = floorArea["max_floor_area"]?.rawString() {
                    self.maxFloorArea = maxFloorArea
                }
            }
        }
    }
}
