//
//  KMAUIConstants.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 28.11.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import SwiftyJSON

public class KMAUIConstants {
    // Access variable
    public static let shared = KMAUIConstants()
    
    // MARK: - Colors
    public let KMATextGrayColor = UIColor(named: "KMATextGrayColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMABgGray = UIColor(named: "KMABgGray", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMABackColor = UIColor(named: "KMABackColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMATurquoiseColor = UIColor(named: "KMATurquoiseColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMATitleColor = UIColor(named: "KMATitleColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMATextColor = UIColor(named: "KMATextColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMABlueColor = UIColor(named: "KMABlueColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAGreenColor = UIColor(named: "KMAGreenColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMARoseColor = UIColor(named: "KMARoseColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMARedColor = UIColor(named: "KMARedColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMALightPurpleColor = UIColor(named: "KMALightPurpleColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAPurpleColor = UIColor(named: "KMAPurpleColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMALineGray = UIColor(named: "KMALineGray", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMABrightBlueColor = UIColor(named: "KMABrightBlueColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    
    // MARK: - Images
    public let checkboxFilledIcon = UIImage(named: "checkboxFilledIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let checkboxIcon = UIImage(named: "checkboxIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let filterIcon = UIImage(named: "filterIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let filterFilledIcon = UIImage(named: "filterFilledIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let dashboardTabIcon = UIImage(named: "dashboardTabIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let mapTabIcon = UIImage(named: "mapTabIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let profileTabIcon = UIImage(named: "profileTabIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let requestsTabIcon = UIImage(named: "requestsTabIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let searchIcon = UIImage(named: "searchIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let settingsIcon = UIImage(named: "settingsIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let propertyIcon = UIImage(named: "propertyIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    
    // MARK: - Constants
    public let KMACornerRadius: CGFloat = 6
    public let KMAScreenWidth = UIScreen.main.bounds.size.width
    public let KMSScreenHeight = UIScreen.main.bounds.size.height
    
    public let KMABorderWidthLight: CGFloat = 0.5
    public let KMABorderWidthRegular: CGFloat = 1.0
    public let KMABorderWidthBold: CGFloat = 2.0
    
    // MARK: - Login variables
    public let usernameAllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-@"
}

// MARK: - Structures

public struct KMAUITextFieldCellData {
    public var type = "textField"
    public var placeholderText = ""
    public var value = ""
    
    // Fill the data from the dictionary
    public mutating func setupStruct(cellObject: [String: AnyObject]) {
        if let placeholderTextValue = cellObject["placeholderText"] as? String {
            placeholderText = placeholderTextValue
        }
        
        // For request
        if let defaultValue = cellObject["defaultValue"] as? String {
            value = defaultValue
        }
        
        // For answer
        if let answerValue = cellObject["answer"] as? String {
            value = answerValue
        }
    }
    
    public init() {
    }
    
    public init(type: String, placeholderText: String, value: String) {
        self.type = type
        self.placeholderText = placeholderText
        self.value = value
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
    
    public init() {
    }
    
    public init(name: String, category: String, categoryPrefix: String, categorySuffix: String, latitude: Double, longitude: Double, address: String, prefix: String, suffix: String, venueId: String) {
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
