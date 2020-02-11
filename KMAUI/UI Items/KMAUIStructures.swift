//
//  KMAUIStructures.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 22.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse
import SwiftyJSON

// MARK: - Upload struct

public struct KMAUIUploadItem {
    public var citizenName = ""
    public var citizenImage = ""
    public var uploadName = ""
    public var uploadImage = ""
    public var uploadDate = Date()
    public var isNew = false
    public var isVideo = false
    
    public init() {
    }
    
    public init(citizenName: String, citizenImage: String, uploadName: String, uploadImage: String, uploadDate: Date, isNew: Bool, isVideo: Bool) {
        self.citizenName = citizenName
        self.citizenImage = citizenImage
        self.uploadName = uploadName
        self.uploadImage = uploadImage
        self.uploadDate = uploadDate
        self.isNew = isNew
        self.isVideo = isVideo
    }
}

// MARK: - Document struct

public struct KMADocumentData {
    // Create data
    public var type = ""
    public var name = ""
    public var url: URL?
    public var image = UIImage()
    // Get from Parse data
    public var previewURL = ""
    public var fileURL = ""
    
    public init() {
    }
    
    public mutating func fillFrom(dictionary: [String: String]) {
        if let nameValue = dictionary["name"] {
            self.name = nameValue
        }
        
        if let typeValue = dictionary["type"] {
            self.type = typeValue
        }
        
        if let previewURLValue = dictionary["previewURL"] {
            self.previewURL = previewURLValue
        }
        
        if let fileURLValue = dictionary["fileURL"] {
            self.fileURL = fileURLValue
        }
    }
}

// MARK: - Region performance struct, stores the performance percent and region name

public struct KMAPerformanceStruct {
    public var itemTitle = ""
    public var itemName = ""
    public var performanceArray = [Int]()
    public var rows = [KMAUIRowData]()
    
    public init() {
    }
    
    public init(itemTitle: String, itemName: String, performanceArray: [Int], rows: [KMAUIRowData]) {
        self.itemTitle = itemTitle
        self.itemName = itemName
        self.performanceArray = performanceArray
        self.rows = rows
    }
}

// MARK: - Item performace struct

public struct KMAUIItemPerformance {
    public var performanceArray = [Int]()
    public var itemName = ""
    public var isOn = false
    public var avgCost = 0
    public var location = CLLocationCoordinate2D()
    public var isExpanded = false
    
    public init() {
    }
    
    public init(performanceArray: [Int]? = nil, itemName: String, isOn: Bool, avgCost: Int? = nil, location: CLLocationCoordinate2D? = nil) {
        if let performanceArray = performanceArray {
            self.performanceArray = performanceArray
        }
        
        self.itemName = itemName
        self.isOn = isOn
        
        if let avgCost = avgCost {
            self.avgCost = avgCost
        }
        
        if let location = location {
            self.location = location
        }
    }
    
    public init(item: KMAMapAreaStruct) {
        self.performanceArray = [item.community, item.service, item.security]
        self.itemName = item.nameE
        self.isOn = item.isOn
    }
    
    public mutating func fillFrom(item: KMAMapAreaStruct) {
        self.performanceArray = [item.community, item.service, item.security]
        self.itemName = item.nameE
        self.isOn = item.isOn
    }
}

// MARK: - Data item struct

public struct KMAUIDataItem {
    public var itemName = ""
    public var itemHandle = ""
    public var lastUpdate = Date()
    public var rows = [KMAUIRowData]()
    
    public init() {
    }
    
    public init(itemName: String, itemHandle: String? = nil, lastUpdate: Date? = nil, rows: [KMAUIRowData]) {
        self.itemName = itemName
        
        if let itemHandle = itemHandle {
            self.itemHandle = itemHandle
        }
        
        if let lastUpdate = lastUpdate {
            self.lastUpdate = lastUpdate
        }
        
        self.rows = rows
    }
}

// MARK: - Row data struct

public struct KMAUIRowData {
    public var rowName = ""
    public var rowValue = ""
    public var visibility = false
    public var progress: Double = 0
    
    public init() {
    }
    
