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
    public var citizenId = ""
    public var citizenUsername = ""
    public var citizenImage = ""
    public var uploadName = ""
    public var previewImage = ""
    public var uploadImage = ""
    public var uploadDate = Date()
    public var isNew = false
    public var isVideo = false
    public var uploadId = ""
    public var uploadDescription = ""
    public var uploadFiles = [KMAUIUploadItem]()
    public var fileId = ""
    public var location = CLLocationCoordinate2D()
    
    public init() {
    }
    
    public init(citizenName: String, citizenImage: String? = nil, uploadName: String, uploadImage: String? = nil, uploadDate: Date, isNew: Bool, isVideo: Bool, previewImage: String? = nil, citizenId: String? = nil, citizenUsername: String? = nil, uploadId: String? = nil, uploadFiles: [KMAUIUploadItem]? = nil) {
        self.citizenName = citizenName
        
        if let citizenImage = citizenImage {
            self.citizenImage = citizenImage
        }
        self.uploadName = uploadName
        self.uploadDate = uploadDate
        self.isNew = isNew
        self.isVideo = isVideo
        
        // New details
        
        if let uploadImage = uploadImage {
            self.uploadImage = uploadImage
        }
        
        if let previewImage = previewImage {
            self.previewImage = previewImage
        }
        
        if let citizenId = citizenId {
            self.citizenId = citizenId
        }
        
        if let citizenUsername = citizenUsername {
            self.citizenUsername = citizenUsername
        }
        
        if let uploadId = uploadId {
            self.uploadId = uploadId
        }
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
    // New values
    public var objectId = ""
    public var fileExtension = ""
    public var fileDescription = ""
    // Metadata
    public var hasCreatedAt = false
    public var captureDate = Date()
    public var hasLocation = false
    public var location = CLLocationCoordinate2D()
    public var address = ""
    // Document Parse data
    public var createdAt = Date()
    public var updatedAt = Date()
    
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
    
    public mutating func fillFrom(document: [String: String]) {
        if let nameValue = document["name"] {
            self.name = nameValue
        }
        
        if let typeValue = document["type"] {
            self.type = typeValue
        }
        
        if let previewURLValue = document["previewURL"] {
            self.previewURL = previewURLValue
        }
        
        if let fileURLValue = document["fileURL"] {
            self.fileURL = fileURLValue
        }
        
        if let objectId = document["objectId"] {
            self.objectId = objectId
        }
        
        if let fileExtension = document["fileExtension"] {
            self.fileExtension = fileExtension
        }
        
        if let fileDescription = document["fileDescription"] {
            self.fileDescription = fileDescription
        }
        
        // New variables
        
        if let createdAtValue = document["captureDate"] {
            captureDate = KMAUIUtilities.shared.dateFromUTCString(string: createdAtValue)
            hasCreatedAt = true
        }
        
        if let latitude = document["latitude"], let longitude = document["longitude"], let latitudeValue = Double(latitude), let longitudeValue = Double(longitude) {
            hasLocation = true
            location = CLLocationCoordinate2D(latitude: latitudeValue, longitude: longitudeValue)
        }
        
        if let addressValue = document["address"] {
            address = addressValue
        }
        
        if let createdAtValue = document["createdAt"] {
            createdAt = KMAUIUtilities.shared.dateFromUTCString(string: createdAtValue)
        }
        
        if let updatedAtValue = document["updatedAt"] {
            updatedAt = KMAUIUtilities.shared.dateFromUTCString(string: updatedAtValue)
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
    public var count: Int32 = 0
    
    public init() {
    }
    
    public init(rowName: String, rowValue: String? = nil, visibility: Bool? = nil, progress: Double? = nil, count: Int32? = nil) {
        self.rowName = rowName
        
        if let rowValue = rowValue {
            self.rowValue = rowValue
        }
        
        if let visibility = visibility {
            self.visibility = visibility
        }
        
        if let progress = progress {
            self.progress = progress
        }
        
        if let count = count {
            self.count = count
        } else {
            self.count = -1
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
    public var lotteryObjectId = ""
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
    public var receivedSubLand = false
    public var receivedSubLandCount = 0
    
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
            
            // Received Sub Land
            if let receivedSubLand = person["receivedSubLand"] as? Bool {
                self.receivedSubLand = receivedSubLand
            }
            
            // Received Sub Land Count
            if let receivedSubLandCount = person["receivedSubLandCount"] as? Int {
                self.receivedSubLandCount = receivedSubLandCount
            }
        }
    }
}

// MARK: - Property document

public struct KMAPropertyDocument {
    public var objectId = ""
    public var createdAt = Date()
    public var updatedAt = Date()
    public var documentExpiryDate = Date()
    public var name = ""
    public var descriptionText = ""
    public var issueDate = Date()
    public var files = ""
    public var documentType = ""
    
    public init() {
    }
    
    public mutating func fillFrom(documentLoaded: PFObject) {
        if let objectIdValue = documentLoaded.objectId, let updatedAtValue = documentLoaded.updatedAt {
            self.objectId = objectIdValue
            self.updatedAt = updatedAtValue
            
            if let createdAtValue = documentLoaded.createdAt {
                self.createdAt = createdAtValue
            }
            
            // If from KMADocument
            
            if let nameLoaded = documentLoaded["name"] as? String {
                self.name = nameLoaded
                self.documentType = "KMADocument"
            }
            
            if let descriptionLoaded = documentLoaded["description"] as? String {
                self.descriptionText = descriptionLoaded
            }
            
            if let filesLoaded = documentLoaded["files"] as? String {
                self.files = filesLoaded
            }
            
            if let issueDateLoaded = documentLoaded["issueDate"] as? Date {
                self.issueDate = issueDateLoaded
            }
            
            // If from KMAUserUpload
            
            if let nameLoaded = documentLoaded["documentName"] as? String {
                self.name = nameLoaded
                self.documentType = "KMAUserUpload"
            }
            
            if let uploadDescription = documentLoaded["uploadDescription"] as? String {
                self.descriptionText = uploadDescription
            }
            
            if let documentExpiresAt = documentLoaded["documentExpiresAt"] as? Date {
                self.documentExpiryDate = documentExpiresAt
            }
            
            if let files = documentLoaded["uploadBody"] as? String {
                self.files = files
            }
        }
    }
}

// MARK: - Citizen Property

public struct KMACitizenProperty {
    public var objectId = ""
    public var createdAt = Date()
    public var updatedAt = Date()
    public var type = ""
    public var apartment = 0
    public var location = CLLocationCoordinate2D()
    public var ownershipForm = ""
    public var residentsCount = 0
    public var documentIds = [String]()
    public var residents = [[String: AnyObject]]()
    public var formattedAddress = ""
    public var city = ""
    public var subAdminArea = ""
    public var adminArea = ""
    public var country = ""
    public var documents = [KMAPropertyDocument]()
    
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

// MARK: - KMADepartment

public struct KMADepartmentStruct {
    public var departmentId = ""
    public var departmentHandle = ""
    public var departmentName = ""
    public var departmentAbout = ""
    public var departmentLogo = ""
    public var mapArea: KMAMapAreaStruct?
    
    public init() {
    }
    
    public mutating func fillFromParse(departmentObject: PFObject) {
        if let objectIdValue = departmentObject.objectId {
            self.departmentId = objectIdValue
            
            if let handleValue = departmentObject["departmentHandle"] as? String {
                self.departmentHandle = handleValue
            }
            
            if let nameValue = departmentObject["departmentName"] as? String {
                self.departmentName = nameValue
            }
            
            if let aboutValue = departmentObject["departmentDescription"] as? String {
                self.departmentAbout = aboutValue
            }
            
            if let profileImageFile = departmentObject["departmentProfileImage"] as? PFFileObject, let profileImageURL = profileImageFile.url {
                self.departmentLogo = profileImageURL
            }
            
            if let mapArea = departmentObject["mapArea"] as? PFObject {
                var area = KMAMapAreaStruct()
                area.fillFrom(object: mapArea)
                self.mapArea = area
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
    // Land plans
    public var landPlans = [KMAUILandPlanStruct]()
    public var lotteryMembersCount = 0
    // New items
    public var periodStart = Date()
    public var periodEnd = Date()
    // Queue count
    public var joined = false
    public var lotteries = [KMAUILandPlanStruct]()

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
        
        if let lotteryMembersCount = object["lotteryMembersCount"] as? Int {
            self.lotteryMembersCount = lotteryMembersCount
        }
    }
}

public struct KMAUISubLandStruct {
    public var status = ""
    public var landPlanId = ""
    public var landPlanName = ""
    public var objectId = ""
    public var subLandId = "" // that's a real name in the Ministry plan
    public var lotteryResultId = ""
    public var subLandArea = ""
    public var subLandSquare: Double = 0
    public var subLandType = ""
    public var subLandWidth: Double = 0
    public var subLandHeight: Double = 0
    public var subLandIndex = ""
    public var location = CLLocationCoordinate2D()
    public var sw = CLLocationCoordinate2D()
    public var ne = CLLocationCoordinate2D()
    public var subLandPercent: Double = 0
    public var extraPrice: Double = 0
    public var subLandDescription = ""
    public var subLandImages = ""
    public var subLandImagesArray = [KMADocumentData]()
    public var subLandImagesVideosArray = [KMADocumentData]()
    public var subLandDocumentsArray = [KMADocumentData]()
    // Additional variables
    public var geojson = ""
    public var geojsonDict = [String: Any]()
    public var coordinates = [CLLocationCoordinate2D]()
    // Region details
    public var regionId = ""
    public var regionName = ""
    public var rules = [KMAUILotteryRule]()
    // Parse values
    public var createdAt = Date()
    public var updatedAt = Date()
    // Notification id from push
    public var notificationId = ""
    
    public init() {}
    
    mutating public func fillFromParse(item: PFObject, noRegion: Bool? = nil) {
        // landPlanId
        if let landPlan = item["landPlan"] as? PFObject, let landPlanId = landPlan.objectId {
            self.landPlanId = landPlanId
            
            if let landPlanName = landPlan["planName"] as? String {
                self.landPlanName = landPlanName
            }
        }
        // objectId
        if let subLandId = item.objectId {
            self.objectId = subLandId
        }
        // createdAt
        if let createdAt = item.createdAt {
            self.createdAt = createdAt
        }
        // updatedAt
        if let updatedAt = item.updatedAt {
            self.updatedAt = updatedAt
        }
        // subLandId
        if let subLandId = item["subLandId"] as? String {
            self.subLandId = subLandId
        }
        // subLandArea
        if let subLandArea = item["subLandArea"] as? String {
            self.subLandArea = subLandArea
        }
        // subLandSquare
        if let subLandSquare = item["subLandSquare"] as? Double {
            self.subLandSquare = subLandSquare.formatNumbersAfterDot()
        }
        // subLandType
        if let subLandType = item["subLandType"] as? String {
            self.subLandType = subLandType
        }
        // subLandWidth
        if let subLandWidth = item["subLandWidth"] as? Double {
            self.subLandWidth = subLandWidth.formatNumbersAfterDot()
        }
        // subLandHeight
        if let subLandHeight = item["subLandHeight"] as? Double {
            self.subLandHeight = subLandHeight.formatNumbersAfterDot()
        }
        // subLandIndex
        if let subLandIndex = item["subLandIndex"] as? String {
            self.subLandIndex = subLandIndex
            
            if self.subLandId.isEmpty {
                self.subLandId = subLandIndex
            }
        }
        // location
        if let location = item["location"] as? PFGeoPoint {
            self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        // sw
        if let minX = item["minX"] as? Double, let minY = item["minY"] as? Double {
            self.sw = CLLocationCoordinate2D(latitude: minY, longitude: minX)
        }
        // ne
        if let maxX = item["maxX"] as? Double, let maxY = item["maxY"] as? Double {
            self.ne = CLLocationCoordinate2D(latitude: maxY, longitude: maxX)
        }
        // subLandPercent
        if let subLandPercent = item["subLandPercent"] as? Double {
            self.subLandPercent = subLandPercent.formatNumbersAfterDot()
        }
        // extraPrice
        if let extraPrice = item["extraPrice"] as? Double {
            self.extraPrice = extraPrice.formatNumbersAfterDot()
        }
        // subLandDescription
        if let subLandDescription = item["subLandDescription"] as? String {
            self.subLandDescription = subLandDescription
        }
        // subLandImages
        if let subLandImages = item["subLandImages"] as? String {
            self.subLandImages = subLandImages
        }
        // region id, region name
        if let noRegion = noRegion, noRegion {
            // No need to load the region for Sub Lands
        } else if let landPlan = item["landPlan"] as? PFObject, let region = landPlan["region"] as? PFObject, let regionId = region.objectId, let regionName = region["nameE"] as? String {
            self.regionId = regionId
            self.regionName = regionName
        }
    }
    
    mutating public func fillFromDict(item: [String : Any]) {
        if let itemProperties = item["properties"] as? [String: AnyObject], let itemType = itemProperties["type"] as? String, itemType == "Sub Land", let subLandType = itemProperties["subLandType"] as? String {
            // coordinates
            if let geometry = item["geometry"] as? [String: Any], let coordinates = geometry["coordinates"] as? [[Double]], coordinates.count >= 5 {
                let topLeftCoordinate = coordinates[0]
                let topRightCoordinate = coordinates[1]
                let bottomRightCoordinate = coordinates[2]
                let bottomLeftCoordinate = coordinates[3]
                
                let topLeft = CLLocationCoordinate2D(latitude: topLeftCoordinate[0], longitude: topLeftCoordinate[1])
                let topRight = CLLocationCoordinate2D(latitude: topRightCoordinate[0], longitude: topRightCoordinate[1])
                let bottomRight = CLLocationCoordinate2D(latitude: bottomRightCoordinate[0], longitude: bottomRightCoordinate[1])
                let bottomLeft = CLLocationCoordinate2D(latitude: bottomLeftCoordinate[0], longitude: bottomLeftCoordinate[1])

                // subLandType
                self.subLandType = subLandType
                
                // geojson
                self.geojsonDict = item
                
                // land name
                if let objectId = itemProperties["objectId"] as? String {
                    self.objectId = objectId
                }
                
                // center coordinate
                if let latitude = itemProperties["latitude"] as? Double, let longitude = itemProperties["longitude"] as? Double {
                    self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                }
                
                // subLandPercent
                if let subLandPercent = itemProperties["subLandPercent"] as? Double {
                    self.subLandPercent = subLandPercent.formatNumbersAfterDot()
                }
                
                // subLandSquare
                if let subLandSquare = itemProperties["subLandSquare"] as? Double {
                    self.subLandSquare = subLandSquare.formatNumbersAfterDot()
                }
                
                // coordinates array
                self.coordinates = [topLeft, topRight, bottomRight, bottomLeft]
                
                // sw
                if let minX = itemProperties["minX"] as? Double, let minY = itemProperties["minY"] as? Double {
                    self.sw = CLLocationCoordinate2D(latitude: minY, longitude: minX)
                }
                
                // ne
                if let maxX = itemProperties["maxX"] as? Double, let maxY = itemProperties["maxY"] as? Double {
                    self.ne = CLLocationCoordinate2D(latitude: maxY, longitude: maxX)
                }
                
                // areaWidth
                if let subLandWidth = itemProperties["subLandWidth"] as? Double {
                    self.subLandWidth = subLandWidth.formatNumbersAfterDot()
                }
                
                // areaHeight
                if let subLandHeight = itemProperties["subLandHeight"] as? Double {
                    self.subLandHeight = subLandHeight.formatNumbersAfterDot()
                }
                
                // subLandIndex
                if let subLandIndex = itemProperties["name"] as? String {
                    self.subLandIndex = subLandIndex
                    self.subLandId = subLandIndex
                }
                
                // extraPrice
                if let extraPrice = itemProperties["extraPrice"] as? Double {
                    self.extraPrice = extraPrice.formatNumbersAfterDot()
                }
            }
        }
    }
    
    mutating public func fillFromPush(details: [String : AnyObject]) {
        // Sub land id
        if let subLandId = details["subLandId"] as? String {
            self.subLandId = subLandId
        }
        
        // region
        if let region = details["region"] as? String {
            self.regionName = region
        }
        
        // region id
        if let regionId = details["regionId"] as? String {
            self.regionId = regionId
        }
        
        // land plan name
        if let landPlanName = details["landPlanName"] as? String {
            self.landPlanName = landPlanName
        }
        
        // land plan id
        if let landPlanId = details["landPlanId"] as? String {
            self.landPlanId = landPlanId
        }
        
        // object id
        if let objectId = details["objectId"] as? String {
            self.objectId = objectId
        }
        
        // notification id
        if let notificationId = details["notificationId"] as? String {
            self.notificationId = notificationId
        }
    }
    
    mutating public func prepareRules(fullDetails: Bool? = nil) {
        // Setup the rows
        rules = [KMAUILotteryRule]()
        
        if !status.isEmpty {
            rules.append(KMAUILotteryRule(name: "Status", value: status.capitalized))
        }
        
        if extraPrice > 0 {
            rules.append(KMAUILotteryRule(name: "Extra price", value: "$ \(extraPrice.formatNumbersAfterDot().withCommas())"))
            /*
            // Setup the paid status
            if status == "confirmed" {
                rules.append(KMAUILotteryRule(name: "Payment", value: "Completed"))
            } else if status == "awaiting payment" {
                rules.append(KMAUILotteryRule(name: "Payment", value: "Pending"))
            }*/
        }
        
        if subLandSquare > 0 {
            rules.append(KMAUILotteryRule(name: "Square", value: "\(subLandSquare.formatNumbersAfterDot()) m²"))
        }
        
        // if fullDetails - show width and height, we don't need it for the Citizen screen preview
        if let fullDetails = fullDetails, fullDetails {
            if subLandWidth > 0 {
                rules.append(KMAUILotteryRule(name: "Width", value: "\(subLandWidth.formatNumbersAfterDot()) m"))
            }
            
            if subLandHeight > 0 {
                rules.append(KMAUILotteryRule(name: "Height", value: "\(subLandHeight.formatNumbersAfterDot()) m"))
            }
        }
        
        if subLandPercent > 0 {
            rules.append(KMAUILotteryRule(name: "Land percent", value: "\(Int(subLandPercent * 100)) %"))
        }
    }
}

// Lottery status
public enum LotteryStatus: String {
    case unknowed = ""
    case created = "Created"
    case onApprovement = "On approvement"
    case finished = "Finished"
    case approvedToStart = "Approved to start"
    case rejected = "Rejected"
}  

public struct KMAUILandPlanStruct {
      
    // Land name
    public var landName = "Land Lottery"
    // Land center coordinate
    public var centerCoordinate = CLLocationCoordinate2D()
    // Area size in meters
    public var areaWidth: Double = 1500 // 1.5 km
    public var areaHeight: Double = 1000 // 1.0 km
    public var sw = CLLocationCoordinate2D()
    public var ne = CLLocationCoordinate2D()
    // Area rotation parameters in degrees
    public var degrees: Double = 0 // 0 degress rotation to the right side
    // Sub Land sizes in meters
    public var minSubLandSide: Double = 25 // 24.5 m
    public var maxSubLandSide: Double = 30 // 30 m
    public var averageSubLandSize: Double = 0
    // Road width in meters
    public var mainRoadWidth: Double = 20
    public var regularRoadWidth: Double = 6
    // Grid parameters for a block, each block has rowsPerBlock lines with Sub Lands inside
    public var itemsInSubBlockHorizontal: Int = 5
    public var itemsInSubBlockVertical: Int = 2
    public var rowsPerBlock: Int = 4
    // Objects and results
    public var landFeatures = [[String: Any]]()
    public var separateFeatures = [[String: Any]]()
    // services, commercial, and residential
    public var servicesPercent = 15
    public var commercialPercent = 20
    public var salePercent = 25
    public var lotteryPercent = 40
    public var servicesCount = 0
    public var commercialCount = 0
    public var lotteryCount = 0
    public var saleCount = 0
    // Square meter price
    public var squareMeterPrice: Double = 1500
    // Result items
    public var geojson = ""
    public var subLandItems = [PFObject]()
    // Plan dates
    public var startDate = Date()
    public var endDate = Date()
    public var regionId = "" // the object id of a region object from KMAMapArea
    public var region = KMAMapAreaStruct()
    public var subLandsCount = 0
    public var lotterySubLandsCount = 0
    // Department object
    public var responsibleDivision = KMADepartmentStruct()
    // Sub land details
    public var landPlanId = ""
    public var subLandArray = [KMAUISubLandStruct]()
    public var lotterySubLandArray = [KMAUISubLandStruct]()
    public var coordinatesArray = [CLLocationCoordinate2D]()
    public var geojsonDict = [String: Any]()
    public var subLandPercent: Double = 0
    public var subLandSquare: Double = 0
    public var subLandIndex = ""
    public var subLandType = ""
    public var subLandObjectId = ""
    public var lotteryStatus: LotteryStatus = .unknowed
    // Counts and percents
    public var rulesArray = [KMAUILotteryRule]()
    public var percentArray = [KMAUILotteryRule]()
    public var totalCount = 0
    public var resultArray = [KMAUILotteryRule]()
    // Queue
    public var queueCount = 0
    public var queueArray = [KMAPerson]()
    public var queueLoaded = false
    public var resultLoaded = false
    public var pairsCount = 0
    public var subLandIndexes = [Int]()
    public var queueIndexes = [Int]()
    // Results
    public var queueResultsArray = [KMAPerson]()
    public var queueDisplay = [KMAPerson]()
    public var queueResultsDisplay = [KMAPerson]()
    // Parse object
    public var createdAt = Date()
    public var updatedAt = Date()
    
    public init() {}
    
    public init(centerCoordinate: CLLocationCoordinate2D, landName: String? = nil, areaWidth: Double? = nil, areaHeight: Double? = nil, degrees: Double? = nil, minSubLandSide: Double? = nil, maxSubLandSide: Double? = nil, mainRoadWidth: Double? = nil, regularRoadWidth: Double? = nil, itemsInSubBlockHorizontal: Int? = nil, itemsInSubBlockVertical: Int? = nil, rowsPerBlock: Int? = nil, servicesPercent: Double? = nil, commercialPercent: Double? = nil, lotteryPercent: Double? = nil, salePercent: Double? = nil, squareMeterPrice: Double? = nil) {
        // Center coordinate
        self.centerCoordinate = centerCoordinate
        
        // Land name
        if let landName = landName {
            self.landName = landName
        }
        
        // Area width
        if let areaWidth = areaWidth {
            self.areaWidth = areaWidth
        }
        
        // Area height
        if let areaHeight = areaHeight {
            self.areaHeight = areaHeight
        }
        
        // Degrees
        if let degrees = degrees {
            self.degrees = degrees
        }
        
        // Min sub land side
        if let minSubLandSide = minSubLandSide {
            self.minSubLandSide = minSubLandSide
        }
        
        // Max sub land side
        if let maxSubLandSide = maxSubLandSide {
            self.maxSubLandSide = maxSubLandSide
        }

        // Main road width
        if let mainRoadWidth = mainRoadWidth {
            self.mainRoadWidth = mainRoadWidth
        }
        
        // Regular road width
        if let regularRoadWidth = regularRoadWidth {
            self.regularRoadWidth = regularRoadWidth
        }
        
        // Items in block horizontal
        if let itemsInSubBlockHorizontal = itemsInSubBlockHorizontal {
            self.itemsInSubBlockHorizontal = itemsInSubBlockHorizontal
        }
        
        // Items in block vertical
        if let itemsInSubBlockVertical = itemsInSubBlockVertical {
            self.itemsInSubBlockVertical = itemsInSubBlockVertical
        }
        
        // Rows per block
        if let rowsPerBlock = rowsPerBlock {
            self.rowsPerBlock = rowsPerBlock
        }

        // Services percent
        if let servicesPercent = servicesPercent {
            self.servicesPercent = Int(servicesPercent)
        }
        
        // Commercial percent
        if let commercialPercent = commercialPercent {
            self.commercialPercent = Int(commercialPercent)
        }
        
        // Residential percent
        if let lotteryPercent = lotteryPercent {
            self.lotteryPercent = Int(lotteryPercent)
        }
        
        // Sale percent
        if let salePercent = salePercent {
            self.salePercent = Int(salePercent)
        }
        
        // Square meter price
        if let squareMeterPrice = squareMeterPrice {
            self.squareMeterPrice = squareMeterPrice
        }
    }
    
    mutating public func getLandPlanGeojson() {
        // MARK: - Clearing the parameters
        landFeatures = [[String: Any]]()
        separateFeatures = [[String: Any]]()
        subLandItems = [PFObject]()
        
        // MARK: - Basic data for the Land Plan
        let angle = Double.pi * degrees / 180 // calculating angle from the degrees
        
        // Getting the corner locations from the centerCoordinate and areaWidth / areaHeight
        let middleTop = centerCoordinate.shift(byDistance: areaHeight / 2, azimuth: 0 + angle)
        let leftTop = middleTop.shift(byDistance: areaWidth / 2, azimuth: -Double.pi / 2 + angle)
        let rightTop = leftTop.shift(byDistance: areaWidth, azimuth: Double.pi / 2 + angle)
        let rightBottom = rightTop.shift(byDistance: areaHeight, azimuth: Double.pi + angle)
        let leftBottom = leftTop.shift(byDistance: areaHeight, azimuth: Double.pi + angle)
        
        // Getting the land plan sw and ne coordinates
        let areaBounds = getBoundsForRect(locations: [leftTop, rightTop, rightBottom, leftBottom])
        sw = areaBounds[0]
        ne = areaBounds[1]
        
        // Sub Land average size for calculations
        averageSubLandSize = (minSubLandSide + maxSubLandSide) / 2
        
        // MARK: - Blocks grid
            
        // Get the block counts - horizontal
        let averageBlockWidth = Double(itemsInSubBlockHorizontal) * averageSubLandSize
        let horizontalBlocks = (areaWidth - mainRoadWidth) / (averageBlockWidth + mainRoadWidth)
        var horizontalBlocksCount = Int(horizontalBlocks)
        
        // Get the block counts - vertical
        let averageBlockHeight = (Double(rowsPerBlock) - 1) * regularRoadWidth + Double(rowsPerBlock) * Double(itemsInSubBlockVertical) * averageSubLandSize
        let verticalBlocks = (areaHeight - mainRoadWidth) / (averageBlockHeight + mainRoadWidth)
        var verticalBlocksCount = Int(verticalBlocks)
        
        print("The Land Plan grid: \(horizontalBlocksCount) x \(verticalBlocksCount) blocks.")
        
        // MARK: - Preparing the geojson
                
        if horizontalBlocksCount == 0 || verticalBlocksCount == 0 {
            print("Can't build a grid - land is too small.")
        } else {
            // MARK: - Adding the Land Plan Border
            addObject(type: "Border", name: "Land Plan", coordinatesArray: [leftTop, rightTop, rightBottom, leftBottom, leftTop])
            
            // MARK: - Getting the bottom and right blocks as they may be not full-sized
            var horizontalExtraSpace = areaWidth - 2 * mainRoadWidth - (mainRoadWidth + averageBlockWidth) * Double(horizontalBlocksCount)
            var verticalExtraSpace = areaHeight - 2 * mainRoadWidth - (mainRoadWidth + averageBlockHeight) * Double(verticalBlocksCount)
                        
            if horizontalExtraSpace > averageSubLandSize {
                horizontalBlocksCount += 1
            } else {
                horizontalExtraSpace = 0
            }
            
            if verticalExtraSpace > averageSubLandSize {
                verticalBlocksCount += 1
            } else {
                verticalExtraSpace = 0
            }

            // MARK: - First left and top Main Roads
            
            // First vertical road
            addMapItem(topLeft: leftTop, width: mainRoadWidth, height: areaHeight, name: "Vertical 0", type: "Main Road", angle: angle)
            addMapItem(topLeft: leftTop, width: areaWidth, height: mainRoadWidth, name: "Horizontal 0", type: "Main Road", angle: angle)
            
            var subBlockRowsCustom: Double = 0
            var subBlockColumnsCustom: Double = 0
            
            // Getting the extra space calculations
            if verticalExtraSpace > 0 {
                subBlockRowsCustom = (verticalExtraSpace + regularRoadWidth) / (averageSubLandSize * Double(itemsInSubBlockVertical) + regularRoadWidth)
                
                if subBlockRowsCustom - Double(Int(subBlockRowsCustom)) > 0.25 {
                    subBlockRowsCustom = Double(Int(subBlockRowsCustom)) + 1
                }
            }
            
            if horizontalExtraSpace > 0 {
                subBlockColumnsCustom = (horizontalExtraSpace + regularRoadWidth) / averageSubLandSize
                
                if subBlockColumnsCustom - Double(Int(subBlockColumnsCustom)) > 0.25 {
                    subBlockColumnsCustom = Double(Int(subBlockColumnsCustom)) + 1
                }
            }
            
            // MARK: - Draw the grid of main roads
            
            for column in 0..<horizontalBlocksCount {
                var blockWidth = averageBlockWidth
                
                if column + 1 == horizontalBlocksCount, horizontalExtraSpace > 0 {
                    blockWidth = horizontalExtraSpace
                }
                
                let columnOffset = (averageBlockWidth + mainRoadWidth) * Double(column) + mainRoadWidth
                
                // MARK: - Create the inner grid for a block - calculating the rows / columns count
                var subBlockRows = Double(rowsPerBlock)
                var subBlockColumns = Double(itemsInSubBlockHorizontal)
                var customBlock = false
                
                // MARK: - Step vertical road
                let roadLeftTop = leftTop.shift(byDistance: columnOffset + blockWidth, azimuth: Double.pi / 2 + angle)
                
                if column + 1 == horizontalBlocksCount {
                    if horizontalExtraSpace > 0 {
                        subBlockColumns = subBlockColumnsCustom
                        customBlock = true
                    }
                    
                    // Filling the whole area left with the road
                    addMapItem(topLeft: roadLeftTop, width: areaWidth - columnOffset - blockWidth, height: areaHeight, name: "Vertical \(column + 1)", type: "Main Road", angle: angle)
                } else {
                    addMapItem(topLeft: roadLeftTop, width: mainRoadWidth, height: areaHeight, name: "Vertical \(column + 1)", type: "Main Road", angle: angle)
                }

                for row in 0..<verticalBlocksCount {
                    var blockHeight = averageBlockHeight
                    
                    if row + 1 == verticalBlocksCount, verticalExtraSpace > 0 {
                        blockHeight = verticalExtraSpace
                    }
                    
                    let rowOffset = (averageBlockHeight + mainRoadWidth) * Double(row) + mainRoadWidth
                    
                    // MARK: - Add the block item
                    let blockLeftTop = leftTop.shift(byDistance: columnOffset, azimuth: Double.pi / 2 + angle).shift(byDistance: rowOffset, azimuth: Double.pi + angle)
                    let blockRightTop = blockLeftTop.shift(byDistance: blockWidth, azimuth: Double.pi / 2 + angle)
                    let blockRightBottom = blockRightTop.shift(byDistance: blockHeight, azimuth: Double.pi + angle)
                    let blockLeftBottom = blockLeftTop.shift(byDistance: blockHeight, azimuth: Double.pi + angle)
                    addObject(type: "Block", name: "\(column)-\(row)", coordinatesArray: [blockLeftTop, blockRightTop, blockRightBottom, blockLeftBottom, blockLeftTop])

                    // MARK: - Step horizontal road
                    let roadLeftTop = leftTop.shift(byDistance: rowOffset + blockHeight, azimuth: Double.pi + angle)
                    
                    if row + 1 == verticalBlocksCount {
                        if verticalExtraSpace > 0 {
                            subBlockRows = subBlockRowsCustom
                            customBlock = true
                        }
                        
                        // Filling the whole area left with the road
                        addMapItem(topLeft: roadLeftTop, width: areaWidth, height: areaHeight - rowOffset - blockHeight, name: "Horizontal \(row + 1)", type: "Main Road", angle: angle)
                    } else {
                        addMapItem(topLeft: roadLeftTop, width: areaWidth, height: mainRoadWidth, name: "Horizontal \(row + 1)", type: "Main Road", angle: angle)
                    }
                    
                    for subBlockRow in 0..<Int(subBlockRows) {
                        // MARK: - Getting the random height for row 1 and 2 inside the Sub Block
                        let subBlockLeftTop = blockLeftTop.shift(byDistance: Double(subBlockRow) * regularRoadWidth + averageSubLandSize * Double(itemsInSubBlockVertical) * Double(subBlockRow), azimuth: Double.pi + angle)
                        
                        var subLandHeight1: Double = 0
                            
                        if maxSubLandSide > minSubLandSide {
                            subLandHeight1 = Double(Int.random(in: Int(minSubLandSide * 100) ..< Int(maxSubLandSide * 100))) / 100
                        } else {
                            subLandHeight1 = maxSubLandSide
                        }
                        
                        var subLandHeight2 = averageSubLandSize * Double(itemsInSubBlockVertical) - subLandHeight1
                        
                        var subBlockHeight = averageSubLandSize * Double(itemsInSubBlockVertical)
                        
                        if subBlockRow + 1 == Int(subBlockRows), customBlock {
                            subBlockHeight = blockHeight - Double(subBlockRow) * (averageSubLandSize * Double(itemsInSubBlockVertical) + regularRoadWidth)
                            subLandHeight2 = subBlockHeight - subLandHeight1
                            
                            if subLandHeight2 < minSubLandSide {
                                subLandHeight1 = subBlockHeight
                                subLandHeight2 = 0
                            }
                        }
                        
                        // MARK: - Adding Sub Block
                        addMapItem(topLeft: subBlockLeftTop, width: blockWidth, height: subBlockHeight, name: "\(column)-\(row)-\(subBlockRow)", type: "Sub Block", angle: angle)
                        
                        if subBlockRow + 1 < Int(subBlockRows) {
                            // MARK: - Adding Regular Road
                            let regularRoadTopLeft = subBlockLeftTop.shift(byDistance: averageSubLandSize * Double(itemsInSubBlockVertical), azimuth: Double.pi + angle)
                            addMapItem(topLeft: regularRoadTopLeft, width: blockWidth, height: regularRoadWidth, name: "\(column)-\(row)-\(subBlockRow)", type: "Regular Road", angle: angle)
                        }

                        var totalWidth: Double = 0
                        
                        for subLandColumn in 0..<Int(subBlockColumns) {
                            var subLandWidth: Double = 0
                            
                            if subLandColumn + 1 == Int(subBlockColumns) {
                                subLandWidth = blockWidth - totalWidth
                            } else {
                                if maxSubLandSide > minSubLandSide {
                                    subLandWidth = Double(Int.random(in: Int(minSubLandSide * 100) ..< Int(maxSubLandSide * 100))) / 100
                                } else {
                                    subLandWidth = maxSubLandSide
                                }
                            }
                            
                            // MARK: - Adding Sub Land
                            
                            // Row 1 top left coordinate
                            let subLand1TopLeft = subBlockLeftTop.shift(byDistance: totalWidth, azimuth: Double.pi / 2 + angle)
                            addMapItem(topLeft: subLand1TopLeft, width: subLandWidth, height: subLandHeight1, name: "\(column)-\(row)-\(subBlockRow)-0-\(subLandColumn)", type: "Sub Land", angle: angle)
                            
                            if subLandHeight2 > 0 {
                                // Row 2 top left coordinate
                                let subLand2TopLeft = subBlockLeftTop.shift(byDistance: totalWidth, azimuth: Double.pi / 2 + angle).shift(byDistance: subLandHeight1, azimuth: Double.pi + angle)
                                addMapItem(topLeft: subLand2TopLeft, width: subLandWidth, height: subLandHeight2, name: "\(column)-\(row)-\(subBlockRow)-1-\(subLandColumn)", type: "Sub Land", angle: angle)
                            }
                            
                            totalWidth += subLandWidth
                        }
                    }
                }
            }
        }
        
        getParseObjects()
        
        let jsonDict: [String: Any] = [
            "type": "FeatureCollection",
            "features": landFeatures
        ]
        
        geojson = ""
        
        if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
            //For JSON String
            if let jsonStr = String(bytes: data, encoding: .utf8) {
                geojson = jsonStr
            }
        }
        
        // Add the Sub Land types into geojson
        addSubLandTypes()
    }
    
    public mutating func addSubLandTypes() {
        // Update the geojson to store the subLandType and objectId
        let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: self.geojson)

        var parseItems = [String: PFObject]()
        
        for subLandItem in self.subLandItems {
            if let subLandName = subLandItem["subLandIndex"] as? String {
                parseItems[subLandName] = subLandItem
            }
        }
        
        if let features = dict["features"] as? [[String: Any]], !features.isEmpty {
            var features = features
            
            for (index, feature) in features.enumerated() {
                var feature = feature
                
                if var itemProperties = feature["properties"] as? [String: AnyObject], let type = itemProperties["type"] as? String, type == "Sub Land", let itemName = itemProperties["name"] as? String {
                    if let parseItem = parseItems[itemName]{
                        // subLandType, String
                        if let subLandType = parseItem["subLandType"] as? String {
                            itemProperties["subLandType"] = subLandType as AnyObject
                        }
                    }
                    
                    feature["properties"] = itemProperties
                    features[index] = feature
                }
            }
            
            let jsonDict: [String: Any] = [
                "type": "FeatureCollection",
                "features": features
            ]
            
            if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
                //For JSON String
                if let jsonStr = String(bytes: data, encoding: .utf8) {
                    self.geojson = jsonStr
                }
            }
        }
    }
    
    public mutating func updateGeojson(parseItems: [String: PFObject]) -> String {
        // Update the geojson to store the subLandType and objectId
        let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: self.geojson)
        var newGeojson = ""
        
        if let features = dict["features"] as? [[String: Any]], !features.isEmpty {
            var features = features
            
            for (index, feature) in features.enumerated() {
                var feature = feature
                var shouldRemove = false
                
                if var itemProperties = feature["properties"] as? [String: AnyObject], let type = itemProperties["type"] as? String, type == "Sub Land", let itemName = itemProperties["name"] as? String {
                    if let parseItem = parseItems[itemName] {
                        // subLandSquare, Double
                        if let subLandSquare = parseItem["subLandSquare"] as? Double {
                            itemProperties["subLandSquare"] = subLandSquare.formatNumbersAfterDot() as AnyObject
                        }
                        // subLandType, String
                        if let subLandType = parseItem["subLandType"] as? String {
                            itemProperties["subLandType"] = subLandType as AnyObject
                        }
                        // subLandWidth, Double
                        if let subLandWidth = parseItem["subLandWidth"] as? Double {
                            itemProperties["subLandWidth"] = subLandWidth.formatNumbersAfterDot() as AnyObject
                            
                            if subLandWidth < 0 {
                                shouldRemove = true
                            }
                        }
                        // subLandHeight, Double
                        if let subLandHeight = parseItem["subLandHeight"] as? Double {
                            itemProperties["subLandHeight"] = subLandHeight.formatNumbersAfterDot() as AnyObject
                            
                            if subLandHeight < 0 {
                                shouldRemove = true
                            }
                        }
                        // location, PFGeoPoint
                        if let location = parseItem["location"] as? PFGeoPoint {
                            itemProperties["latitude"] = location.latitude as AnyObject
                            itemProperties["longitude"] = location.longitude as AnyObject
                        }
                        // minX, Double
                        if let minX = parseItem["minX"] as? Double {
                            itemProperties["minX"] = minX as AnyObject
                        }
                        // minY, Double
                        if let minY = parseItem["minY"] as? Double {
                            itemProperties["minY"] = minY as AnyObject
                        }
                        // maxX, Double
                        if let maxX = parseItem["maxX"] as? Double {
                            itemProperties["maxX"] = maxX as AnyObject
                        }
                        // maxY, Double
                        if let maxY = parseItem["maxY"] as? Double {
                            itemProperties["maxY"] = maxY as AnyObject
                        }
                        // subLandPercent, Double
                        if let subLandPercent = parseItem["subLandPercent"] as? Double {
                            itemProperties["subLandPercent"] = subLandPercent.formatNumbersAfterDot() as AnyObject
                        }
                        // extraPrice, Double
                        if let extraPrice = parseItem["extraPrice"] as? Double {
                            itemProperties["extraPrice"] = extraPrice.formatNumbersAfterDot() as AnyObject
                        }
                        // objectId, String
                        if let objectId = parseItem.objectId {
                            itemProperties["objectId"] = objectId as AnyObject
                        }
                    }
                    
                    feature["properties"] = itemProperties
                    features[index] = feature
                    
                    if shouldRemove {
                        features.remove(at: index)
                    }
                }
            }
            
            let jsonDict: [String: Any] = [
                "type": "FeatureCollection",
                "features": features
            ]
            
            if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
                //For JSON String
                if let jsonStr = String(bytes: data, encoding: .utf8) {
                    newGeojson = jsonStr
                }
            }
        }
        
        return newGeojson
    }
    
    public func getBoundsForRect(locations: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D] {
        var minX: Double = 0
        var minY: Double = 0
        var maxX: Double = 0
        var maxY: Double = 0
        
        for location in locations {
            if minX == 0 || location.longitude < minX {
                minX = location.longitude
            }
            
            if minY == 0 || location.latitude < minY {
                minY = location.latitude
            }
            
            if maxX == 0 || location.longitude > maxX {
                maxX = location.longitude
            }
            
            if maxY == 0 || location.latitude > maxY {
                maxY = location.latitude
            }
        }
        
        return [CLLocationCoordinate2D(latitude: minY, longitude: minX), CLLocationCoordinate2D(latitude: maxY, longitude: maxX)]
    }
    
    /**
     Adding the demo map item
     */
    
    mutating public func addMapItem(topLeft: CLLocationCoordinate2D, width: Double, height: Double, name: String, type: String, angle: Double) {
        let rightTop = topLeft.shift(byDistance: width, azimuth: Double.pi / 2 + angle)
        let rightBottom = rightTop.shift(byDistance: height, azimuth: Double.pi + angle)
        let leftBottom = topLeft.shift(byDistance: height, azimuth: Double.pi + angle)

        addObject(type: type, name: name, coordinatesArray: [topLeft, rightTop, rightBottom, leftBottom, topLeft], width: width, height: height)
    }
    
    /**
     Adding objects
     */
    
    mutating public func addObject(type: String, name: String, coordinatesArray: [CLLocationCoordinate2D], width: Double? = nil, height: Double? = nil) {
        var allowedTypes = [String]()
        allowedTypes.append("Border")
        allowedTypes.append("Main Road")
        allowedTypes.append("Block")
        allowedTypes.append("Sub Block")
        allowedTypes.append("Regular Road")
        allowedTypes.append("Sub Land")
        
        if allowedTypes.contains(type) {
            var coordinatesStrings = [Any]()
            
            for location in coordinatesArray {
                var waypoints = [Any]()
                waypoints.append(location.longitude)
                waypoints.append(location.latitude)
                coordinatesStrings.append(waypoints)
            }
            
            let areaBounds = getBoundsForRect(locations: coordinatesArray)
            
            let minX = areaBounds[0].longitude
            let minY = areaBounds[0].latitude
            let maxX = areaBounds[1].longitude
            let maxY = areaBounds[1].latitude
            let location = PFGeoPoint(latitude: (areaBounds[0].latitude + areaBounds[1].latitude) / 2, longitude: (areaBounds[0].longitude + areaBounds[1].longitude) / 2)
            
            var widthValue: Double = 0
            var heightValue: Double = 0
            
            if let width = width, let height = height {
                widthValue = width
                heightValue = height
            }
            
            let subLandSquare = widthValue * heightValue
            let subLandPercent = widthValue * heightValue / (averageSubLandSize * averageSubLandSize)
            
            var extraPrice: Double = 0
            
            let additionalSquare = widthValue * heightValue - averageSubLandSize * averageSubLandSize
            
            if additionalSquare > 0 {
                extraPrice = additionalSquare * squareMeterPrice
            }
            
            let properties = ["name": name, "type": type] as [String: Any]
            
            // Land features
            let feature: [String: Any] = [
                "type": "Feature",
                "properties": properties,
                "geometry": [
                    "type": "LineString",
                    "coordinates": coordinatesStrings
                ]
            ]
            
            landFeatures.append(feature)
            
            let jsonDict: [String: Any] = [
                "type": "FeatureCollection",
                "features": [feature]
            ]
            
            separateFeatures.append(jsonDict)
            
            // MARK: - Parse object for the KMASubLand
            if type == "Sub Land" {
                // New KMASubLand object
                let subLandObject = PFObject(className: "KMASubLand")
                
                // subLandArea
                if let data = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted) {
                    // For JSON String
                    if let jsonStr = String(bytes: data, encoding: .utf8) {
                        subLandObject["subLandArea"] = jsonStr
                    }
                }
                
                // location
                subLandObject["minX"] = minX
                subLandObject["minY"] = minY
                subLandObject["maxX"] = maxX
                subLandObject["maxY"] = maxY
                subLandObject["location"] = location
                
                // subLandIndex
                subLandObject["subLandIndex"] = name
                
                // subLandSquare
                subLandObject["subLandWidth"] = widthValue.formatNumbersAfterDot()
                subLandObject["subLandHeight"] = heightValue.formatNumbersAfterDot()
                subLandObject["subLandSquare"] = subLandSquare.formatNumbersAfterDot()
                
                // subLandPercent - square / average square
                subLandObject["subLandPercent"] = subLandPercent.formatNumbersAfterDot()
                subLandObject["extraPrice"] = extraPrice.formatNumbersAfterDot()
                
                if widthValue < 0 || heightValue < 0 {
                    // Error - can't be negative
                } else {
                    subLandItems.append(subLandObject)
                }
            }
        }
    }
    
    mutating public func getParseObjects() {
        // Desired counts
        let desiredServicesCount = Int(Double(servicesPercent) / 100 * Double(subLandItems.count))
        let desiredCommercialCount = Int(Double(commercialPercent) / 100 * Double(subLandItems.count))
        let desiredSaleCount = Int(Double(salePercent) / 100 * Double(subLandItems.count))
        let desiredLotteryCount = subLandItems.count - (desiredServicesCount + desiredCommercialCount + desiredSaleCount)
        
//        print("We have the following percents: \(servicesPercent), \(commercialPercent), \(salePercent), \(lotteryPercent)\nCount: \(desiredServicesCount), \(desiredCommercialCount), \(desiredSaleCount), \(desiredLotteryCount)\nTotal counts: \(subLandItems.count) -> \(desiredServicesCount + desiredCommercialCount + desiredSaleCount + desiredLotteryCount)")
        
        // Clear the counts
        saleCount = 0
        lotteryCount = 0
        commercialCount = 0
        servicesCount = 0

        for item in subLandItems {
            var types = [String]()
            
            if saleCount < desiredSaleCount {
                types.append("Residential Sale")
            }
            
            if lotteryCount < desiredLotteryCount {
                // So we have more chances for the better sub lands distribution
                types.append("Residential Lottery")
                types.append("Residential Lottery")
                types.append("Residential Lottery")
            }

            if commercialCount < desiredCommercialCount {
                types.append("Commercial")
            }
            
            if servicesCount < desiredServicesCount {
                types.append("Services")
            }
            
            if types.isEmpty {
                print("No types available...")
            } else {
                let index = Int.random(in: 0 ..< types.count)
                let itemType = types[index]
                
//                print("Types: `\(types)`, selected type: `\(itemType)`")
                
                if itemType == "Residential Sale" {
                    saleCount += 1
                    item["subLandType"] = "Residential Sale"
                } else if itemType == "Residential Lottery" {
                    lotteryCount += 1
                    item["subLandType"] = "Residential Lottery"
                } else if itemType == "Commercial" {
                    commercialCount += 1
                    item["subLandType"] = "Commercial"
                } else if itemType == "Services" {
                    servicesCount += 1
                    item["subLandType"] = "Services"
                }
            }
        }
        
        print("Results: \(lotteryCount) + \(saleCount), \(commercialCount), \(servicesCount)")
    }
    
    mutating public func prepareRules() {
        // Sub Land counts by type
        self.servicesCount = 0
        self.commercialCount = 0
        self.saleCount = 0
        self.lotteryCount = 0
        self.totalCount = 0
        
        for subLandItem in self.subLandArray {
            if !subLandItem.subLandType.isEmpty {
                if subLandItem.subLandType == "Services" {
                    self.servicesCount += 1
                } else if subLandItem.subLandType == "Commercial" {
                    self.commercialCount += 1
                } else if subLandItem.subLandType == "Residential Sale" {
                    self.saleCount += 1
                } else if subLandItem.subLandType == "Residential Lottery" {
                    self.lotteryCount += 1
                }
            }
        }
        
        // Total subLand counts
        self.totalCount = self.servicesCount + self.commercialCount + self.saleCount + self.lotteryCount
        
        if self.totalCount > 0 {
            // Sub Land percents per category
            self.servicesPercent = Int(((Double(self.servicesCount) / Double(self.totalCount)) * 100).formatNumbersAfterDot())
            self.commercialPercent = Int(((Double(self.commercialCount) / Double(self.totalCount)) * 100).formatNumbersAfterDot())
            self.salePercent = Int(((Double(self.saleCount) / Double(self.totalCount)) * 100).formatNumbersAfterDot())
            self.lotteryPercent = 100 - (self.servicesPercent + self.commercialPercent + self.salePercent)
        }
        
        // Section 0
        self.rulesArray = [KMAUILotteryRule(name: "Area width", value: "\(Int(self.areaWidth)) m"), KMAUILotteryRule(name: "Area height", value: "\(Int(self.areaHeight)) m"), KMAUILotteryRule(name: "Main road", value: "\(Int(self.mainRoadWidth)) m"), KMAUILotteryRule(name: "Regular road", value: "\(Int(self.regularRoadWidth)) m"), KMAUILotteryRule(name: "Extra price", value: "$\(Int(squareMeterPrice).withCommas()) per m²")]
        // KMAUILotteryRule(name: "City block", value: "\(self.rowsPerBlock) rows, \(self.rowsPerBlock - 1) roads"),  // hidden for now
        
        // Section 1
        self.percentArray = [KMAUILotteryRule(name: "Sub lands for services", value: "\(self.servicesCount)", percent: "\(self.servicesPercent)%"), KMAUILotteryRule(name: "Sub lands for commercial", value: "\(self.commercialCount)", percent: "\(self.commercialPercent)%"), KMAUILotteryRule(name: "Sub lands for sale", value: "\(self.saleCount)", percent: "\(self.salePercent)%"), KMAUILotteryRule(name: "Sub lands for lottery", value: "\(self.lotteryCount)", percent: "\(self.lotteryPercent)%")]
        
        // Results
        setupResultArray()
    }
    
    public mutating func setupResultArray() {
        self.resultArray = [KMAUILotteryRule(name: "Sub lands for lottery", value: "\(self.lotterySubLandArray.count)"), KMAUILotteryRule(name: "Citizens in queue", value: "\(self.queueCount)")]
    }
    
    mutating public func fillFromParse(plan: PFObject) {
        // landPlanId
        if let landPlanIdValue = plan.objectId {
            self.landPlanId = landPlanIdValue
        }
        // createdAt
        if let createdAt = plan.createdAt {
            self.createdAt = createdAt
        }
        // updatedAt
        if let updatedAt = plan.updatedAt {
            self.updatedAt = updatedAt
        }
        // planName
        if let planName = plan["planName"] as? String {
            self.landName = planName
        }
        // startDate
        if let startDate = plan["startDate"] as? Date {
            self.startDate = startDate
        }
        // endDate
        if let endDate = plan["endDate"] as? Date {
            self.endDate = endDate
        }
        // subLandsCount
        if let subLandsCount = plan["subLandsCount"] as? Int {
            self.subLandsCount = subLandsCount
        }
        // lotterySubLandsCount
        if let lotterySubLandsCount = plan["lotterySubLandsCount"] as? Int {
            self.lotterySubLandsCount = lotterySubLandsCount
        }
        // lotteryStatus
        if let lotteryStatusValue = plan["lotteryStatus"] as? String,
            let status = LotteryStatus(rawValue: lotteryStatusValue) {
            self.lotteryStatus = status
        }
        // extraPricePerSqM
        if let extraPricePerSqM = plan["extraPricePerSqM"] as? Double {
            self.squareMeterPrice = extraPricePerSqM
        }
        // mainRoadWidth
        if let mainRoadWidth = plan["mainRoadWidth"] as? Int {
            self.mainRoadWidth = Double(mainRoadWidth)
        }
        // regularRoadWidth
        if let regularRoadWidth = plan["regularRoadWidth"] as? Int {
            self.regularRoadWidth = Double(regularRoadWidth)
        }
        // landArea
        if let landArea = plan["landArea"] as? String {
            self.geojson = landArea
            
            let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: landArea)

            if let features = dict["features"] as? [[String: Any]], !features.isEmpty {
                let border = features[0]
                // coordinates
                if let geometry = border["geometry"] as? [String: Any], let coordinates = geometry["coordinates"] as? [[Double]], coordinates.count >= 5 {
                    let topLeftCoordinate = coordinates[0]
                    let topRightCoordinate = coordinates[1]
                    let bottomLeftCoordinate = coordinates[3]
                    
                    let topLeft = CLLocation(latitude: topLeftCoordinate[0], longitude: topLeftCoordinate[1])
                    let topRight = CLLocation(latitude: topRightCoordinate[0], longitude: topRightCoordinate[1])
                    let bottomLeft = CLLocation(latitude: bottomLeftCoordinate[0], longitude: bottomLeftCoordinate[1])
                    
                    let width = Double(Int(topLeft.distance(from: topRight)))
                    let height = Double(Int(topLeft.distance(from: bottomLeft)))
                    
                    self.areaWidth = width
                    self.areaHeight = height
                }
                
                // Sub Lands -> update to use the new `KMAUISubLandStruct`
                self.subLandArray = [KMAUISubLandStruct]()
                
                for item in features {
                    var subLandItem = KMAUISubLandStruct()
                    subLandItem.fillFromDict(item: item)
                    
                    if !subLandItem.subLandType.isEmpty { // no need to save roads and other items here / empty subLand items
                        self.subLandArray.append(subLandItem)
                        
                        if subLandItem.subLandType == "Residential Lottery" {
                            self.lotterySubLandArray.append(subLandItem)
                        }
                    }
                }
            }
        }
        // Counts / Percents for Sub Lands
        self.prepareRules()
        // centerCoordinate
        if let location = plan["location"] as? PFGeoPoint {
            self.centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        }
        // minX, minY
        if let minX = plan["minX"] as? Double, let minY = plan["minY"] as? Double {
            self.sw = CLLocationCoordinate2D(latitude: minY, longitude: minX)
        }
        // maxX, maxY
        if let maxX = plan["maxX"] as? Double, let maxY = plan["maxY"] as? Double {
            self.ne = CLLocationCoordinate2D(latitude: maxY, longitude: maxX)
        }
        // responsibleDivision
        if let responsibleDivisionValue = plan["responsibleDivision"] as? PFObject {
            var divisionObject = KMADepartmentStruct()
            divisionObject.fillFromParse(departmentObject: responsibleDivisionValue)
            self.responsibleDivision = divisionObject
        }
    }
    
    mutating public func setDimensions() {
        // landArea
        if !geojson.isEmpty {
            let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: self.geojson)

            if let features = dict["features"] as? [[String: Any]], !features.isEmpty {
                let border = features[0]
                // coordinates
                if let geometry = border["geometry"] as? [String: Any], let coordinates = geometry["coordinates"] as? [[Double]], coordinates.count >= 5 {
                    let topLeftCoordinate = coordinates[0]
                    let topRightCoordinate = coordinates[1]
                    let bottomLeftCoordinate = coordinates[3]
                    
                    let topLeft = CLLocation(latitude: topLeftCoordinate[0], longitude: topLeftCoordinate[1])
                    let topRight = CLLocation(latitude: topRightCoordinate[0], longitude: topRightCoordinate[1])
                    let bottomLeft = CLLocation(latitude: bottomLeftCoordinate[0], longitude: bottomLeftCoordinate[1])
                    
                    let width = Double(Int(topLeft.distance(from: topRight)))
                    let height = Double(Int(topLeft.distance(from: bottomLeft)))
                    
                    self.areaWidth = width
                    self.areaHeight = height
                }
            }
        }
    }
}

