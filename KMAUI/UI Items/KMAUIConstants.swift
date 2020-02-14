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
    
    // MARK: - Lightbox closed - no need to open main map
    public var lightboxVisible = false
    
    // MARK: - Fonts
    public let KMAUIRegularFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    public let KMAUIBoldFont = UIFont.systemFont(ofSize: 14, weight: .bold)
    
    // MARK: - KMAUIColors
    public let KMAUIMainBgColor = UIColor(named: "KMAUIMainBgColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIViewBgColor = UIColor(named: "KMAUIViewBgColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUITextColor = UIColor(named: "KMAUITextColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIBlueDarkColor = UIColor(named: "KMAUIBlueDarkColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIGreyLineColor = UIColor(named: "KMAUIGreyLineColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIGreyProgressColor = UIColor(named: "KMAUIGreyProgressColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIRedProgressColor = UIColor(named: "KMAUIRedProgressColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIYellowProgressColor = UIColor(named: "KMAUIYellowProgressColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIGreenProgressColor = UIColor(named: "KMAUIGreenProgressColor", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIBlueDarkColorBarTint = UIColor(named: "KMAUIBlueDarkColorBarTint", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!    
    // This is used for the Detail part of the UISplitViewController, where we need the white background and the Dark items are reserved
    public let KMAUIMainBgColorReverse = UIColor(named: "KMAUIMainBgColorReverse", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAUIViewBgColorReverse = UIColor(named: "KMAUIViewBgColorReverse", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!

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
    public let KMABuildingGray = UIColor(named: "KMABuildingGray", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let KMAProgressGray = UIColor(named: "KMAProgressGray", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    
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
    public let rightArrow = UIImage(named: "rightArrow", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let checkmarkIcon = UIImage(named: "checkmarkIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let policemanIcon = UIImage(named: "policemanIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let departmentPlaceholder = UIImage(named: "departmentPlaceholder", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let houseIcon = UIImage(named: "houseIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let apartmentIcon = UIImage(named: "apartmentIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let closeIcon = UIImage(named: "closeIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let starIcon = UIImage(named: "starIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let arrowIndicator = UIImage(named: "arrowIndicator", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let arrowUpIndicator = UIImage(named: "arrowUpIndicator", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let arrowDownIndicator = UIImage(named: "arrowDownIndicator", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let eyeIcon = UIImage(named: "eyeIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let optionsIcon = UIImage(named: "optionsIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let mapIcon = UIImage(named: "mapIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let profileIcon = UIImage(named: "profileIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let requestsIcon = UIImage(named: "requestsIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let infoIcon = UIImage(named: "infoIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let filterBarIcon = UIImage(named: "filterBarIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let playIcon = UIImage(named: "playIcon", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let placeholderUploadImage = UIImage(named: "placeholderUploadImage", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let placeholderProfileImage = UIImage(named: "placeholderProfileImage", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!
    public let placeholderUploadImageNoir = UIImage(named: "placeholderUploadImageNoir", in: Bundle(for: KMAUIConstants.self), compatibleWith: nil)!

    // MARK: - Constants
    public let KMACornerRadius: CGFloat = 6
    public let KMAScreenWidth = UIScreen.main.bounds.size.width
    public let KMSScreenHeight = UIScreen.main.bounds.size.height
    
    public let KMABorderWidthLight: CGFloat = 0.5
    public let KMABorderWidthRegular: CGFloat = 1.0
    public let KMABorderWidthBold: CGFloat = 2.0
    
    public let KMATranslucentBg: CGFloat = 0.9
    
    public let performanceTitles = ["Community", "Service", "Security"]
    
    // MARK: - Login variables
    public let usernameAllowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-@"
    
    // MARK: - AccuWeather
    public let accuweatherApiKey = "ieshnLrs4i3JbLXAuO97CGGS5L1on6Kz"
    // sircfc@me.com "ieshnLrs4i3JbLXAuO97CGGS5L1on6Kz"
    // sircfc+john@me.com "AXsdi3EjiJuq2eicR85FyRj9pZ4h0shH"
    // sircfc+lamps@me.com "fqCYgiPCaG5XxqPhTl3047ZCLztXY6Zk"

    // MARK: - Foursquare
    public let foursquareClientKey = "JWSG0SW0WKBJB0RXZXEH22YHULI1H0F1HHLBGXN21Z43GM0B"
    public let foursquareClientSecret = "W33Y0YKBGEWUTSZW3X0EIB2E5T3GMZWSJ03ODCUB2IZT0GMI"
    
    // sircfc@me.com
    // "VOXV1M5DGZ35F3UANNVUSA34EYK30EWJYGBSWQ0ZVD3GGC4K"
    // "YYRUX3MJYSNHGT54FR2PLLBQ3YUOOHK3BIS1A0VBBP2L3YRB"
    // sircfc+kma@me.com
    // JWSG0SW0WKBJB0RXZXEH22YHULI1H0F1HHLBGXN21Z43GM0B
    // W33Y0YKBGEWUTSZW3X0EIB2E5T3GMZWSJ03ODCUB2IZT0GMI
    
    // MARK: - Zoopla
    public let zooplaApiKey = "xrkapx8jfkzee5y5p8drapqy"
    // "77ercg9phrbdz8mp8mgfprdq"
    // "3kkfx7unbbewky5vx3qb7yjt"
    // "vb8sbaprpy7a85dygjdpjznf"
    //    "z2jerfddwxkye3w653muzfjy"
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