    public init(rowName: String, rowValue: String, visibility: Bool? = nil, progress: Double? = nil) {
        self.rowName = rowName
        self.rowValue = rowValue
        
        if let visibility = visibility {
            self.visibility = visibility
        }
        
        if let progress = progress {
            self.progress = progress
        }
    }
}

// MARK: - Income struct

public struct KMAUIIncomeData {
    public var itemName = ""
    public var femaleSalary = 0
    public var maleSalary = 0
    
    public init() {
    }
    
    public init(itemName: String, femaleSalary: Int, maleSalary: Int) {
        self.itemName = itemName
        self.femaleSalary = femaleSalary
        self.maleSalary = maleSalary
    }
}

// MARK: - TextFieldCellData

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

// MARK: - Weather struct

public struct KMAWeather {
    public var title = ""
    public var text = ""
    public var image = ""
    
    public init() {
    }
    
    public mutating func fillFrom(jsonString: String) {
        if let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).array,
            !json.isEmpty, let jsonDict = json[0].dictionary {
            
            // Weather text + temperature
            if let weatherText = jsonDict["WeatherText"]?.string {
                self.title = weatherText
                
                if let temperature = jsonDict["Temperature"]?.dictionary,
                    let metrictDegrees = temperature["Metric"]?.dictionary,
                    let value = metrictDegrees["Value"]?.double {
                    self.title = weatherText + ", \((Double(Int(value * 10)) / 10))°C"
                }
            }
            
            // Real feel + wind
            if let realFeelTemperature = jsonDict["RealFeelTemperature"]?.dictionary,
                let metrictDegrees = realFeelTemperature["Metric"]?.dictionary,
                let value = metrictDegrees["Value"]?.double {
                var windSpeed = ""
                
                if let wind = jsonDict["Wind"]?.dictionary,
                    let speed = wind["Speed"]?.dictionary,
                    let metrictDegrees = speed["Metric"]?.dictionary,
                    let value = metrictDegrees["Value"]?.double {
                    windSpeed = ", Wind: \(value) km/h"
                }
                
                self.text = "RealFeel® \((Double(Int(value * 10)) / 10))°C" + windSpeed
            }
            
            if let weatherIcon = jsonDict["WeatherIcon"]?.int {
                var weatherIconString = "https://developer.accuweather.com/sites/default/files/\(weatherIcon)-s.png"
                
                if weatherIcon < 10 {
                    weatherIconString = "https://developer.accuweather.com/sites/default/files/0\(weatherIcon)-s.png"
                }
                
                self.image = weatherIconString
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
    public var categoryIds = [String]() // the String array of the categoryId objects
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
    public var json = ""
    
    public init() {
    }
    
    public mutating func fillFrom(venue: JSON) {
        if let venue = venue.dictionary {
            if let venueData = venue["venue"]?.dictionary {
                setupData(venueData: venueData)
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
    
    /**
     Setup data
     */
    
    public mutating func setupData(venueData: [String: JSON]) {
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
            
            self.categoryIds = [String]()
            
            if let jsonString = venueData["categories"]?.rawString() {
                self.categories = jsonString
                self.categoryIds = getCategoryIds()
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
    
    public mutating func fillFrom(jsonString: String) {
        if !jsonString.isEmpty, let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            self.json = jsonString
            
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
                categoryIds = [String]()
                
                if let categories = venueObject["categories"]?.rawString() {
                    self.categories = categories
                    self.categoryIds = getCategoryIds()
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
        var details = category
        
        if distance < 1000 {
            details = "\(category), \(distance)m"
        }
        
        if !price.isEmpty,
            let dataFromString = price.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary, let tier = json["tier"]?.int, tier > 0, let currency = json["currency"]?.string {
            var value = ""
            
            for _ in 0..<tier {
                value += currency
            }
            
            details = "\(category), \(value)"
            
            if distance < 1000 {
                details = "\(category), \(distance)m, \(value)"
            }
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
            yesArray = [String]()
            noArray = [String]()
            
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
    
    public func getWorkingHours() -> String {
        var workingHours = ""
        
        if !hours.isEmpty,
            let dataFromString = hours.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            
            if let timeframes = json["timeframes"]?.array {
                for timeframe in timeframes {
                    if let timeframe = timeframe.dictionary {
                        if let days = timeframe["days"]?.string, let open = timeframe["open"]?.array {
                            var schedule = ""
                            
                            for openObject in open {
                                if let openObject = openObject.dictionary, let renderedTime = openObject["renderedTime"]?.string {
                                    if schedule.isEmpty {
                                        schedule = renderedTime
                                    } else {
                                        schedule += ", " + renderedTime
                                    }
                                }
                            }
                            
                            let dayString = days + ": " + schedule
                            
                            if workingHours.isEmpty {
                                workingHours = dayString
                            } else {
                                workingHours += "\n" + dayString
                            }
                        }
                    }
                }
            }
        }
        
        return workingHours
    }
    
    public func getTip() -> (String, String, String, String,String) {
        var tipImageString = ""
        var createdAtString = ""
        var authorString = ""
        var authorImageString = ""
        var tipString = ""
        
        if !tips.isEmpty,
            let dataFromString = tips.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            
            if let groups = json["groups"]?.array {
                for group in groups {
                    if let group = group.dictionary, let items = group["items"]?.array {
                        for item in items {
                            if let item = item.dictionary {
                                // photo url
                                if let photourl = item["photourl"]?.string, let _ = URL(string: photourl) {
                                    tipImageString = photourl
                                }
                                // created at
                                if let createdAt = item["createdAt"]?.int {
                                    createdAtString =  KMAUIUtilities.shared.formatStringShort(date: Date(timeIntervalSince1970: Double(createdAt)))
                                }
                                // user
                                if let user = item["user"]?.dictionary {
                                    // firstName
                                    if let firstName = user["firstName"]?.string {
                                        authorString = firstName
                                        
                                        // lastName
                                        if let lastName = user["lastName"]?.string {
                                            authorString = firstName + " " + lastName
                                        }
                                    }
                                    
                                    //
                                    if let photo = user["photo"]?.dictionary {
                                        if let prefix = photo["prefix"]?.string, let suffix = photo["suffix"]?.string {
                                            if let _ = URL(string: "\(prefix)44\(suffix)") {
                                                authorImageString = "\(prefix)44\(suffix)"
                                            }
                                        }
                                    }
                                }
                                // text
                                if let text = item["text"]?.string {
                                    tipString = text
                                }
                            }
                        }
                    }
                }
            }
        }
        
        return (tipImageString, createdAtString, authorString, authorImageString, tipString)
    }
    
    public func getContacts() -> (String, String, String, String, String, String, String) {
        // facebook
        var fbName = ""
        var fbUsername = ""
        var fbId = ""
        // instagram
        var instagram = ""
        // twitter
        var twitter = ""
        // phone
        var phone = ""
        var formattedPhone = ""
        
        if !contact.isEmpty,
            let dataFromString = contact.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            //            print("\nContacts:")
            
            if let fbNameValue = json["facebookName"]?.string {
                fbName = fbNameValue
            }
            
            if let fbUsernameValue = json["facebookUsername"]?.string {
                fbUsername = fbUsernameValue
            }
            
            if let fbIdValue = json["facebook"]?.string {
                fbId = fbIdValue
            }
            
            if !fbName.isEmpty, !fbUsername.isEmpty, !fbId.isEmpty {
                //                print("Facebook: \(fbName), \(fbUsername), \(fbId)")
            }
            
            if let instagramValue = json["instagram"]?.string {
                instagram = instagramValue
            }
            
            if !instagram.isEmpty {
                //                print("Instagram: \(instagram)")
            }
            
            if let twitterValue = json["twitter"]?.string {
                twitter = twitterValue
            }
            
            if !twitter.isEmpty {
                //                print("Twitter: \(twitter)")
            }
            
            if let phoneValue = json["phone"]?.string {
                phone = phoneValue
            }
            
            if let formattedPhoneValue = json["formattedPhone"]?.string {
                formattedPhone = formattedPhoneValue
            }
            
            if !phone.isEmpty || !formattedPhone.isEmpty {
                //                print("Phone: \(phone), \(formattedPhone)")
            }
        }
        
        return (fbName, fbUsername, fbId, instagram, twitter, phone, formattedPhone)
    }
    
    public func getCategoryIds() -> [String] {
        // categories
        var categoryIdsArray = [String]()
        
        if !categories.isEmpty,
            let dataFromString = categories.data(using: .utf8, allowLossyConversion: false),
            let jsonData = try? JSON(data: dataFromString).array {
            // Loop throught the categories to save the list of unique ids
            for category in jsonData {
                if let category = category.dictionary, let categoryId = category["id"]?.string, !categoryIdsArray.contains(categoryId) {
                    categoryIdsArray.append(categoryId)
                }
            }
        }
        
        return categoryIdsArray
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
    public var numReceptions = 0 // 1, 2, 3
    public var detailsURL = "" // https://www.zoopla.co.uk/to-rent/details/44440070?utm_source=v1:7OaVHSXLChfP5Rizees94WCsIgAk0bKW&utm_medium=api
    public var firstPublishedDate: Double = 0 // timeInterval value since 1970
    public var lastPublishedDate: Double = 0 // timeInterval value since 1970
    public var lettingFees = "" // payment description in html format
    public var floorPlan = [String]() // an array of plan images
    public var salePrice = 0 // Int value in UK pounds
    public var rentWeek = 0 // Int value in UK pounds
    public var rentMonth = 0 // Int value in UK pounds
    public var priceChange = "" // the array of price change details, includes price, percent, date and direction
    public var json = ""
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
    
    /**
     fllor area, avaialableFrom,  floorPlan
     */
    
    public func getPropertyDescription() -> (String, String) {
        var propertyDescription = ""
        var priceString = ""
        
        // bedrooms
        if numBedrooms > 0 {
            propertyDescription = "\(numBedrooms) bed"
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
                    propertyDescription += " for sale"
                    priceString = "£\(salePrice.withCommas())"
                }
            }
        }
        
        if propertyDescription.isEmpty {
            propertyDescription = "Property"
        }
        
        return (propertyDescription, priceString)
    }
    
    public mutating func fillFrom(jsonString: String) {
        if !jsonString.isEmpty, let dataFromString = jsonString.data(using: .utf8, allowLossyConversion: false), let json = try? JSON(data: dataFromString) {
            // Fill the data
            fillFrom(propertyItem: json)
        }
    }
    
    public mutating func fillFrom(propertyItem: JSON) {
        // Save the JSON
        if let jsonString = propertyItem.rawString() {
            self.json = jsonString
        }
        
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
            
            if let numReceptions = propertyItem["num_recepts"]?.string, let num = Int(numReceptions) {
                self.numReceptions = num
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
    public var name = ""
    public var twitter = ""
    public var facebook = ""
    public var website = ""
    public var telephone = ""
    public var email = ""
    public var hasContacts = false
    // JSON Strings
    public var identifiers = "" // stores the forceId and forceTeamId
    public var boundary = "" // stores the boundary data
    public var crime = "" // stores the full Crime information loaded
    public var team = "" // store the full Team information loaded
    public var details = "" // store the full Details information loaded
    
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
    
    public mutating func fillBoundary() {
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
    
    public mutating func fillCrime() {
        self.crimeArray = [KMACrimeObject]()
        self.crimeNearby = [KMACrimeObject]()
        let polygon = KMAUIUtilities.shared.getPolygon(bounds: self.bounds)
        
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
     Fill details
     */
    
    public mutating func fillDetails() {
        // Get the JSON dictionary from the string
        if !details.isEmpty, let dataFromString = details.data(using: .utf8, allowLossyConversion: false), let json = try? JSON(data: dataFromString).dictionary {
            // name
            if let name = json["name"]?.string {
                self.name = name
            }
            // contact details
            self.hasContacts = false
            // Loading contact data
            if let contactDetails = json["contact_details"]?.dictionary {
                // twitter
                if let twitter = contactDetails["twitter"]?.string {
                    self.twitter = twitter
                }
                // facebook
                if let facebook = contactDetails["facebook"]?.string {
                    self.facebook = facebook
                }
                // website
                if let website = contactDetails["website"]?.string {
                    self.website = website
                }
                // telephone
                if let telephone = contactDetails["telephone"]?.string {
                    self.telephone = telephone
                }
                // email
                if let email = contactDetails["email"]?.string {
                    self.email = email
                }
                
                if !self.twitter.isEmpty || !self.facebook.isEmpty || !self.website.isEmpty || !self.telephone.isEmpty || !self.email.isEmpty {
                    self.hasContacts = true
                }
            }
        }
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

// MARK: - Person

public struct KMAPerson {
    public var objectId = ""
    public var username = ""
    public var fullName = ""
    public var profileImage = ""
    public var birthday: Double = 0
    public var gender = ""
    public var formattedAddress = ""
    public var city = ""
    public var subAdmin = ""
    public var admin = ""
    public var country = ""
    public var uploadsCount = 0
    public var propertyCount = 0
    
    public init() {
    }
    
    public mutating func fillFrom(person: PFUser) {
        if let username = person.username {
            if let objectId = person.objectId {
                self.objectId = objectId
            }
            
            // Username
            self.username = username
            
            // Full name
            var fullName = ""
            
            if let firstName = person["firstName"] as? String {
                fullName = firstName
            }
            
            if let lastName = person["lastName"] as? String {
                if fullName.isEmpty {
                    fullName = lastName
                } else {
                    fullName += " " + lastName
                }
            }
            
            self.fullName = fullName
            
            // Profile image
            if let profileImage = person["profileImage"] as? PFFileObject, let urlString = profileImage.url {
                self.profileImage = urlString
            }
            
            // Birthday
            if let birthday = person["birthday"] as? Date {
                self.birthday = birthday.timeIntervalSince1970
            }
            
            // Gender
            if let gender = person["gender"] as? String, !gender.isEmpty {
                self.gender = gender
            }
            
            // Address
            if let homeAddress = person["homeAddress"] as? PFObject,
                let building = homeAddress["building"] as? PFObject {
                if let formattedAddress = building["formattedAddress"] as? String {
                    self.formattedAddress = formattedAddress
                }
                
                if let city = building["city"] as? String {
                    self.city = city
                }
                
                if let subAdmin = building["subAdminArea"] as? String {
                    self.subAdmin = subAdmin
                }
                
                if let admin = building["adminArea"] as? String {
                    self.admin = admin
                }
                
                if let country = building["country"] as? String {
                    self.country = country
                }
            }
            
            // Uploads count
            if let uploadsCount = person["uploadsCount"] as? Int {
                self.uploadsCount = uploadsCount
            }
            
            // Property count
            if let propertyCount = person["propertyCount"] as? Int {
                self.propertyCount = propertyCount
            }
        }
    }
}

// MARK: - Property document

public struct KMAPropertyDocument {
    public var objectId = ""
    public var createdAt = Date()
    public var updatedAt = Date()
    public var name = ""
    public var descriptionText = ""
    public var issueDate = Date()
    public var files = ""
    
    public init() {
    }
    
    public mutating func fillFrom(documentLoaded: PFObject) {
        if let objectIdValue = documentLoaded.objectId, let updatedAtValue = documentLoaded.updatedAt {
            self.objectId = objectIdValue
            self.updatedAt = updatedAtValue
            
            if let createdAtValue = documentLoaded.createdAt {
                self.createdAt = createdAtValue
            }
            
            if let nameLoaded = documentLoaded["name"] as? String {
                self.name = nameLoaded
            }
            
            if let descriptionLoaded = documentLoaded["description"] as? String {
                self.descriptionText = descriptionLoaded
            }
            
            if let issueDateLoaded = documentLoaded["issueDate"] as? Date {
                self.issueDate = issueDateLoaded
            }
            
            if let filesLoaded = documentLoaded["files"] as? String {
                self.files = filesLoaded
            }
        }
    }
}

// MARK: - Citizen Property

public struct KMACitizenProperty {
    var objectId = ""
    var createdAt = Date()
    var updatedAt = Date()
    var type = ""
    var apartment = 0
    var location = CLLocationCoordinate2D()
    var ownershipForm = ""
    var residentsCount = 0
    var documentIds = [String]()
    var residents = [[String: AnyObject]]()
    var formattedAddress = ""
    var city = ""
    var subAdminArea = ""
    var adminArea = ""
    var country = ""
    var documents = [KMAPropertyDocument]()
    
    public init() {
    }
    
    public mutating func fillFrom(propertyLoaded: PFObject) {
        if let objectIdValue = propertyLoaded.objectId, let updatedAtValue = propertyLoaded.updatedAt {
            self.objectId = objectIdValue
            self.updatedAt = updatedAtValue
            
            if let createdAtValue = propertyLoaded.createdAt {
                self.createdAt = createdAtValue
            }
            
            if let typeLoaded = propertyLoaded["type"] as? String {
                self.type = typeLoaded
            }
            
            if let ownershipFormLoaded = propertyLoaded["ownershipForm"] as? String {
                self.ownershipForm = ownershipFormLoaded
            }
            
            if let location = propertyLoaded["location"] as? PFGeoPoint {
                self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            }
            
            if let residentsCountLoaded = propertyLoaded["residentsCount"] as? Int {
                self.residentsCount = residentsCountLoaded
            }
            
            if let documentIdsLoaded = propertyLoaded["documentIds"] as? [String] {
                self.documentIds = documentIdsLoaded
            }
            
            if let apartmentValue = propertyLoaded["apartment"] as? Int {
                apartment = apartmentValue
            }
            
            if let residentsValue = propertyLoaded["residents"] as? [[String: AnyObject]] {
                self.residents = residentsValue
            }
            
            if let buildingLoaded = propertyLoaded["building"] as? PFObject {
                if let formattedAddressValue = buildingLoaded["formattedAddress"] as? String {
                    formattedAddress = formattedAddressValue
                }
                
                if let cityValue = buildingLoaded["city"] as? String {
                    city = cityValue
                }
                
                if let subAdminAreaValue = buildingLoaded["subAdminArea"] as? String {
                    subAdminArea = subAdminAreaValue
                }
                
                if let adminAreaValue = buildingLoaded["adminArea"] as? String {
                    adminArea = adminAreaValue
                }
                
                if let countryValue = buildingLoaded["country"] as? String {
                    country = countryValue
                }
            }
            
            if let documentPointers = propertyLoaded["documentPointers"] as? [PFObject] {
                for documentObject in documentPointers {
                    var documentValue = KMAPropertyDocument()
                    documentValue.fillFrom(documentLoaded: documentObject)
                    documents.append(documentValue)
                }
            }
        }
    }
}

// MARK: - Citizen Upload

public struct KMACitizenUpload {
    public var objectId = ""
    public var createdAt = Date()
    public var updatedAt = Date()
    public var location = CLLocationCoordinate2D()
    public var uploadDescription = ""
    public var uploadBody = ""
    public var processingStatus = ""
    //    public var city = ""
    //    public var state = ""
    //    public var country = ""
    //    public var zip = ""
    public var departmentId = ""
    public var departmentHandle = ""
    public var departmentName = ""
    public var departmentAbout = ""
    public var departmentLogo = ""
    public var categoryId = ""
    public var categoryName = ""
    public var categoryLogo = ""
    
    public init() {
    }
    
    public mutating func fillFromParse(uploadLoaded: PFObject) {
        if let objectIdValue = uploadLoaded.objectId, let updatedAtValue = uploadLoaded.updatedAt {
            self.objectId = objectIdValue
            self.updatedAt = updatedAtValue
            
            if let createdAtValue = uploadLoaded.createdAt {
                self.createdAt = createdAtValue
            }
            
            if let uploadLocationLoaded = uploadLoaded["location"] as? PFGeoPoint {
                self.location = CLLocationCoordinate2D(latitude: uploadLocationLoaded.latitude, longitude: uploadLocationLoaded.longitude)
            }
            
            if let uploadDescriptionLoaded = uploadLoaded["uploadDescription"] as? String {
                self.uploadDescription = uploadDescriptionLoaded
            }
            
            if let uploadBodyLoaded = uploadLoaded["uploadBody"] as? String {
                self.uploadBody = uploadBodyLoaded
            }
            
            if let processingStatusLoaded = uploadLoaded["processingStatus"] as? String {
                self.processingStatus = processingStatusLoaded
            }
            
            // Update department if available
            if let departmentLoaded = uploadLoaded["departmentAssigned"] as? PFObject {
                if let objectIdValue = departmentLoaded.objectId {
                    self.departmentId = objectIdValue
                    
                    if let handleValue = departmentLoaded["departmentHandle"] as? String {
                        self.departmentHandle = handleValue
                    }
                    
                    if let nameValue = departmentLoaded["departmentName"] as? String {
                        self.departmentName = nameValue
                    }
                    
                    if let aboutValue = departmentLoaded["departmentDescription"] as? String {
                        self.departmentAbout = aboutValue
                    }
                    
                    if let profileImageFile = departmentLoaded["departmentProfileImage"] as? PFFileObject, let profileImageURL = profileImageFile.url {
                        self.departmentLogo = profileImageURL
                    }
                }
            }
            
            /*if let cityValue = uploadLoaded["city"] as? String {
             self.city = cityValue
             }
             
             if let stateValue = uploadLoaded["state"] as? String {
             self.state = stateValue
             }
             
             if let countryValue = uploadLoaded["country"] as? String {
             self.country = countryValue
             }
             
             if let zipValue = uploadLoaded["zip"] as? String {
             self.zip = zipValue
             }*/
            
            if let uploadCategoryLoaded = uploadLoaded["category"] as? PFObject {
                if let objectIdValue = uploadCategoryLoaded.objectId {
                    self.categoryId = objectIdValue
                    
                    if let nameEValue = uploadCategoryLoaded["nameE"] as? String {
                        self.categoryName = nameEValue
                    }
                    
                    if let logoFile = uploadCategoryLoaded["logo"] as? PFFileObject, let urlString = logoFile.url {
                        self.categoryLogo = urlString
                    }
                }
            }
        }
    }
}

public struct KMAMapAreaStruct {
    public var objectId = ""
    public var createdAt = Date()
    public var updatedAt = Date()
    public var nameE = ""
    public var nameA = ""
    public var level = -1
    public var type = ""
    public var performance = -1
    public var community = -1
    public var service = -1
    public var security = -1
    public var location = CLLocationCoordinate2D()
    public var sw = CLLocationCoordinate2D()
    public var ne = CLLocationCoordinate2D()
    public var geojson = ""
    public var isActive = false
    public var isOn = false
    public var childrenCount = 0
    public var nextType = ""
    public var population = 0
    public var cityId = ""

    public init() {}
    
    public mutating func fillFrom(object: PFObject) {
        if let objectId = object.objectId {
            self.objectId = objectId
        }
        
        if let createdAt = object.createdAt {
            self.createdAt = createdAt
        }
        
        if let updatedAt = object.updatedAt {
            self.updatedAt = updatedAt
        }
        
        if let nameE = object["nameE"] as? String {
            self.nameE = nameE
        }
        
        if let nameA = object["nameA"] as? String {
            self.nameA = nameA
        }
        
        if let level = object["level"] as? Int {
            self.level = level
        }
        
        if let type = object["type"] as? String {
            self.type = type
        }
        
        if let performance = object["performance"] as? Int {
            self.performance = performance
        }
        
        if let community = object["community"] as? Int {
            self.community = community
        }
        
        if let service = object["service"] as? Int {
            self.service = service
        }
        
        if let security = object["security"] as? Int {
            self.security = security
        }
        
        if let location = object["location"] as? PFGeoPoint {
            self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        
        if let minX = object["minX"] as? Double, let minY = object["minY"] as? Double {
            self.sw = CLLocationCoordinate2D(latitude: minY, longitude: minX)
        }
        
        if let maxX = object["maxX"] as? Double, let maxY = object["maxY"] as? Double {
            self.ne = CLLocationCoordinate2D(latitude: maxY, longitude: maxX)
        }
        
        if let geojson = object["geojson"] as? String {
            self.geojson = geojson
        }
        
        if let isActive = object["isActive"] as? Bool {
            self.isActive = isActive
        }
        
        if let childrenCount = object["childrenCount"] as? Int {
            self.childrenCount = childrenCount
        }
        
        if let nextType = object["nextType"] as? String {
            self.nextType = nextType
        }
        
        if let population = object["population"] as? Int {
            self.population = population
        }
        
        if let cityId = object["cityId"] as? String {
            self.cityId = cityId
        }
    }
}
