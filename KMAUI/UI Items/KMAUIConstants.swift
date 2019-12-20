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
    public let propertyIcon = UIImage(named: "propertyIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let weatherError = UIImage(named: "weatherError", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let bathIcon = UIImage(named: "bathIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let bedIcon = UIImage(named: "bedIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let receptIcon = UIImage(named: "receptIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let lowPrice = UIImage(named: "lowPrice", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let highPrice = UIImage(named: "highPrice", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let floorPlanIcon = UIImage(named: "floorPlanIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let floorsCountIcon = UIImage(named: "floorsCountIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!

    // MARK: - Constants
    public let KMACornerRadius: CGFloat = 6
    public let KMAScreenWidth = UIScreen.main.bounds.size.width
    public let KMSScreenHeight = UIScreen.main.bounds.size.height
    
    public let KMABorderWidthLight: CGFloat = 0.5
    public let KMABorderWidthRegular: CGFloat = 1.0
    public let KMABorderWidthBold: CGFloat = 2.0
    
    // MARK: - Login variables
    public let usernameAllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-@"
    
    // MARK: - AccuWeather
    public let accuweatherApiKey = "ieshnLrs4i3JbLXAuO97CGGS5L1on6Kz"
    // sircfc@me.com "ieshnLrs4i3JbLXAuO97CGGS5L1on6Kz"
    // sircfc+john@me.com "AXsdi3EjiJuq2eicR85FyRj9pZ4h0shH"
    // sircfc+lamps@me.com "fqCYgiPCaG5XxqPhTl3047ZCLztXY6Zk"

    // MARK: - Foursquare
    public let foursquareClientKey = "VOXV1M5DGZ35F3UANNVUSA34EYK30EWJYGBSWQ0ZVD3GGC4K"
    public let foursquareClientSecret = "YYRUX3MJYSNHGT54FR2PLLBQ3YUOOHK3BIS1A0VBBP2L3YRB"
    
    // MARK: - Zoopla
    public let zooplaApiKey = "z2jerfddwxkye3w653muzfjy"
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

// MARK: - String extension

public extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