// MARK: - Lottery rule struct

public struct KMAUILotteryRule {
    // Variables
    public var name = ""
    public var value = ""
    public var percent = ""
    
    public init() {
    }
    
    public init(name: String, value: String, percent: String? = nil) {
        self.name = name
        self.value = value
        
        if let percent = percent {
            self.percent = percent
        }
    }
}

// MARK: - Lottery rules from Ministry struct

public struct KMAUILotteryRules {
    public var areaWidth = 1500
    public var areaHeight = 1000
    public var mainRoadWidth = 20
    public var regularRoadWidth = 6
    public var rowsPerBlock = 4
    public var squareMeterPrice = 1500
    public var servicesPercent = 15
    public var commercialPercent = 20
    public var salePercent = 15
    public var lotteryPercent = 50
    // Additional parameters
    public var itemsInSubBlockHorizontal = 5
    public var itemsInSubBlockVertical = 2
    public var minSubLandSide = 25
    public var maxSubLandSide = 30
    public var objectId = ""
    public var rangePercent = 30
    
    public init() {
    }
    
    public mutating func fillFromParse(object: PFObject) {
        // objectId
        if let objectId = object.objectId {
            self.objectId = objectId
        }
        // areaWidth
        if let areaWidth = object["areaWidth"] as? Int {
            self.areaWidth = areaWidth
        }
        // areaHeight
        if let areaHeight = object["areaHeight"] as? Int {
            self.areaHeight = areaHeight
        }
        // mainRoadWidth
        if let mainRoadWidth = object["mainRoadWidth"] as? Int {
            self.mainRoadWidth = mainRoadWidth
        }
        // regularRoadWidth
        if let regularRoadWidth = object["regularRoadWidth"] as? Int {
            self.regularRoadWidth = regularRoadWidth
        }
        // rowsPerBlock
        if let rowsPerBlock = object["rowsPerBlock"] as? Int {
            self.rowsPerBlock = rowsPerBlock
        }
        // squareMeterPrice
        if let squareMeterPrice = object["squareMeterPrice"] as? Int {
            self.squareMeterPrice = squareMeterPrice
        }
        // servicesPercent
        if let servicesPercent = object["servicesPercent"] as? Int {
            self.servicesPercent = servicesPercent
        }
        // commercialPercent
        if let commercialPercent = object["commercialPercent"] as? Int {
            self.commercialPercent = commercialPercent
        }
        // salePercent
        if let salePercent = object["salePercent"] as? Int {
            self.salePercent = salePercent
        }
        // lotteryPercent
        if let lotteryPercent = object["lotteryPercent"] as? Int {
            self.lotteryPercent = lotteryPercent
        }
        // rangePercent
        if let rangePercent = object["rangePercent"] as? Int {
            self.rangePercent = rangePercent
        }
    }
}

