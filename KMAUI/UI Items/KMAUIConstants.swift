//
//  KMAUIConstants.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 28.11.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

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

    // MARK: - Constants
    public let KMACornerRadius: CGFloat = 6
    public let KMAScreenWidth = UIScreen.main.bounds.size.width
    public let KMSScreenHeight = UIScreen.main.bounds.size.height
    
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
    public var salePrice = 0
    public var rentWeek = 0
    public var rentMonth = 0
    public var priceChange = ""
    public var priceChangeSummary = ""
    public var billsIncluded = 0
    public var newHome = false
    public var minFloorArea = ""
    public var maxFloorArea = ""
    
    public init() {
    }
    
    public init(latitude: Double, longitude: Double, image50x38: String, image354x255: String, image645x430: String, image80x60: String, image150x113: String, image: String, imageCaption: String, thumbnail: String, availableFrom: String, listingId: String, description: String, shortDescription: String, type: String, address: String, status: String, category: String, numFloors: Int, numBathrooms: Int, numBedrooms: Int, detailsURL: String, firstPublishedDate: Double, lastPublishedDate: Double, lettingFees: String, floorPlan: [String], salePrice: Int, rentWeek: Int, rentMonth: Int, priceChange: String, priceChangeSummary: String, billsIncluded: Int, newHome: Bool, minFloorArea: String, maxFloorArea: String) {
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
}