// MARK: - Search struct

public struct KMAUISearch {
    // Search results
    public var landPlans = [KMAUILandPlanStruct]()
    public var subLands = [KMAUISubLandStruct]()
    public var citizens = [KMAPerson]()
    // Backup arrays
    public var landPlansBackup = [KMAUILandPlanStruct]()
    public var subLandsBackup = [KMAUISubLandStruct]()
    public var citizensBackup = [KMAPerson]()
    // Backup ids
    public var landPlansBackupIds = [String]()
    public var subLandsBackupIds = [String]()
    public var citizensBackupIds = [String]()
    // Search string
    public var search = ""
    public var searchActive = false
    public var count = 0 // count of the result types: 3 if land plan, sub land and citizen all found for search
    public var arrays = ["" as AnyObject, "" as AnyObject, "" as AnyObject]
    
    public init() {
    }
    
    public mutating func updateArrays(newLandPlans: [KMAUILandPlanStruct], newSubLands: [KMAUISubLandStruct], newCitizens: [KMAPerson]) {
        // Land plans
        landPlansBackup.append(contentsOf: newLandPlans)
        for landPlan in newLandPlans {
            landPlansBackupIds.append(landPlan.landPlanId)
        }
        // Sub lands
        subLandsBackup.append(contentsOf: newSubLands)
        for subLand in newSubLands {
            subLandsBackupIds.append(subLand.objectId)
        }
        // Citizens
        citizensBackup.append(contentsOf: newCitizens)
        for citizen in newCitizens {
            citizensBackupIds.append(citizen.objectId)
        }
    }
    
    public mutating func updateSearch() {
        clearSearch()
        // Fill arrays
        if !search.isEmpty {
            // Land plans
            for landPlan in landPlansBackup {
                if landPlan.landName.lowercased().contains(search.lowercased()) {
                    landPlans.append(landPlan)
                }
            }
            landPlans = KMAUIUtilities.shared.orderLandPlansName(array: landPlans)
            // Sub lands
            for subLand in subLandsBackup {
                if subLand.subLandId.lowercased().contains(search.lowercased()) || subLand.subLandIndex.lowercased().contains(search.lowercased()) || subLand.subLandType.lowercased().contains(search.lowercased()) {
                    subLands.append(subLand)
                }
            }
            subLands = KMAUIUtilities.shared.orderSubLandsName(array: subLands)
            // Citizens
            for citizen in citizensBackup {
                if citizen.fullName.lowercased().contains(search.lowercased()) || citizen.objectId.lowercased().contains(search.lowercased()) {
                    citizens.append(citizen)
                }
            }
            citizens = KMAUIUtilities.shared.orderCitizensFullName(array: citizens)
            // Fill count and arrays
            arrays = [AnyObject]()
            if !landPlans.isEmpty {
                count += 1
                arrays.append(landPlans as AnyObject)
            }
            if !subLands.isEmpty {
                count += 1
                arrays.append(subLands as AnyObject)
            }
            if !citizens.isEmpty {
                count += 1
                arrays.append(citizens as AnyObject)
            }
            //
            let diff = count - 3
            if diff > 0 {
                for _ in 0..<diff {
                    arrays.append("" as AnyObject)
                }
            }
        }
    }
    
    public mutating func clearSearch() {
        landPlans = [KMAUILandPlanStruct]()
        subLands = [KMAUISubLandStruct]()
        citizens = [KMAPerson]()
        count = 0
        arrays = ["" as AnyObject, "" as AnyObject, "" as AnyObject]
    }
}

public struct KMANotificationStruct {
    public var createdAt = Date()
    public var updatedAt = Date()
    public var objectId = ""
    public var title = ""
    public var message = ""
    public var items = ""
    public var read = false
    
    public init() {
    }
    
    public mutating func fillFromParse(object: PFObject) {
        // Created at
        if let createdAt = object.createdAt {
            self.createdAt = createdAt
        }
        // Updated at
        if let updatedAt = object.updatedAt {
            self.updatedAt = updatedAt
        }
        // Object ID
        if let objectId = object.objectId {
            self.objectId = objectId
        }
        // Title
        if let title = object["title"] as? String {
            self.title = title
        }
        // Message
        if let message = object["message"] as? String {
            self.message = message
        }
        // Items
        if let items = object["items"] as? String {
            self.items = items
        }
        // Read
        if let read = object["read"] as? Bool {
            self.read = read
        }
    }
}

