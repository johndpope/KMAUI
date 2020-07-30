//
//  KMAUIUtilities.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse
import PDFKit
import MapKit
import Photos
import Contacts
import QuickLook
import Alamofire
import SwiftyJSON
import ContactsUI
import CoreLocation
import MKRingProgressView

public class KMAUIUtilities {
    // Access variable
    public static let shared = KMAUIUtilities()
    public var uploadAlert = UIAlertController()
    
    /**
     Returns the UIView for a header with the headerTitle set for a label.
     */
    
    public func headerView(title: String, isRound: Bool? = nil, isGrayBg: Bool? = nil) -> UITableViewHeaderFooterView {
        var offset: CGFloat = 0
        var bgColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        if let isGrayBg = isGrayBg, isGrayBg {
            bgColor = KMAUIConstants.shared.KMAUIMainBgColor
        }
        
        if let isRound = isRound, isRound {
            offset = 20
        }
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: KMAUIConstants.shared.KMAScreenWidth, height: 44 + offset))
        
        if offset > 0 {
            backgroundView.layer.cornerRadius = 16
            backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // Header view
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: KMAUIConstants.shared.KMAScreenWidth, height: 44 + offset))
        headerView.backgroundColor = bgColor
        backgroundView.backgroundColor = bgColor
        headerView.addSubview(backgroundView)
        
        // Header title label
        let headerTitleLabel = KMAUIBoldTextLabel(frame: CGRect(x: 16, y: 8 + offset, width: KMAUIConstants.shared.KMAScreenWidth - 32, height: 36))
        headerTitleLabel.text = title
        headerTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerView.addSubview(headerTitleLabel)
        
        // Auto-layout for label
        KMAUIUtilities.shared.setConstaints(parentView: headerView, childView: headerTitleLabel, left: 16, right: -16, top: offset, bottom: 0)
        
        // Create a view cell and attach the custom view to it
        let headerViewObject = UITableViewHeaderFooterView()
        headerViewObject.backgroundView = UIView(frame: headerView.bounds)
        headerViewObject.backgroundView?.backgroundColor = bgColor
        let contentView = headerViewObject.contentView
        contentView.addSubview(headerView)
        
        // Auto-layout for headerView
        KMAUIUtilities.shared.setConstaints(parentView: contentView, childView: headerView, left: 0, right: 0, top: 0, bottom: 0)
        
        return headerViewObject
    }
    
    /**
     Set constraints.
     */
    
    public func setConstaints(parentView: UIView, childView: UIView, left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        childView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: left).isActive = true
        childView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: right).isActive = true
        childView.topAnchor.constraint(equalTo: parentView.topAnchor, constant: top).isActive = true
        childView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: bottom).isActive = true
    }
    
    // MARK: - Controller methods
    
    /**
     Global alert message which can be called from anywhere in the app to show the UIAlertController over the current screen
     */
    
    public func globalAlert(title: String, message: String, completion: @escaping (_ result: String)->()) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.view.tintColor = KMAUIConstants.shared.KMABrightBlueColor
        
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            completion("closed")
        }
        
        alertController.addAction(cancelAction)
        
        KMAUIUtilities.shared.displayAlert(viewController: alertController)
    }
    
    /**
     Show the loading alert.
     */
    
    public func startLoading(title: String) {
        let alert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint // KMABrightBlueColor
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        
        KMAUIUtilities.shared.displayAlert(viewController: alert)
    }
    
    /**
     Displaying the upload progress.
     */
    
    public func uploadProgressAlert(title: String, message: String) {
        uploadAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 20, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        loadingIndicator.color = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint // KMABrightBlueColor
        loadingIndicator.startAnimating()
        
        uploadAlert.view.addSubview(loadingIndicator)
        
        KMAUIUtilities.shared.displayAlert(viewController: uploadAlert)
    }
    
    /**
     Hide the loading alert.
     */
    
    public func stopLoadingWith(completion: @escaping (_ hide: String)->()) {
        guard let topController = KMAUIUtilities.shared.getTopVisibleController() else {
            return
        }
        
        topController.dismiss(animated: false) {
            completion("hide")
        }
    }
    
    /**
     Hide the loading alert.
     */
    
    public func stopLoadingWithAnimation(completion: @escaping (_ hide: String)->()) {
        guard let topController = KMAUIUtilities.shared.getTopVisibleController() else {
            return
        }
        
        topController.dismiss(animated: true) {
            completion("hide")
        }
    }
    
    /**
     Display the alert controller over the current context
     */
    
    public func displayAlert(viewController: UIViewController) {
        guard let topController = KMAUIUtilities.shared.getTopVisibleController() else {
            return
        }
        
        topController.present(viewController, animated: true, completion: nil)
    }
    
    /**
     Get the top visible View Controller.
     */
    
    public func getTopVisibleController() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow,
            var controller = window.rootViewController else {
                return nil
        }
        
        var reachedTop = false
        
        while reachedTop == false {
            let topController = KMAUIUtilities.shared.findTopController(for: controller)
            
            if topController == controller {
                controller = topController
                reachedTop = true
            } else {
                controller = topController
            }
        }
        
        return controller
    }
    
    /**
     Find the top View Controller.
     */
    
    public func findTopController(for controller : UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            if let navigationController = presentedController as? UINavigationController,
                let topController = navigationController.topViewController {
                return topController
            } else {
                return presentedController
            }
        } else {
            if let navigationController = controller as? UINavigationController,
                let topController = navigationController.topViewController {
                return topController
            } else {
                return controller
            }
        }
    }
    
    // MARK: - Right Arrow image view
    
    public func setupArrow(imageView: UIImageView) {
        imageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        imageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysOriginal)
        imageView.contentMode = .center
    }
    
    public func setupCheckmark(imageView: UIImageView) {
        imageView.tintColor = KMAUIConstants.shared.KMABrightBlueColor
        imageView.image = KMAUIConstants.shared.checkmarkIcon.withRenderingMode(.alwaysTemplate)
    }
    
    // MARK: - Get color from hex string
    
    public func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: - DateFormatter methods
    
    /**
     Get a date string in a short format
     */
    
    public func formatStringShort(date: Date, numOnly: Bool? = nil) -> String {
        if let numOnly = numOnly, numOnly {
            let dateFormatterNum = DateFormatter()
            dateFormatterNum.dateFormat = "dd.MM.yy"
            
            return dateFormatterNum.string(from: date)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
    
    /**
     Get a date string in a short format
     */
    
    public func formatStringMonth(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    /**
     Converts the date into UTC string.
     */
    
    public func UTCStringFrom(date: Date, dateOnly: Bool? = nil) -> String {
        if let utcTimeZone = TimeZone(abbreviation: "UTC") {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = utcTimeZone
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let dateOnly = dateOnly, dateOnly {
                dateFormatter.dateFormat = "yyyy-MM-dd"
            }
            
            return dateFormatter.string(from: date)
        }
        
        return "No date"
    }
    
    /**
     Converts UTC string to date.
     */
    
    public func dateFromUTCString(string: String, dateOnly: Bool? = nil) -> Date {
        if let utcTimeZone = TimeZone(abbreviation: "UTC") {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = utcTimeZone
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if let dateOnly = dateOnly, dateOnly {
                dateFormatter.dateFormat = "yyyy-MM-dd"
            }

            if let dateObject = dateFormatter.date(from: string) {
                return dateObject
            }
        }
        
        return Date()
    }
    
    /**
     Format date
     */
    
    public func dateTime(date: Date, timeOnly: Bool? = nil) -> String {
        let dateFormatter = DateFormatter()
        
        if let timeOnly = timeOnly, timeOnly {
            dateFormatter.dateStyle = .none
        } else {
            dateFormatter.dateStyle = .short
        }
            
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
    
    public func getFirstAndLastDayThisYear() -> (Date, Date) {
        var firstDay = Date()
        var lastDay = Date()
        
        let year = Calendar.current.component(.year, from: Date())
        // Get the first day of the current year
        if let firstOfCurrentYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)) {
            firstDay = firstOfCurrentYear
        }
        // Get the first day of next year
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            if let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear) {
                lastDay = lastOfYear
            }
        }
        
        return (firstDay, lastDay)
    }
    
    // MARK: - Format date for notifications
    
    public func formatReadableDate(date: Date) -> String {
        let currentDate = Date().timeIntervalSince1970
        let notificationDate = date.timeIntervalSince1970
        let difference = currentDate - notificationDate
        var value = 0
        var parameter = ""
        // Check if just now
        if difference < 60 {
            return "Just now"
        } else if difference < 60 * 60 {
            // Calculate minutes ago
            value = Int(difference / 60)
            parameter = "min"
        } else if difference < 24 * 60 * 60 {
            // Calculate hours ago
            value = Int(difference / (60 * 60))
            parameter = "hour"
        } else if difference < 7 * 24 * 60 * 60 {
            // Calculate days ago
            value = Int(difference / (24 * 60 * 60))
            parameter = "day"
        } else if difference < 365 * 24 * 60 * 60 {
            // Calculate month ago
            value = Int(difference / (30 * 24 * 60 * 60))
            parameter = "month"
        } else {
            // Calculate years ago
            value = Int(difference / (365 * 24 * 60 * 60))
            parameter = "year"
        }
        
        // So we won't have situations like 0 month ago or 0 years ago, if the value is 0
        if value == 0 {
            value += 1
        }
        
        if value != 1, parameter != "min" {
            parameter += "s"
        }
        
        return "\(value) \(parameter) ago"
    }
    
    // MARK: - Arrays intersection
    
    public func findIntersection (firstArray : [String], secondArray : [String]) -> [String] {
        var someHash: [String: Bool] = [:]
        
        firstArray.forEach { someHash[$0] = true }
        
        var commonItems = [String]()
        
        secondArray.forEach { item in
            if someHash[item] ?? false {
                commonItems.append(item)
            }
        }
        
        return commonItems
    }
    
    // MARK: - Checking if location is insdie the polygon
    
    /**
     Check if location is inside the polygon
     */
    
    func checkIf(_ location: CLLocationCoordinate2D, areInside polygon: MKPolygon) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: polygon)
        let mapPoint = MKMapPoint(location)
        let polygonPoint = polygonRenderer.point(for: mapPoint)
        
        return polygonRenderer.path.contains(polygonPoint)
    }
    
    /**
     Prepare the polygon from coordinates
     */
    
    func getPolygon(bounds: [CLLocationCoordinate2D]) -> MKPolygon {
        var locations = [CLLocation]()
        
        for location in bounds {
            locations.append(CLLocation(latitude: location.latitude, longitude: location.longitude))
        }
        
        var coordinates = locations.map({(location: CLLocation) -> CLLocationCoordinate2D in return location.coordinate})
        let polygon = MKPolygon(coordinates: &coordinates, count: locations.count)
        
        return polygon
    }
    
    // MARK: - Order
    
    /**
     Order crimes by count
     */
    
    func orderCount(crimes: [[String: AnyObject]]) -> [[String: AnyObject]] {
        return crimes.sorted {
            if let count = $0["count"] as? Int, let countCompare = $1["count"] as? Int {
                return count > countCompare
            }
            
            return false
        }
    }
    
    /**
     Order KMAPerson array by username
     */
    
    public func orderPersonArray(array: [KMAPerson]) -> [KMAPerson] {
        return array.sorted {
            return $0.username.localizedCaseInsensitiveCompare($1.username) == ComparisonResult.orderedAscending
        }
    }
    
    /**
     Order KMAUIPolygoneDataStruct array by username
     */
    
    public func orderPolygoneArray(array: [KMAUIPolygoneDataStruct]) -> [KMAUIPolygoneDataStruct] {
        return array.sorted {
            return $0.googlePlaceRating > $1.googlePlaceRating
        }
    }
    
    /**
     Order KMAPerson array by fullName
     */
    
    public func orderCitizensFullName(array: [KMAPerson]) -> [KMAPerson] {
        return array.sorted {
            return $0.fullName.localizedCaseInsensitiveCompare($1.fullName) == ComparisonResult.orderedAscending
        }
    }
    
    /**
     Order Land Plan array by landName
     */
    
    public func orderLandPlansName(array: [KMAUILandPlanStruct]) -> [KMAUILandPlanStruct] {
        return array.sorted {
            return $0.landName.localizedCaseInsensitiveCompare($1.landName) == ComparisonResult.orderedAscending
        }
    }
    
    /**
     Order KMAPerson array by fullName
     */
    
    public func orderSubLandsName(array: [KMAUISubLandStruct]) -> [KMAUISubLandStruct] {
        return array.sorted {
            return $0.subLandId.localizedCaseInsensitiveCompare($1.subLandId) == ComparisonResult.orderedAscending
        }
    }
    
    /**
     Order KMAUIParkLocation array by id
     */
    
    public func orderParkLocationArray(array: [KMAUIParkLocation]) -> [KMAUIParkLocation] {
        return array.sorted {
            return $0.id < $1.id
        }
    }
    
    // MARK: - Label and button layout
    
    func showItems(label: UILabel, constant1: NSLayoutConstraint, constant2: NSLayoutConstraint, button: UIButton) {
        label.alpha = 1
        constant1.constant = 22
        constant2.constant = 8
        button.alpha = 1
    }
    
    func hideItems(label: UILabel, constant1: NSLayoutConstraint, constant2: NSLayoutConstraint, button: UIButton) {
        label.alpha = 0
        constant1.constant = 0
        constant2.constant = 0
        button.alpha = 0
    }
    
    // MARK: - Highlight the string on search
    
    /**
     Highlight the part of the string.
     */
    
    public func attributedText(text: String, search: String, fontSize: CGFloat, noColor: Bool? = nil) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        let normalString = NSMutableAttributedString(string: text)
        
        if !search.isEmpty {
            let strNumber: NSString = text.lowercased() as NSString
            let range = (strNumber).range(of: search.lowercased())
            
            if let noColor = noColor, noColor {
                normalString.addAttributes(Dictionary(uniqueKeysWithValues: [NSAttributedString.Key.font.rawValue: boldFont].map { key, value in (NSAttributedString.Key(rawValue: key), value)}), range: range)
            } else {
                normalString.addAttributes(Dictionary(uniqueKeysWithValues: [NSAttributedString.Key.font.rawValue: boldFont, NSAttributedString.Key.foregroundColor.rawValue: KMAUIConstants.shared.KMABrightBlueColor].map { key, value in (NSAttributedString.Key(rawValue: key), value)}), range: range)
            }
        }
        
        attributedString.append(normalString)
        
        return attributedString
    }
    
    public func highlightUnderline(words: [String], in str: String, fontSize: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str)
        let highlightAttributes = [NSAttributedString.Key.font: KMAUIConstants.shared.KMAUIRegularFont.withSize(fontSize), NSAttributedString.Key.foregroundColor: KMAUIConstants.shared.KMABrightBlueColor, NSAttributedString.Key.underlineColor: KMAUIConstants.shared.KMABrightBlueColor, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue] as [NSAttributedString.Key : Any]
        
        let nsstr = str as NSString
        var searchRange = NSMakeRange(0, nsstr.length)
        
        for word in words {
            while true {
                let foundRange = nsstr.range(of: word, options: [], range: searchRange)

                if foundRange.location == NSNotFound {
                    break
                }
                
                attributedString.setAttributes(highlightAttributes, range: foundRange)
                
                let newLocation = foundRange.location + foundRange.length
                let newLength = nsstr.length - newLocation
                searchRange = NSMakeRange(newLocation, newLength)
            }
        }
        
        return attributedString
    }
    
    public func highlightStatus(words: [String], in str: String, fontSize: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str)
        let highlightAttributes = [NSAttributedString.Key.font: KMAUIConstants.shared.KMAUIRegularFont.withSize(fontSize), NSAttributedString.Key.foregroundColor: KMAUIConstants.shared.KMAUIGreyTextColor] as [NSAttributedString.Key : Any]
        
        let nsstr = str as NSString
        var searchRange = NSMakeRange(0, nsstr.length)
        
        for word in words {
            while true {
                let foundRange = nsstr.range(of: word, options: [], range: searchRange)

                if foundRange.location == NSNotFound {
                    break
                }
                
                attributedString.setAttributes(highlightAttributes, range: foundRange)
                
                let newLocation = foundRange.location + foundRange.length
                let newLength = nsstr.length - newLocation
                searchRange = NSMakeRange(newLocation, newLength)
            }
        }
        
        return attributedString
    }
    
    /**
     Check if range contains an index
     */
    
    public func checkRange(_ range: NSRange, contain index: Int) -> Bool {
        return index > range.location && index < range.location + range.length
    }
    
    // MARK: - Processing status colors
    
    public func getColor(status: String) -> UIColor {
        var processingColor = UIColor.systemPurple
        
        if status == "Assigned" {
            processingColor = UIColor.systemOrange
        } else if status == "In progress" {
            processingColor = UIColor.systemBlue
        } else if status == "Resolved" {
            processingColor = UIColor.systemGreen
        } else if status == "Rejected" {
            processingColor = UIColor.systemRed
        }
        
        return processingColor
    }
    
    public func getCaseColor(status: String) -> UIColor {
        var processingColor = UIColor.systemPurple
        
        if status == "in progress"  {
            processingColor = UIColor.systemBlue
        } else if status == "approved" {
            processingColor = UIColor.systemGreen
        } else if status == "declined" {
            processingColor = UIColor.systemRed
        }
        
        return processingColor
    }
    
    public func getTrespassCaseColor(status: String) -> UIColor {
        var processingColor = UIColor.systemPurple
        
        if status == "Created" {
            processingColor = KMAUIConstants.shared.KMABrightBlueColor
        } else if status == "Declined" || status == "Outside the Urban Range" {
            processingColor = KMAUIConstants.shared.KMAUIRedProgressColor
        } else if status == "Resolved" {
            processingColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if status == "Awaiting report" || status == "Awaiting decision" || status == "Awaiting penalty payment" || status == "Awaiting Municipality decision" {
            processingColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        }
        
        return processingColor
    }
    
    // MARK: - Upload Body data
    
    /**
     Get items from uploadBody JSON
     */
    
    public func getItemsFrom(uploadBody: String) -> [KMADocumentData] {
        var items = [KMADocumentData]()
        
        if !uploadBody.isEmpty {
            let uploadBodyDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: uploadBody)
            
            if let filesArray = uploadBodyDictionary["files"] as? [AnyObject] {
                for fileObject in filesArray {
                    if let fileObject = fileObject as? [String: String] {
                        var fileValue = KMADocumentData()
                        fileValue.fillFrom(document: fileObject)
                        // Check if status is rejected, then dont't show this file
                        if fileValue.status == "rejected" {
                            print("File `\(fileValue.name)` was rejected by Department.")
                        } else {
                            items.append(fileValue)
                        }
                    }
                }
            }
        }
        
        return items
    }
    
    /**
     Get items from subLandImages JSON
     */
    
    public func getItemsFrom(subLandImages: String, all: Bool? = nil) -> [KMADocumentData] {
        var items = [KMADocumentData]()
        
        if !subLandImages.isEmpty {
            let uploadBodyDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: subLandImages)
            
            if let filesArray = uploadBodyDictionary["files"] as? [AnyObject] {
                for fileObject in filesArray {
                    if let fileObject = fileObject as? [String: String] {
                        var fileValue = KMADocumentData()
                        fileValue.fillFrom(document: fileObject)
                        // If all
                        if let all = all, all {
                            items.append(fileValue)
                        } else {
                            // Check if status is rejected, then dont't show this file
                            if fileValue.status == "rejected" {
                                print("File `\(fileValue.name)` was rejected by Department.")
                            } else {
                                items.append(fileValue)
                            }
                        }
                    }
                }
            }
        }
        
        return items
    }
    
    // MARK: - JSON <-> Dictionary convert methods
    
    /**
     Converting the JSON String into the Dictionary object.
     */
    
    public func jsonToDictionary(jsonText: String) -> [String: AnyObject]  {
        if let data = jsonText.data(using: .utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                return jsonDict!
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return [String: AnyObject]()
    }
    
    /**
     Converting the Dictionary object into the JSON String.
     */
    
    public func dictionaryToJSONData(dict: [String: Any]) -> Data {
        let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        return jsonData!
    }
    
    // MARK: - Tint color for the Ring Process view
    
    public func setupColor(ring: RingProgressView) {
        if ring.progress >= 0.7 {
            ring.startColor = KMAUIConstants.shared.KMAUIGreenProgressColor
            ring.endColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if ring.progress >= 0.4 {
            ring.startColor = KMAUIConstants.shared.KMAUIYellowProgressColor
            ring.endColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        } else {
            ring.startColor = KMAUIConstants.shared.KMAUIRedProgressColor
            ring.endColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
    }
    
    public func lotteryColor(status: LotteryStatus) -> UIColor {
        var statusColor = KMAUIConstants.shared.KMABrightBlueColor
        
        if status == .onApprovement {
            statusColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        } else if status == .approvedToStart {
            statusColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if status == .finished {
            statusColor = KMAUIConstants.shared.KMAUIGreyLineColor
        } else if status == .rejected {
            statusColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
        
        return statusColor
    }
    
    public func subLandColor(status: String) -> UIColor {
        var statusColor = KMAUIConstants.shared.KMABrightBlueColor
        
        if status == "declined" {
            statusColor = KMAUIConstants.shared.KMAUIRedProgressColor
        } else if status == "awaiting payment" || status == "awaiting verification" {
            statusColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        } else if status == "confirmed" {
            statusColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        }
        
        return statusColor
    }
    
    /**
     Higlight words in string for label
     */
    
    public func highlight(words: [String], in str: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: str)
        let highlightAttributes = [NSAttributedString.Key.font: KMAUIConstants.shared.KMAUIBoldFont.withSize(14)]
        
        let nsstr = str as NSString
        var searchRange = NSMakeRange(0, nsstr.length)
        
        for word in words {
            while true {
                let foundRange = nsstr.range(of: word, options: [], range: searchRange)
                if foundRange.location == NSNotFound {
                    break
                }
                
                attributedString.setAttributes(highlightAttributes, range: foundRange)
                
                let newLocation = foundRange.location + foundRange.length
                let newLength = nsstr.length - newLocation
                searchRange = NSMakeRange(newLocation, newLength)
            }
        }
        
        return attributedString
    }
    
    // MARK: - Register cell for tableView / collectionView
    
    public func registerCells(identifiers: [String], tableView: UITableView) {
        for identifier in identifiers {
            registerCell(identifier: identifier, tableView: tableView)
        }
    }
    
    public func registerCell(identifier: String, tableView: UITableView) {
        tableView.register(UINib(nibName: identifier, bundle: Bundle(identifier: "org.cocoapods.KMAUI")), forCellReuseIdentifier: identifier)
    }
    
    public func registerCells(identifiers: [String], collectionView: UICollectionView) {
        for identifier in identifiers {
            registerCell(identifier: identifier, collectionView: collectionView)
        }
    }
    
    public func registerCell(identifier: String, collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: identifier, bundle: Bundle(identifier: "org.cocoapods.KMAUI")), forCellWithReuseIdentifier: identifier)
    }
    
    // MARK: - Get the bar buttons
    
    /**
     Get info button
     */
    
    public func getInfoBarButton() -> UIBarButtonItem {
        // Info button
        let infoButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        return UIBarButtonItem(customView: infoButton)
    }
    
    /**
     Clear bar button
     */
    
    public func getClearBarButton() -> UIBarButtonItem {
        // Clear selection
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 34))
        clearButton.titleLabel?.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        clearButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColor, for: .normal)
        clearButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColor.withAlphaComponent(0.75), for: .highlighted)
        clearButton.setTitle("Clear selection", for: .normal)
        clearButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        clearButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius // 15
        
        return UIBarButtonItem(customView: clearButton)
    }
    
    /**
     Clear bar button
     */
    
    public func getRulesBarButton() -> UIBarButtonItem {
        // Clear selection
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 74, height: 34))
        clearButton.titleLabel?.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        clearButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColor, for: .normal)
        clearButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColor.withAlphaComponent(0.75), for: .highlighted)
        clearButton.setTitle("  Rules  ", for: .normal)
        clearButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        clearButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius // 15
        
        return UIBarButtonItem(customView: clearButton)
    }
    
    /**
     Filter bar button
     */
    
    public func getFilterBarButton() -> UIBarButtonItem {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 74, height: 34))
        filterButton.titleLabel?.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        filterButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
        filterButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor.withAlphaComponent(0.75), for: .highlighted)
        filterButton.setTitle("Filter", for: .normal)
        filterButton.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.25)
        filterButton.setImage(KMAUIConstants.shared.filterBarIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        filterButton.tintColor = KMAUIConstants.shared.KMAUITextColor
        filterButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        filterButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        filterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        return UIBarButtonItem(customView: filterButton)
    }
    
    /**
     Show on map bar button
     */
    
    public func getShowOnMapBarButton() -> UIBarButtonItem {
        let showOnMapButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 34))
        showOnMapButton.titleLabel?.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        showOnMapButton.setTitleColor(UIColor.white, for: .normal)
        showOnMapButton.setTitleColor(UIColor.white.withAlphaComponent(0.75), for: .highlighted)
        showOnMapButton.setTitle("Show on map", for: .normal)
        showOnMapButton.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        showOnMapButton.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        return UIBarButtonItem(customView: showOnMapButton)
    }
    
    /**
     Show on map bar button
     */
    
    public func getShowOnMapWithImageBarButton() -> UIBarButtonItem {
        // Background
        let buttonBgView = UIView(frame: CGRect(x: 0, y: 0, width: 152, height: 32))
        buttonBgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        buttonBgView.layer.cornerRadius = 6
        buttonBgView.clipsToBounds = true
        
        // Image
        let imageView = UIImageView(frame: CGRect(x: 16, y: 8, width: 16, height: 16))
        imageView.image = KMAUIConstants.shared.mapIcon.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = KMAUIConstants.shared.KMAUITextColor
        
        // Label
        let label = UILabel(frame: CGRect(x: 45, y: 8, width: 91, height: 17))
        label.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
        label.textColor = KMAUIConstants.shared.KMAUITextColor
        label.text = "Show on map"
        
        // Setup subviews
        buttonBgView.addSubview(imageView)
        buttonBgView.addSubview(label)
        
        return UIBarButtonItem(customView: buttonBgView)
    }
    
    // MARK: - Hide the navigation bar line
    
    public func hideBarLine(navigationController: UINavigationController) {
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.layoutIfNeeded()
    }
    
    public func restoreBarLine(navigationController: UINavigationController) {
        navigationController.navigationBar.shadowImage = nil
        navigationController.navigationBar.layoutIfNeeded()
    }
    
    // MARK: - Get cities from Parse for the area
    
    /**
    Get the city in bounds area
    */
    
    public func getCities(_ sw: CLLocationCoordinate2D, _ ne: CLLocationCoordinate2D, _ limit: Int, completion: @escaping (_ cities: [KMAUIItemPerformance])->()) {
        let query = PFQuery(className: "KMACity")
        // Getting visible cities
        query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: sw.latitude, longitude: sw.longitude), toNortheast: PFGeoPoint(latitude: ne.latitude, longitude: ne.longitude))
        // Should be active in database
        query.whereKey("isActive", equalTo: true)
        // Should be from database hude
//        query.whereKey("fromDatabaseHub", equalTo: true)
//         Should have a population data
        // Order cities by population, largest on top
        query.order(byDescending: "population")
        // Include the country details
        query.includeKey("country")
        // Limit to 20 largest cities
        query.limit = limit
        
        query.findObjectsInBackground { (cityArray, error) in
            var cities = [KMAUIItemPerformance]()
            
            if let error = error {
                print(error.localizedDescription)
            } else if let cityArray = cityArray {
                print("City array: \(cityArray.count)")
                
                for city in cityArray {
                    if let name = city["nameE"] as? String, let community = city["community"] as? Int, let service = city["service"] as? Int, let security = city["security"] as? Int, let location = city["location"] as? PFGeoPoint {
                        let cityValue = KMAUIItemPerformance(performanceArray: [community, service, security], itemName: name, isOn: false, location: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                        cities.append(cityValue)
                    }
                }
                
                /**
                 objectId
                 createdAt
                 updatedAt
                 nameE
                 cityId
                 isCapital
                 community
                 service
                 security
                 population
                 location
                 adminCode
                 
                 country
                 emoji
                 name
                 code
                 */
            }
            
            completion(cities)
        }
    }
    
    // MARK: - Get empty cell
    
    public func getEmptyCell() -> UITableViewCell {
        let emptyCell = UITableViewCell()
        emptyCell.backgroundColor = UIColor.clear
        emptyCell.selectionStyle = .none
        
        return emptyCell
    }
    
    // MARK: - Screen size
    
    public func getScreenSize () -> (description: String, size: CGRect) {
        let size = UIScreen.main.bounds
        let str = "SCREEN SIZE:\nwidth: \(size.width)\nheight: \(size.height)"
        return (str, size)
    }
    
    public func getApplicationSize () -> (description: String, size: CGRect) {
        let size = UIApplication.shared.windows[0].bounds
        let str = "\n\nAPPLICATION SIZE:\nwidth: \(size.width)\nheight: \(size.height)"
        return (str, size)
    }
    
    // MARK: - Get width and items count for collectionView
    
    public func getCollectionViewItemWidth(view: UIView) -> CGFloat {
        var itemsCount: CGFloat = 2
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let widthProportion = KMAUIUtilities.shared.getApplicationSize().size.width / KMAUIUtilities.shared.getScreenSize().size.width
            
            if KMAUIUtilities.shared.getScreenSize().size == KMAUIUtilities.shared.getApplicationSize().size {
                if UIDevice.current.orientation.isLandscape {
                    itemsCount = 3
                } else {
                    itemsCount = 2
                }
            } else {
                if widthProportion < 0.4 {
                    itemsCount = 1
                } else {
                    itemsCount = 2
                }
            }
        } else {
            if UIDevice.current.orientation.isLandscape {
                itemsCount = 2
            } else {
                itemsCount = 1
            }
        }
        
        var itemWidth = (view.frame.width - (itemsCount + 1) * 12) / itemsCount
        
        if UIDevice.current.userInterfaceIdiom == .phone, UIDevice.current.orientation.isLandscape {
            itemWidth -= 34
        }
        
        return itemWidth
    }
    
    // MARK: - Download file from URL
    
    public func downloadfile(urlString: String, fileName: String, uploadId: String, hideLoading: Bool? = nil, completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        if let itemUrl = URL(string: urlString) {
            // then lets create your document folder url
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent("\(uploadId)_\(fileName)")
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                debugPrint("The file already exists at path")
                completion(true, destinationUrl)
            } else {
                // Displaying the loading alert
                if let hideLoading = hideLoading, hideLoading {
                    // No need to show the loading alert
                } else {
                    KMAUIUtilities.shared.startLoading(title: "Loading...")
                }
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: itemUrl, completionHandler: { (location, response, error) -> Void in
                    guard let tempLocation = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                        DispatchQueue.main.async {
                            // Displaying the loading alert
                            if let hideLoading = hideLoading, hideLoading {
                                // No need to show the loading alert
//                                print("File moved to documents folder")
                                completion(true, destinationUrl)
                            } else {
                                KMAUIUtilities.shared.stopLoadingWith { (loaded) in
//                                    print("File moved to documents folder")
                                    completion(true, destinationUrl)
                                }
                            }
                        }
                    } catch let error as NSError {
                        DispatchQueue.main.async {
                            // Displaying the loading alert
                            if let hideLoading = hideLoading, hideLoading {
                                // No need to show the loading alert
                                completion(false, nil)
                            } else {
                                KMAUIUtilities.shared.stopLoadingWith { (loaded) in
                                    print(error.localizedDescription)
                                    completion(false, nil)
                                }
                            }
                        }
                    }
                }).resume()
            }
        }
    }
    
    // MARK: Calculate squaree for location array
    
    // CLLocationCoordinate2D uses degrees but we need radians
    public func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180
    }

    public func regionArea(locations: [CLLocation]) -> Double {
        let kEarthRadius = 6378137.0

        guard locations.count > 2 else { return 0 }
        var area = 0.0

        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]

            area += radians(degrees: p2.coordinate.longitude - p1.coordinate.longitude) * (2 + sin(radians(degrees: p1.coordinate.latitude)) + sin(radians(degrees: p2.coordinate.latitude)) )
        }

        area = -(area * kEarthRadius * kEarthRadius / 2)

        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
    
    public func regionAreaLocation(locations: [CLLocationCoordinate2D]) -> Double {
        let kEarthRadius = 6378137.0
        
        guard locations.count > 2 else { return 0.0 }
        var area = 0.0
        
        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]
            
            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return Double(Int(max(area, -area) * 100)) / 100 // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
    
    // MARK: - Get color for Sub Land type
    
    public func getColor(subLandType: String) -> UIColor {
        let subLandType = subLandType.lowercased()
        
        if subLandType.contains("commercial") {
            return KMAUIConstants.shared.KMAUISubLandCommercialColor
        } else if subLandType.contains("services") {
            return KMAUIConstants.shared.KMAUISubLandServicesColor
        } else if subLandType.contains("sale") {
            return KMAUIConstants.shared.KMAUISubLandSaleColor
        } else if subLandType.contains("park") {
            return KMAUIConstants.shared.KMAUIParkColor
        }
        
        return KMAUIConstants.shared.KMAUISubLandLotteryColor
    }
    
    public func getTextColor(subLandType: String) -> UIColor {
        let subLandType = subLandType.lowercased()
        
        if subLandType.contains("lottery") {
            return UIColor.white
        }
        
        return UIColor.black
    }
    
    // MARK: - Prepare sub land corners
    
    public func getSubLandDictionary(subLand: KMAUISubLandStruct) -> [String: AnyObject] {
        let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: subLand.subLandArea)
        var subLandDict = [String: AnyObject]()
                
        if let features = dict["features"] as? [AnyObject], !features.isEmpty {
            let feature = features[0]
            
            if let feature = feature as? [AnyObject], !feature.isEmpty {
                // If extra array added
                let subLandFeature = feature[0]
                
                if let subLandFeature = subLandFeature as? [String: AnyObject] {
                    subLandDict = subLandFeature
                }
            } else if let feature = feature as? [String: AnyObject] {
               subLandDict = feature
            }
        }
        
        return subLandDict
    }
    
    public func getCorners(subLand: KMAUISubLandStruct? = nil, dictionary: [String: AnyObject]? = nil) -> [String: AnyObject] {
        var dict = [String: AnyObject]()
        
        // Sub land received
        if let subLand = subLand {
            dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: subLand.subLandArea)
        }
        
        // Dict received
        if let dictionary = dictionary {
            dict = dictionary
        }
        
        var subLandDict = [String: AnyObject]()
        var coordinates = [[Double]]()
                
        if let features = dict["features"] as? [AnyObject], !features.isEmpty {
            let feature = features[0]
            
            if let feature = feature as? [AnyObject], !feature.isEmpty {
                // If extra array added
                let subLandFeature = feature[0]
                
                if let subLandFeature = subLandFeature as? [String: AnyObject] {
                    subLandDict = subLandFeature
                }
            } else if let feature = feature as? [String: AnyObject] {
               subLandDict = feature
            }
        }
        
        if let geometry = subLandDict["geometry"] as? [String: AnyObject], let coordinatesArray = geometry["coordinates"] as? [AnyObject] {
            if let array = coordinatesArray as? [[Double]] {
                coordinates = array
            }
        }
        
        // Prepare corners
        var corners = [AnyObject]()
        
        for i in 0..<coordinates.count {
            if i + 1 < coordinates.count {
                let coordinate1 = coordinates[i]
                let coordinate2 = coordinates[i + 1]
                corners.append(contentsOf: getCorner(location1: coordinate1, location2: coordinate2))
            }
        }

        // Prepare coordinates geojson
        var featureCollection = [String: AnyObject]()
        featureCollection["type"] = "FeatureCollection" as AnyObject
        featureCollection["features"] = corners as AnyObject
        
        return featureCollection
    }
    
    public func getCorner(location1: [Double], location2: [Double]) -> [AnyObject] {
        let coordinateValue1 = CLLocation(latitude: location1[1], longitude: location1[0])
        let coordinateValue2 = CLLocation(latitude: location2[1], longitude: location2[0])
        
        let coordinateObject1 = CLLocationCoordinate2D(latitude: location1[1], longitude: location1[0])
        let coordinateObject2 = CLLocationCoordinate2D(latitude: location2[1], longitude: location2[0])

        let bearingLeft = getBearingBetweenTwoPoints1(point1: coordinateValue1, point2: coordinateValue2)
        let angleLeft = Double.pi * bearingLeft / 180 // calculating angle from the degrees
        
        let bearingRight = getBearingBetweenTwoPoints1(point1: coordinateValue2, point2: coordinateValue1)
        let angleRight = Double.pi * bearingRight / 180 // calculating angle from the degrees
        
        let distance = coordinateValue1.distance(from: coordinateValue2) / 4
        
        let pointLeft = coordinateObject1.shift(byDistance: distance, azimuth: angleLeft)
        let lineLeft = [location1, [pointLeft.longitude, pointLeft.latitude]] as AnyObject
        
        let pointRight = coordinateObject2.shift(byDistance: distance, azimuth: angleRight)
        let lineRight = [location2, [pointRight.longitude, pointRight.latitude]] as AnyObject
        
        var dictLeft = [String: AnyObject]()
        dictLeft["type"] = "Feature" as AnyObject
        var geomertyLeft = [String: AnyObject]()
        geomertyLeft["type"] = "LineString" as AnyObject
        geomertyLeft["coordinates"] = lineLeft
        dictLeft["geometry"] = geomertyLeft as AnyObject
        
        var dictRight = [String: AnyObject]()
        dictRight["type"] = "Feature" as AnyObject
        var geomertyRight = [String: AnyObject]()
        geomertyRight["type"] = "LineString" as AnyObject
        geomertyRight["coordinates"] = lineRight
        dictRight["geometry"] = geomertyRight as AnyObject

        return [dictLeft as AnyObject, dictRight as AnyObject]
    }
    
    public func getDottedLine(location1: [Double], location2: [Double]) -> [AnyObject] {
        let coordinateValue1 = CLLocation(latitude: location1[1], longitude: location1[0])
        let coordinateValue2 = CLLocation(latitude: location2[1], longitude: location2[0])
        
        let coordinateObject1 = CLLocationCoordinate2D(latitude: location1[1], longitude: location1[0])

        let bearingLeft = KMAUIUtilities.shared.getBearingBetweenTwoPoints1(point1: coordinateValue1, point2: coordinateValue2)
        let angleLeft = Double.pi * bearingLeft / 180 // calculating angle from the degrees
                
        let distance = coordinateValue1.distance(from: coordinateValue2)
        var distanceSegment: Double = 4 // 4 meters each segment as default
        var segmentsCount = distance / distanceSegment
        
        if Int(segmentsCount) % 2 == 0 {
            segmentsCount += 1
        }
        
        distanceSegment = distance / segmentsCount
        var lineArray = [AnyObject]()
        
        for i in 0..<Int(segmentsCount) {
            if i % 2 == 0 {
                let pointOne = coordinateObject1.shift(byDistance: distanceSegment * Double(i), azimuth: angleLeft)
                let pointTwo = coordinateObject1.shift(byDistance: distanceSegment * Double(i + 1), azimuth: angleLeft)
                let lineItem = [[pointOne.longitude, pointOne.latitude], [pointTwo.longitude, pointTwo.latitude]] as AnyObject
                
                var dictLeft = [String: AnyObject]()
                dictLeft["type"] = "Feature" as AnyObject
                var geomertyLeft = [String: AnyObject]()
                geomertyLeft["type"] = "LineString" as AnyObject
                geomertyLeft["coordinates"] = lineItem
                dictLeft["geometry"] = geomertyLeft as AnyObject
                
                lineArray.append(dictLeft as AnyObject)
            }
        }
        
        return lineArray
    }
    
    public func getDottedLines(dict: [String: AnyObject]) -> [String: AnyObject] {
        var subLandDict = [String: AnyObject]()
        var coordinates = [[Double]]()
        
        if let features = dict["features"] as? [AnyObject], !features.isEmpty {
            let feature = features[0]
            
            if let feature = feature as? [AnyObject], !feature.isEmpty {
                // If extra array added
                let subLandFeature = feature[0]
                
                if let subLandFeature = subLandFeature as? [String: AnyObject] {
                    subLandDict = subLandFeature
                }
            } else if let feature = feature as? [String: AnyObject] {
                subLandDict = feature
            }
        }
        
        if let geometry = subLandDict["geometry"] as? [String: AnyObject], let coordinatesArray = geometry["coordinates"] as? [AnyObject] {
            if let array = coordinatesArray as? [[Double]] {
                coordinates = array
            }
        }
        
        // Prepare corners
        var corners = [AnyObject]()
        
        for i in 0..<coordinates.count {
            if i + 1 < coordinates.count {
                let coordinate1 = coordinates[i]
                let coordinate2 = coordinates[i + 1]
                corners.append(contentsOf: getDottedLine(location1: coordinate1, location2: coordinate2))
            }
        }
        
        // Prepare coordinates geojson
        var featureCollection = [String: AnyObject]()
        featureCollection["type"] = "FeatureCollection" as AnyObject
        featureCollection["features"] = corners as AnyObject
        
        return featureCollection
    }
    
    public func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    public func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }

    public func getBearingBetweenTwoPoints1(point1 : CLLocation, point2 : CLLocation) -> Double {
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)

        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radians: radiansBearing)
    }
    
    // MARK: - Download image to display it with the QuickLook
    
    public func quicklookPreview(urlString: String, fileName: String, uniqueId: String, hideLoading: Bool? = nil, completion: @escaping (_ previewItem: NSURL)->()) {
        KMAUIUtilities.shared.downloadfile(urlString: urlString, fileName: fileName, uploadId: uniqueId, hideLoading: hideLoading) { (success, url) in
            DispatchQueue.main.async { // Must be performed on the main thread
                if success {
                    if let fileURL = url as NSURL? {
                        completion(fileURL)
                    }
                } else {
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error loading file \(fileName). Please try again.") { (done) in }
                    print("Error downloading file from: \(String(describing: urlString))")
                }
            }
        }
    }
    
    // MARK: - Prepare document to upload
    
    public func prepareDocument(info: [UIImagePickerController.InfoKey : Any]? = nil, userLocation: CLLocationCoordinate2D? = nil, url: URL? = nil, completion: @escaping (_ pickedDocument: KMADocumentData, _ name: String, _ description: String, _ previewImage: UIImage)->()) {
        if let info = info, let userLocation = userLocation {
            prepareDocumentObject(info: info, userLocation: userLocation) { (pickedDocument) in
                self.uploadDocument(pickedDocument: pickedDocument) { (documentToUpload, documentName, documentDescription, documentPreview) in
                    completion(documentToUpload, documentName, documentDescription, documentPreview)
                }
            }
        } else if let url = url {
            prepareDocumentObject(url: url) { (pickedDocument) in
                self.uploadDocument(pickedDocument: pickedDocument) { (documentToUpload, documentName, documentDescription, documentPreview) in
                    completion(documentToUpload, documentName, documentDescription, documentPreview)
                }
            }
        }
    }
    
    func uploadDocument(pickedDocument: KMADocumentData, completion: @escaping (_ pickedDocument: KMADocumentData, _ name: String, _ description: String, _ previewImage: UIImage)->()) {
        let documentData = KMAUIUtilities.shared.getItemData(documentObject: pickedDocument)
        
        if pickedDocument.hasLocation {
            KMAUIUtilities.shared.getAddressFromApple(location: pickedDocument.location) { (addressString, addressDict, regionId) in
                var pickedDocumentWithAddress = pickedDocument
                pickedDocumentWithAddress.address = addressString
                self.renameDocument(name: documentData.1, description: "", pickedDocument: pickedDocument) { (pickedDocumentUpdated, nameValue, descriptionValue) in
                    self.prepareUpload(pickedDocument: pickedDocumentUpdated, name: nameValue, description: descriptionValue) { (documentToUpload, documentName, documentDescription, documentPreview) in
                        completion(documentToUpload, documentName, documentDescription, documentPreview)
                    }
                }
            }
        } else {
            renameDocument(name: documentData.1, description: "", pickedDocument: pickedDocument) { (pickedDocumentUpdated, nameValue, descriptionValue) in
                self.prepareUpload(pickedDocument: pickedDocumentUpdated, name: nameValue, description: descriptionValue) { (documentToUpload, documentName, documentDescription, documentPreview) in
                    completion(documentToUpload, documentName, documentDescription, documentPreview)
                }
            }
        }
    }
    
    func prepareUpload(pickedDocument: KMADocumentData, name: String, description: String, completion: @escaping (_ pickedDocument: KMADocumentData, _ name: String, _ description: String, _ previewImage: UIImage)->()) {
        let documentData = KMAUIUtilities.shared.getItemData(documentObject: pickedDocument)
        
        if documentData.2 == "Document", documentData.3.lowercased() != "pdf", let url = pickedDocument.url {
            KMAUIUtilities.shared.generateQuickLookPreview(url: url) { (previewImage) in
                completion(pickedDocument, name + "." + documentData.3.lowercased(), description, previewImage)
            }
        } else {
            completion(pickedDocument, name + "." + documentData.3.lowercased(), description, UIImage())
        }
    }
    
    func renameDocument(name: String, description: String, pickedDocument: KMADocumentData, completion: @escaping (_ pickedDocument: KMADocumentData, _ name: String, _ description: String)->()) {
        let renameAlert = UIAlertController(title: "Name the file", message: "Please enter the valid name and description for the file:", preferredStyle: .alert)
        renameAlert.view.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        
        renameAlert.addAction(UIAlertAction(title: "Start upload", style: .default, handler: { (action) in
            if let textFields = renameAlert.textFields, textFields.count >= 2 {
                if let nameValue = textFields[0].text, let descriptionValue = textFields[1].text {
                    if nameValue.isEmpty {
                        KMAUIUtilities.shared.globalAlert(title: "Warning", message: "Please enter a file name") { (done) in
                            self.renameDocument(name: nameValue, description: descriptionValue, pickedDocument: pickedDocument) { (updatedPickedDocument, updatedName, updatedDescription) in
                                completion(updatedPickedDocument, updatedName, updatedDescription)
                            }
                        }
                    } else {
                        completion(pickedDocument, nameValue, descriptionValue)
                    }
                }
            }
        }))
        
        renameAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in }))
        
        renameAlert.addTextField { (textField) in
            textField.placeholder = "Enter file name..."
            textField.text = name
            textField.autocapitalizationType = .sentences
            textField.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
            textField.clearButtonMode = .whileEditing
        }
        
        renameAlert.addTextField { (textField) in
            textField.placeholder = "Enter file description..."
            textField.text = description
            textField.autocapitalizationType = .sentences
            textField.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
            textField.clearButtonMode = .whileEditing
        }
        
        KMAUIUtilities.shared.displayAlert(viewController: renameAlert)
    }
    
    func prepareDocumentObject(info: [UIImagePickerController.InfoKey : Any], userLocation: CLLocationCoordinate2D, completion: @escaping (_ pickedDocument: KMADocumentData)->()) {
        var hasCreatedAt = false
        var createdAt = Date()
        var hasLocation = false
        var location = CLLocationCoordinate2D()
        
        // Getting metadata from camera
        if let _ = info[UIImagePickerController.InfoKey.mediaMetadata] as? NSDictionary {
            if !userLocation.isEmpty {
                hasLocation = true
                location = userLocation
            }
            
            createdAt = Date()
            hasCreatedAt = true
        }
        
        if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset {
            if let itemCreatedAt = asset.creationDate {
                print("Item created at: \(itemCreatedAt)")
                hasCreatedAt = true
                createdAt = itemCreatedAt
            }

            if let itemLocation = asset.location {
                print("Item location: \(itemLocation.coordinate.latitude), \(itemLocation.coordinate.longitude)")
                hasLocation = true
                location = CLLocationCoordinate2D(latitude: itemLocation.coordinate.latitude, longitude: itemLocation.coordinate.longitude)
            }
        }
        
        var pickedDocument = KMADocumentData()
        pickedDocument.hasCreatedAt = hasCreatedAt
        pickedDocument.captureDate = createdAt
        pickedDocument.hasLocation = hasLocation
        pickedDocument.location = location

        // Getting the video or image from Camera and Photo Library picker, saving these items into the local array as a structure
        if let videoURL = info[.mediaURL] as? URL {
            pickedDocument.type = "Video"
            pickedDocument.name = videoURL.lastPathComponent
            pickedDocument.url = videoURL
            completion(pickedDocument)
        } else if let photo = info[.originalImage] as? UIImage {
            pickedDocument.type = "Image"
            
            let uuidString = UUID().uuidString.suffix(8)
            var imgName = "Captured_image__\(uuidString).JPG"
            
            if let imageUrl = info[.imageURL] as? URL {
                imgName = imageUrl.lastPathComponent
            }
            
            let documentDirectory = NSTemporaryDirectory()
            let localPath = documentDirectory.appending(imgName)
            
            if let data = photo.jpegData(compressionQuality: 0.5) as NSData? {
                data.write(toFile: localPath, atomically: true)
                let photoURL = URL.init(fileURLWithPath: localPath)
                pickedDocument.url = photoURL
            }
            
            // Save the photo name
            pickedDocument.name = imgName
            pickedDocument.image = photo
            
            completion(pickedDocument)
        } else {
            KMAUIUtilities.shared.stopLoadingWith { (done) in
                KMAUIUtilities.shared.globalAlert(title: "Error", message: "Please select an image or video file.") { (loaded) in }
            }
        }
    }
    
    func prepareDocumentObject(url: URL, completion: @escaping (_ pickedDocument: KMADocumentData)->()) {
        // Creating the pickedDocument structure to store the data for a document
        var pickedDocument = KMADocumentData()
        pickedDocument.type = "Document"
        pickedDocument.name = url.lastPathComponent
        pickedDocument.url = url
        
        if let attributes = try? FileManager.default.attributesOfItem(atPath: url.path) as [FileAttributeKey: Any],
            let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
            pickedDocument.captureDate = creationDate
            pickedDocument.hasCreatedAt = true
        }

        // Adding the data into the local array
        completion(pickedDocument)
    }
    
    /**
     Get the item name, selectio
    */
    
    public func getItemData(documentObject: KMADocumentData) -> (UIImage, String, String, String, UIImage) {
        var imageValue = UIImage()
        var nameValue = ""
        var typeValue = documentObject.type
        var fileExtensionValue = ""
        
        if let defaultImage = UIImage(named: "\(typeValue)Icon")?.withRenderingMode(.alwaysTemplate) {
            imageValue = defaultImage
        }
        
        // Get an image name
        let uuidString = UUID().uuidString.suffix(8)
        
        let filename: NSString = NSString(string: documentObject.name)
            
        // Get file extension for images and video
        if !filename.pathExtension.isEmpty {
            fileExtensionValue = filename.pathExtension.uppercased()
        }
        
        // Set the preview image and file name
        if typeValue == "Image" {
            // Get a preview image
            if let urlValue = documentObject.url, let imageObject = UIImage(contentsOfFile: urlValue.path) {
                imageValue = imageObject
            } else if documentObject.image.size.width > 0 {
                imageValue = documentObject.image
            }
            
            if documentObject.name.isEmpty {
                nameValue = "Captured_image_\(uuidString)"
            } else {
                nameValue = documentObject.name
            }
        } else if typeValue == "Video" {
            // Get a video file name
            if documentObject.name.isEmpty {
                nameValue = "Captured_video_\(uuidString)"
            } else {
                nameValue = documentObject.name
            }
            
            // Get a preview image from video
            if let videoURL = documentObject.url, let thumbnailImage = KMAUIUtilities.shared.getThumbnailImage(forUrl: videoURL) {
                imageValue = thumbnailImage
            }
        } else if typeValue == "Document" {
            // Get a document name
            if documentObject.name.isEmpty {
                nameValue = "Files_document_\(uuidString)"
            } else {
                nameValue = documentObject.name
            }
            
            // Get a preview image
            if let documentURL = documentObject.url {
                if let thumbnailImage = KMAUIUtilities.shared.getThumbnailImage(forUrl: documentURL) {
                    // If video
                    imageValue = thumbnailImage
                    typeValue = "Video"
                } else if let imageObject = UIImage(contentsOfFile: documentURL.path) {
                    // If image
                    imageValue = imageObject
                    typeValue = "Image"
                } else {
                    let filename: NSString = NSString(string: documentObject.name)

                    if !filename.pathExtension.isEmpty, let emptyDocumentIcon = UIImage(named: "documentEmptyIcon")?.withRenderingMode(.alwaysTemplate) {
                        imageValue = emptyDocumentIcon
                        fileExtensionValue = filename.pathExtension.uppercased()
                        
                        // Get the preview for a pdf file
                        if fileExtensionValue.lowercased() == "pdf",
                            let pdfPreview = generatePdfThumbnail(of: CGSize(width: 600, height: 600), for: documentURL, atPage: 0) {
                                imageValue = pdfPreview
                        }
                    }
                }
            }
        }
        
        let originalImage = imageValue
        
        if imageValue.size.width > 0 {
            if typeValue == "Document" {
                imageValue = resizeImage(image: imageValue, targetSize: CGSize(width: 600, height: 600)).withRenderingMode(.alwaysTemplate)
            } else {
                imageValue = resizeImage(image: imageValue, targetSize: CGSize(width: 600, height: 600))
            }
        }
        
        if !nameValue.isEmpty, !fileExtensionValue.isEmpty, nameValue.lowercased().contains(".\(fileExtensionValue.lowercased())") {
            nameValue = String(nameValue.prefix(nameValue.count - 1 - fileExtensionValue.count))
        }
        
        return (imageValue, nameValue, typeValue, fileExtensionValue, originalImage)
    }
    
    // MARK: - Get thumbnail image from video
    
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true // to avoid vertical videos are being rotated
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func generatePdfThumbnail(of thumbnailSize: CGSize , for documentUrl: URL, atPage pageIndex: Int) -> UIImage? {
        let pdfDocument = PDFDocument(url: documentUrl)
        let pdfDocumentPage = pdfDocument?.page(at: pageIndex)
        return pdfDocumentPage?.thumbnail(of: thumbnailSize, for: PDFDisplayBox.trimBox)
    }
    
    public func generateQuickLookPreview(url: URL, completion: @escaping (_ image: UIImage)->()) {
        if #available(iOS 13.0, *) {
            let size: CGSize = CGSize(width: 600, height: 600)
            let scale = UIScreen.main.scale
            
            // Create the thumbnail request.
            let request = QLThumbnailGenerator.Request(fileAt: url,
                                                       size: size,
                                                       scale: scale,
                                                       representationTypes: .thumbnail)
            
            // Retrieve the singleton instance of the thumbnail generator and generate the thumbnails.
            let generator = QLThumbnailGenerator.shared
            generator.generateRepresentations(for: request) { (thumbnail, type, error) in
                DispatchQueue.main.async {
                    if thumbnail == nil || error != nil {
                        // Handle the error case gracefully.
                        completion(UIImage())
                    } else if let thumbnail = thumbnail {
                        // Display the thumbnail that you created.
                        completion(thumbnail.uiImage)
                    }
                }
            }
        } else {
            completion(UIImage())
        }
    }
    
    // MARK: - Resize image for profile
    
    public func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        
        if (widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    /**
     Geocode address from Apple
     */
    
    public func getAddressFromApple(location: CLLocationCoordinate2D, completion: @escaping (_ address: String, _ dict: [String: String], _ regionId: String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: location.latitude, longitude: location.longitude), preferredLocale: Locale(identifier: "en")) { (placemarks, error) in
            var regionId = ""
            
            if let error = error {
                print("Error getting the address from location: \(error.localizedDescription).")
                completion("Address not available", [String: String](), regionId)
            } else if let placemark = placemarks?.first {
                var addressString = ""
                var city = ""
                
                if let locality = placemark.locality {
                    city = locality
                }
                
                var adminArea = ""
                
                if let admin = placemark.administrativeArea {
                    adminArea = admin
                }
                
                var subAdminArea = ""
                
                if let subAdmin = placemark.subAdministrativeArea {
                    subAdminArea = subAdmin
                }
                
                var country = ""
                
                if let countryValue = placemark.country {
                    country = countryValue
                }
                
                print("City: \(city), adminArea: \(adminArea), subAdminArea: \(subAdminArea), country: \(country)")
                
                if let mailingAddress = placemark.mailingAddress, !mailingAddress.isEmpty {
                    addressString = mailingAddress.replacingOccurrences(of: "\n", with: ", ")
                } else {
                    addressString = "Address not available"
                }
                
                let dict = ["city": city, "subAdmin": subAdminArea, "admin": adminArea, "country": country]
                
                print("Apple Maps address: `\(addressString)`, dict: \(dict)")
                
                if let regionIdValue = KMAUIConstants.shared.regionsDict[adminArea] {
                    regionId = regionIdValue
                }
                
                completion(addressString, dict, regionId)
            } else {
                completion("Address not available", [String: String](), regionId)
            }
        }
    }
    
    /**
     Recognized rows
     */
    
    public func recognizedRows(dataDict: [String: AnyObject]) -> [KMADocumentData] {
        var rows = [KMADocumentData]()
        
        let orderedKeys = ["area_id", "area_name", "citizen_id", "citizen_name"]
        
        for key in orderedKeys {
            var documentItem = KMADocumentData()
            documentItem.type = key.replacingOccurrences(of: "_", with: " ").capitalized.replacingOccurrences(of: " Id", with: " ID")
            
            if let value = dataDict[key] as? String {
                documentItem.name = value
            } else {
                documentItem.name = "Null"
            }
            
            rows.append(documentItem)
        }
        
        // Extra values
        for item in dataDict {
            if !item.key.isEmpty, !orderedKeys.contains(item.key) {
                var documentItem = KMADocumentData()
                documentItem.type = item.key.replacingOccurrences(of: "_", with: " ").capitalized.replacingOccurrences(of: " Id", with: " ID")
                
                if let value = item.value as? String {
                    documentItem.name = value
                } else {
                    documentItem.name = "Null"
                }
                
                rows.append(documentItem)
            }
        }
        
        return rows
    }
    
    // MARK: - Placeholder random data
    
    public func prepareMinistryComment(name: String, isApproved: Bool) -> String {
        let randomDecision = Int.random(in: 0..<3)
        if isApproved {
            return KMAUIConstants.shared.placeholderApprovedDecisions[randomDecision].replacingOccurrences(of: "*departmentName*", with: name)
        } else {
            return KMAUIConstants.shared.placeholderRejectedDecisions[randomDecision].replacingOccurrences(of: "*departmentName*", with: name)
        }
    }
    
    public func prepareMinistryFile() -> String {
        let randomDecision = Int.random(in: 0..<4)
        
        let fileBodyDict = ["files": [KMAUIConstants.shared.placeholderFilesArray[randomDecision]]]
        let jsonFileBodyData = KMAUIUtilities.shared.dictionaryToJSONData(dict: fileBodyDict)
        var fileBody = ""
        
        // JSON String for Parse
        if let jsonFileBodyString = String(data: jsonFileBodyData, encoding: .utf8) {
            fileBody = jsonFileBodyString
        }
        
        return fileBody
    }
    
    // MARK: - Get unread notifications count
    
    public func getUnreadNotificationCounts() -> (Int, Int, Int, Int) {
        var landLotteryCounts = 0
        var landCasesCounts = 0
        var trespassCasesCount = 0
        var generalCounts = 0
        
        // Land lottery
        for notification in KMAUIConstants.shared.landLotteryNotifications {
            if !notification.read {
                landLotteryCounts += 1
            }
        }
        
        // Land cases count
        for notification in KMAUIConstants.shared.landCasesNotifications {
            if !notification.read {
                landCasesCounts += 1
            }
        }
        
        // Trespass cases count
        for notification in KMAUIConstants.shared.trespassCasesNotifications {
            if !notification.read {
                trespassCasesCount += 1
            }
        }
        
        // General notifications count
        for notification in KMAUIConstants.shared.generalNotifications {
            if !notification.read {
                generalCounts += 1
            }
        }
                
        return (landLotteryCounts, landCasesCounts, trespassCasesCount, generalCounts)
    }
    
    // MARK: - KMA Datasets from data.gov.sa
    
    public func getDatasets(regionId: String, completion: @escaping (_ datasetsCount: Int, _ datasets: [KMAUIDataset])->()) {
        let query = PFQuery(className: "KMADataGovSADataSet")
        query.order(byDescending: "updatedAt")
        query.includeKey("region")
        
        // If Saudi Arabia is a region - show all the datasets
        if regionId != "ocRDUNG9ZR" { // Not the Saudi Arabia
            query.whereKey("region", equalTo: PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId))
        }
        
        query.findObjectsInBackground { (datasets, error) in
            var datasetsArray = [KMAUIDataset]()
            
            if let error = error {
                print(error.localizedDescription)
            } else if let datasets = datasets {
                print("\nDatasets loaded: \(datasets.count):\n")
                // Setup datasets
                for dataset in datasets {
                    // Name
                    if let type = dataset["type"] as? String {
                        // Park Locations or Building Permits
                        if type == "parkLocations" || type == "buildingPermits" || type == "establishmentPermits" || type == "hospitalBeds" || type == "hospitalBedsSectors" {
                            var parkLocatiosDataset = KMAUIDataset()
                            parkLocatiosDataset.fillFrom(dataset: dataset)
                            datasetsArray.append(parkLocatiosDataset)
                        }
                    }
                }
            }
            
            // Return counts and datasets array
            completion(datasetsArray.count, datasetsArray)
        }
    }
    
    // MARK: - KMA 9x9 API
    
    /**
     Get data from KMA 9x9
     */
    
    public func getDataKMA9x9(sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D, completion: @escaping (_ bundlesCount: Int, _ bundles: [KMAUI9x9Bundle])->()) {
        // Bearer token
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNWVmOWU3MmNhYjYyNDc2ODk4ODgyMWE1IiwiaWF0IjoxNTkzNjkwNzc1LCJleHAiOjMzMTI5NjkwNzc1fQ.rtN50H_U04NlREA9mwNRN2b-J1XJl8uUempIdqLDNgw"
        
        // Headers
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        // Parameters - geobox of the region
        let parameters: [String: AnyObject] = [
            "polygone" : [[sw.latitude, sw.longitude], [ne.latitude, sw.longitude], [ne.latitude, ne.longitude], [sw.latitude, ne.longitude], [sw.latitude, sw.longitude]] as AnyObject]

        // Bundles endpoint
        let bundlesSearch = "https://api.kma.dev.magora.uk/v1/bundles/search"
        
        // Backend request
        AF.request(bundlesSearch, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            // Clear bundles string saved value
            var jsonString = ""
            
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonStringValue = json.rawString() {
                        jsonString = jsonStringValue
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            //            print("\nBundles loaded:\n\(jsonString)")
            let bundles = KMAUIUtilities.shared.setupBundles(jsonString: jsonString, sw: sw, ne: ne)
            
            completion(bundles.count, bundles)
        }
    }
    
    // Load the polygone details for bundle id
    public func getDataForPolygone(bundleId: String, sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D, completion: @escaping (_ polygones: [KMAUIPolygoneDataStruct])->()) {
        let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJkYXRhIjoiNWVmOWU3MmNhYjYyNDc2ODk4ODgyMWE1IiwiaWF0IjoxNTkzNjkwNzc1LCJleHAiOjMzMTI5NjkwNzc1fQ.rtN50H_U04NlREA9mwNRN2b-J1XJl8uUempIdqLDNgw"
        
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
        
        let parameters: [String: AnyObject] = [
            "polygone" : [[sw.latitude, sw.longitude], [ne.latitude, sw.longitude], [ne.latitude, ne.longitude], [sw.latitude, ne.longitude], [sw.latitude, sw.longitude]] as AnyObject
        ]
                
        let dataFromBundle = "https://api.kma.dev.magora.uk/v1/bundles/\(bundleId)/search/polygones"
        
        AF.request(dataFromBundle, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            var jsonString = ""
            
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonStringValue = json.rawString() {
                        jsonString = jsonStringValue
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
//            print("\nPolygones for bundle \(bundleId):\n\(jsonString)")
            
            completion(self.processPolygoneData(jsonString: jsonString, sw: sw, ne: ne))
        }
    }
    
    public func processPolygoneData(jsonString: String, sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D) -> [KMAUIPolygoneDataStruct] {
        let jsonDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: jsonString)
        var polygoneArray = [KMAUIPolygoneDataStruct]()

        if let data = jsonDictionary["data"] as? [String: AnyObject] {
            // CUSTOM
            if let custom = data["CUSTOM"] as? [[String: AnyObject]] {
                for item in custom {
                    var polygoneData = KMAUIPolygoneDataStruct()
                    polygoneData.polygoneType = "custom"
                    polygoneData.fillFromDictionary(object: item)
                    
                    if polygoneData.location.isEmpty {
                        // Randomize the value
                        let randomInt = Int.random(in: 0 ..< 20)
                        let randomInt2 = Int.random(in: 0 ..< 20)
                        let areaLat = ne.latitude - sw.latitude
                        let areaLong = ne.longitude - sw.longitude
                        var latOffset = areaLat * Double(randomInt) / 100
                        var longOffset = areaLong * Double(randomInt) / 100

                        if randomInt % 2 == 0 {
                            latOffset = -latOffset
                        }
                        
                        if randomInt2 % 2 == 0 {
                            longOffset = -longOffset
                        }
                        
                        polygoneData.location = CLLocationCoordinate2D(latitude: (sw.latitude + ne.latitude) / 2 + latOffset, longitude: (sw.longitude + ne.longitude) / 2 + longOffset)
                    }
                    
                    polygoneArray.append(polygoneData)
                }
            }
            // GOOGLE PLACES
            if let googlePlaces = data["GOOGLE_PLACES"] as? [[String: AnyObject]] {
                for place  in googlePlaces {
                    var polygoneData = KMAUIPolygoneDataStruct()
                    polygoneData.polygoneType = "googlePlace"
                    polygoneData.fillFromDictionary(object: place)
                    // We don't need to display the permanently closed places
                    if !polygoneData.googlePlaceClosed {
                        polygoneArray.append(polygoneData)
                    }
                }
            }
        } else {
            print("\nNo polygone data for bundle.")
        }
        
        // Order polygone array by rating
        polygoneArray = KMAUIUtilities.shared.orderPolygoneArray(array: polygoneArray)
        
        return polygoneArray
    }
    
    public func getGoogleNearbyPlaces(polygoneArray: [KMAUIPolygoneDataStruct], nextPageToken: String, keyword: String, category: String, sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D, completion: @escaping (_ polygones: [KMAUIPolygoneDataStruct])->()) {
        var polygoneArray = polygoneArray
        let centerPoint = CLLocationCoordinate2D(latitude: (sw.latitude + ne.latitude) / 2, longitude: (sw.longitude + ne.longitude) / 2)
        var radius = CLLocation(latitude: sw.latitude, longitude: sw.longitude).distance(from: CLLocation(latitude: ne.latitude, longitude: ne.longitude))
        
        if radius > 50000 {
            radius = 50000
        }
        
        var pageToken = ""
        
        if !nextPageToken.isEmpty {
            pageToken = "&pagetoken=\(nextPageToken)"
        }
        
        let dataFromBundle = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(centerPoint.latitude)%2C\(centerPoint.longitude)&radius=\(radius)&keyword=\(keyword)\(pageToken)&key=\(KMAUIConstants.shared.googlePlacesAPIKey)"
        
        AF.request(dataFromBundle, method: .get).responseJSON { response in
            var jsonString = ""
            
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonStringValue = json.rawString() {
                        jsonString = jsonStringValue
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            let placesDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: jsonString)
            var newResults = 0
            
            if let results = placesDictionary["results"] as? [[String: AnyObject]], !results.isEmpty {
//                print("Places found: \(results.count)")
                for place in results {
                    var polygoneData = KMAUIPolygoneDataStruct()
                    polygoneData.polygoneType = "googlePlace"
                    polygoneData.fillFromNearbyPlace(object: place)
                    polygoneData.googleCategory = category.lowercased()
                    // We don't need to display the permanently closed places
                    if !polygoneData.googlePlaceClosed {
                        polygoneArray.append(polygoneData)
                        newResults += 1
                    }
                }
//            } else {
//                print("No places found")
            }
            
            // Order polygone array by rating
            polygoneArray = KMAUIUtilities.shared.orderPolygoneArray(array: polygoneArray)
            
            // Only send completion if that's the first request or we have some new results
            if newResults > 0 || (newResults == 0 && polygoneArray.isEmpty) {
                completion(polygoneArray)
            }
            
            if let nextPageToken = placesDictionary["next_page_token"] as? String, !nextPageToken.isEmpty {
//                print("\nLoad next set of results")
                // Give a small delay before the next call
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.getGoogleNearbyPlaces(polygoneArray: polygoneArray, nextPageToken: nextPageToken, keyword: keyword, category: category, sw: sw, ne: ne) { (polygoneArrayValue) in
                        completion(polygoneArrayValue)
                    }
                }
            }
        }
    }
    
    public func getGooglePlaceDetails(placeId: String, polygone: KMAUIPolygoneDataStruct, completion: @escaping (_ polygone: KMAUIPolygoneDataStruct)->()) {
        var polygone = polygone
        
        let dataFromBundle = "https://maps.googleapis.com/maps/api/place/details/json?place_id=\(placeId)&language=en&fields=address_component,adr_address,business_status,formatted_address,geometry,icon,name,photo,place_id,plus_code,type,url,utc_offset,vicinity,formatted_phone_number,international_phone_number,opening_hours,website,price_level,rating,review,user_ratings_total&key=\(KMAUIConstants.shared.googlePlacesAPIKey)"
        
        AF.request(dataFromBundle, method: .get).responseJSON { response in
            var jsonString = ""
            
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonStringValue = json.rawString() {
                        jsonString = jsonStringValue
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            let placeDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: jsonString)
            
            if let result = placeDictionary["result"] as? [String: AnyObject] {
                polygone.polygoneType = "googlePlace"
                polygone.fillFromNearbyPlace(object: result)
                polygone.googleDetailsLoaded = true
                completion(polygone)
            }
        }
    }
    
    // MARK: KMA 9x9 Bundles
    
    public func setupBundles(jsonString: String, sw: CLLocationCoordinate2D, ne: CLLocationCoordinate2D) -> [KMAUI9x9Bundle] {
        var bundles = [KMAUI9x9Bundle]()
        // Get bundles list
        let bundlesDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: jsonString)
        if let bundlesArray = bundlesDictionary["data"] as? [[String: AnyObject]] {
            for bundleItem in bundlesArray {
                var bundle = KMAUI9x9Bundle()
                bundle.fillFromDictionary(object: bundleItem)
                // Add the bundle into the array if it's not an empty bundle
                if !bundle.id.isEmpty {
                    // Load Google Places
                    if bundle.name == "Google" {
                        bundle.name = "Google Places"
                        bundle.description = "Nearby places"
                        bundle.setupGoogleCategories()
                    } else {
                        // Setup location
                        bundle.location = CLLocationCoordinate2D(latitude: (sw.latitude + ne.latitude) / 2, longitude: (sw.longitude + ne.longitude) / 2)
                    }
                    
                    bundles.append(bundle)
                }
            }
        }
        
        return bundles
    }
    
    // MARK: - Create dataset
    
    public func createXlsDatasets() {
        // Setup test datasets
        let regionIds = [
            "fN4QkVTtYG", // Ar Riyad
            "jKSqzVZ1Qh", // Makkah
            "urz0USWpmV", // Al Madinah
            "PQJotY1T16", // Qassim
            "U3pCS8McNA", // Eastern Province
            "1Wbb0OFXuZ", // `Asir
            "c3CiqAdxjG", // Tabuk
            "OQuHnQ1Psl", // Hail
            "l6XhWzfDpe", // Northern Borders
            "uNaTZ905Cg", // Jizan
            "x1L4cV8dcX", // Najran
            "0MeC5xWrhK", // Al Bahah
            "YDevBrdNUz", // Jawf
            "ocRDUNG9ZR" // Saudi Arabia
        ]
        
        // Established Permits
        
        let valuesArray = [
            [
                [11635, 2568, 971, 728, 785, 490, 950, 892, 646, 1298, 615, 1692],
                [41364, 9312, 2881, 2797, 3881, 1446, 2646, 2051, 1991, 2415, 2621, 9323],
                [52999, 11880, 3852, 3525, 4666, 1936, 3596, 2943, 2637, 3713, 3236, 11015]
            ],
            [
                [12167, 1787, 1984, 455, 298, 608, 700, 419, 629, 1494, 207, 3586],
                [30223, 3744, 4781, 1350, 562, 2250, 1268, 855, 951, 3085, 498, 10879],
                [42390, 5531, 6765, 1805, 860, 2858, 1968, 1274, 1580, 4579, 705, 14465]
            ],
            [
                [2326, 390, 291, 133, 53, 273, 142, 74, 17, 418, 1, 534],
                [4970, 764, 630, 200, 87, 520, 176, 80, 65, 462, 1, 1985],
                [7296, 1154, 921, 333, 140, 793, 318, 154, 82, 880, 2, 2519]
            ],
            [
                [3480, 1131, 314, 76, 89, 248, 128, 129, 97, 739, 27, 502],
                [6114, 1712, 649, 217, 128, 537, 202, 129, 134, 728, 108, 1570],
                [9594, 2843, 963, 293, 217, 785, 330, 258, 231, 1467, 135, 2072]
            ],
            [
                [11228, 2290, 1753, 211, 249, 352, 480, 507, 324, 2907, 30, 2125],
                [20619, 3511, 3302, 510, 297, 1151, 740, 402, 479, 3653, 127, 6447],
                [31847, 5801, 5055, 721, 546, 1503, 1220, 909, 803, 6560, 157, 8572]
            ],
            [
                [3652, 517, 509, 147, 29, 222, 176, 168, 166, 758, 59, 901],
                [7240, 993, 921, 388, 191, 468, 270, 232, 288, 985, 307, 2197],
                [10892, 1510, 1430, 535, 220, 690, 446, 400, 454, 1743, 366, 3098]
            ],
            [
                [1623, 229, 374, 21, 10, 67, 85, 67, 29, 354, 8, 379],
                [2510, 475, 421, 80, 25, 160, 78, 52, 52, 432, 12, 723],
                [4133, 704, 795, 101, 35, 227, 163, 119, 81, 786, 20, 1102]
            ],
            [
                [1562, 239, 190, 101, 67, 158, 173, 91, 29, 180, 36, 298],
                [1837, 254, 244, 150, 74, 220, 146, 83, 50, 165, 26, 425],
                [3399, 493, 434, 251, 141, 378, 319, 174, 79, 345, 62, 723]
            ],
            [
                [1145, 292, 129, 26, 23, 55, 239, 46, 9, 95, 4, 227],
                [1732, 530, 264, 41, 26, 156, 103, 61, 24, 95, 17, 415],
                [2877, 822, 393, 67, 49, 211, 342, 107, 33, 190, 21, 642]
            ],
            [
                [1620, 284, 216, 33, 9, 143, 75, 40, 77, 138, 26, 579],
                [1597, 305, 219, 46, 10, 122, 61, 41, 57, 126, 23, 587],
                [3217, 589, 435, 79, 19, 265, 136, 81, 134, 264, 49, 1166]
            ],
            [
                [2019, 365, 113, 94, 58, 388, 116, 112, 79, 283, 49, 362],
                [17087, 1481, 735, 545, 469, 1009, 836, 451, 108, 2801, 183, 8469],
                [19106, 1846, 848, 639, 527, 1397, 952, 563, 187, 3084, 232, 8831]
            ],
            [
                [972, 211, 201, 33, 10, 68, 54, 47, 35, 121, 7, 185],
                [1871, 442, 282, 68, 28, 191, 107, 61, 102, 197, 19, 374],
                [2843, 653, 483, 101, 38, 259, 161, 108, 137, 318, 26, 559]
            ],
            [
                [1361, 317, 139, 17, 29, 123, 82, 89, 11, 152, 13, 389],
                [2199, 468, 243, 23, 50, 166, 95, 81, 29, 193, 28, 823],
                [3560, 785, 382, 40, 79, 289, 177, 170, 40, 345, 41, 1212]
            ],
            [
                [54790, 10620, 7184, 2075, 1709, 3195, 3400, 2681, 2148, 8937, 1082, 11759],
                [139363, 23991, 15572, 6415, 5828, 8396, 6728, 4579, 4330, 15337, 3970, 44217],
                [194153, 34611, 22756, 8490, 7537, 11591, 10128, 7260, 6478, 24274, 5052, 55976]
            ]
        ]
        
            
        /* // For 1424
        let valuesArray = [
            [
                [677738, 4871076, 13303, 2391187, 27724146, 6782],
                [18481, 292133, 381, 241360, 1465154, 303],
                [30065, 284166, 338, 182455, 1161038, 231],
                [6090, 78333, 41, 49831, 221714, 23],
                [732374, 5525708, 14063, 2864833, 30572052, 7339]
            ],
            [
                [294218, 5208136, 10909, 1666335, 3650523, 4017],
                [23850, 325547, 168, 267772, 1980565, 154],
                [8729, 194046, 201, 104018, 1525528, 123],
                [2768, 82964, 91, 32958, 729594, 38],
                [329565, 5810693, 11369, 2071083, 7886210, 4332]
            ],
            [
                [169647, 2319733, 12163, 1237021, 3576059, 3223],
                [8132, 157936, 129, 127685, 502588, 90],
                [17840, 560326, 121, 465410, 794871, 76],
                [5826, 93820, 14, 93242, 180182, 13],
                [201445, 3131815, 12427, 1923358, 5053700, 3402]
            ],
            [
                [318540, 2493344, 7233, 1442074, 6160635, 3869],
                [31698, 200669, 297, 170994, 497351, 245],
                [26464, 163519, 264, 115799, 576323, 193],
                [2143, 16759, 24, 10210, 83018, 17],
                [378845, 2874291, 7818, 1739077, 7317327, 4324]
            ],
            [
                [676332, 5515792, 17278, 2714001, 6684418, 7690],
                [169814, 917371, 1012, 658400, 1197023, 795],
                [78056, 544148, 232, 457847, 2383353, 136],
                [231192, 26273, 43, 17915, 115975, 31],
                [1155394, 7003584, 18565, 3848163, 10380769, 8652]
            ],
            [
                [209666, 1877103, 4023, 950945, 3052511, 2147],
                [5295, 109044,101, 105374, 324115, 91],
                [11888,163617, 100, 129625, 469029, 76],
                [556, 3935, 6, 2256, 7425, 5],
                [227405, 2153699, 4230, 1188200, 3853080, 2319]
            ],
            [
                [132076, 988886, 7552, 463587, 991486, 1509],
                [10301, 145414, 155, 122245, 298950, 120],
                [4195, 44251, 52, 29505, 84801, 40],
                [1914, 7945, 13, 6331, 25868, 9],
                [148486, 1186496, 7772, 621668, 1401105, 1678]
            ],
            [
                [93984, 655586, 2244, 441551, 1799465, 1501],
                [29942, 69847, 107, 64034, 204754, 98],
                [28889, 122452, 110, 108213, 303645, 97],
                [900, 28170, 16, 23593, 75660, 14],
                [153715, 876055, 2477, 637391, 2383524, 1710]
            ],
            [
                [82365, 276145, 1192, 180981, 832493, 784],
                [9957, 26197, 68, 22190, 142343, 56],
                [7873, 81081, 36, 65859, 392660, 28],
                [6096, 22560, 17, 20853, 566731, 14],
                [106291, 405983, 1313, 289883, 1934227, 882]
            ],
            [
                [80701, 412342, 1286, 196361, 2041056, 690],
                [9471, 82963, 86, 74381, 470985, 78],
                [7248, 61338, 85, 40446, 317644, 66],
                [981, 10434, 10, 3844, 14216, 4],
                [98401, 567077, 1467, 315032, 2843901, 838]
            ],
            [
                [53616, 270682, 784, 143258, 485837, 481],
                [3514, 23672, 39, 23206, 56323, 38],
                [1910, 5942, 13, 4100, 32854, 11],
                [800, 7070, 4, 3511, 20000, 2],
                [59840, 307366, 840, 174075, 595014, 532]
            ],
            [
                [41808, 197649, 553, 103434, 909112, 326],
                [2250, 10490, 14, 7882, 29534, 11],
                [3917, 34997, 37, 27059, 261885, 30],
                [1284, 5573, 2, 5573, 54124, 2],
                [49259, 248709, 606, 143948, 1254655, 38]
            ],
            [
                [110577,539694, 1969, 354414, 3065922, 1117],
                [14667, 21884, 56, 20661, 112199, 54],
                [10755, 57404, 52, 26896, 159894, 30],
                [1862, 3776, 10, 1932, 34091, 7],
                [137861, 622758, 2087, 403903, 3372106, 1208]
            ],
            [
                [2941268, 25626168, 80489, 12285149, 60973663, 34136],
                [337372, 2383167, 2613, 1906184, 33540876, 2133],
                [237829, 2317287, 1641, 1757232, 8767641, 1137],
                [262412, 387612, 291, 272049, 3067922, 179],
                [3778881, 30714234, 85034, 16220614, 48497332, 37585]
            ]
        ]*/
        
        /* // For 1434
        let valuesArray = [
            [
                [2767535, 23337488, 85680, 9212532, 62173362, 28411],
                [232941, 6487123, 6302, 3567211, 24752474, 2462],
                [105552, 2016371, 1347, 795168, 5706865, 542],
                [43703, 596330, 229, 290324, 13320135, 130],
                [3149731, 32437312, 93558, 13865235, 105952836, 31545]
            ],
            [
                [1532973, 58144397, 101495, 6086026, 21121298, 23759],
                [117239, 996180, 384, 785978, 5284545, 335],
                [15026, 328768, 311, 184420, 855074, 189],
                [5743, 103368, 76, 62756, 196432, 54],
                [1670981, 59572713, 102266, 7119180, 27457349, 24337
                ]
            ],
            [
                [133275, 9204992, 27475, 2906458, 15110722,8532],
                [7105, 241553, 195, 168971, 1484644, 134],
                [20822, 276999, 305, 171923, 652897, 146],
                [4764, 118646, 63, 66562, 202381, 30],
                [165966, 9842190, 28038, 3313914, 17450644, 8842]
            ],
            [
                [549630, 3860427, 9170, 2775240, 21317852, 6879],
                [34573, 269422, 420, 253258, 2957420, 415],
                [29029, 184673, 207, 137198, 3669099, 178],
                [6538, 87112, 54, 64973, 231373, 38],
                [619770, 4401634, 9851, 3230669, 28175744, 7510]
            ],
            [
                [2082995, 17855393, 46803, 8266421, 13184516, 19836],
                [249825, 4425095, 6118, 2645151, 5220129, 2179],
                [61965, 824228, 1090, 486020, 1031474, 331],
                [21174, 304188, 172, 192884, 1831531, 100],
                [2415959, 23408904, 54183, 11590476, 21267650, 22446]
            ],
            [
                [629586, 6494199, 12612, 2616584, 9421057, 5626],
                [40943, 608615, 466, 343700, 1292808, 360],
                [15004, 168967, 149, 109080, 403262, 100],
                [17339 ,257444, 88, 92270, 1912528, 53],
                [702872, 7529225, 13315, 3161634, 13029655, 6139]
            ],
            [
                [316919, 2894948, 6563, 1408858, 3893120, 3377],
                [23941, 279208, 490, 199131, 540585, 252],
                [9025, 48907, 65, 30896, 2186467, 40],
                [7990, 44792, 34, 22700, 1054327, 15],
                [357875, 3267855, 7152, 1661585, 7674499, 3684]
            ],
            [
                [312010, 1845279, 5474, 873696, 107291484, 2900],
                [24422, 106795, 164, 83199, 414397, 142],
                [21398, 218678, 159, 130598, 639063, 99],
                [7768, 195289, 39, 98346, 704749, 20],
                [365598, 2366041, 5836, 1185839, 109049693, 3161]
            ],
            [
                [144565, 897650, 2120, 580459, 93534105, 1446],
                [33944, 229681, 189, 218918, 1261742, 187],
                [12647, 142062, 83, 82987, 180806, 65],
                [5408, 35885, 40, 17724, 118916, 20],
                [196564, 1305278, 2432, 900088, 95095569, 1718]
            ],
            [
                [168899, 1289785, 2991, 730418, 9133514, 1634],
                [34263, 304869, 274, 238110, 1981081, 229],
                [6240, 45565, 84, 38123, 249502, 68],
                [4712, 28900, 36, 22090, 261984, 24],
                [214114, 1669119, 3385, 1028741, 11626081, 1955]
            ],
            [
                [163617, 1351490, 3958, 722021, 6888252, 1761],
                [6868, 45236, 39, 39103, 365982, 35],
                [7571, 21842, 25, 17106, 157957, 17],
                [4096, 27109, 29, 15682, 215696, 17],
                [182152, 1445677, 4051, 793912, 7627887, 1830]
            ],
            [
                [143724, 715367, 1478, 421220, 6354352, 980],
                [3032, 47089, 43, 29609, 87932, 32],
                [4211, 46283, 36, 26306, 293672, 25],
                [1753, 15325, 25, 9411, 74265, 17],
                [152720, 824064, 1582, 486546, 6810221, 1054]
            ],
            [
                [234742, 1610421, 5169, 734860, 49214587, 2398],
                [20448, 189424, 570, 159569, 2775689, 334],
                [18992, 283571, 245, 108051, 1668758, 101],
                [6160, 180129, 96, 86546, 1723118, 24],
                [280342, 2263545, 6080, 1089026, 55382152, 2857]
            ],
            [
            [9180470, 129501836, 310988, 37334793, 418638221, 107539],
            [829544, 14230290, 15654, 8731908, 48419428, 7096],
            [327482, 4606914, 4106, 2317876, 17694896, 1901],
         [137148, 1994517, 981, 1042268, 21847435, 542],
         [10474644, 150333557, 331729, 49426845, 506599980, 117078]
         ]
         ]*/
        
        for (index, regionId) in regionIds.enumerated() {
            setupDataset(values: valuesArray[index], regionId: regionId)
        }
    }
    
    public func setupDataset(values: [[Int]], regionId: String) {
        // Creating the demo array
        let titles = [
            "New",
            "Renewed",
            "Total"
        ]
        
        /*let titles = [
         "Housing, Commercial",
                      "Industrial, Commercial",
                      "Educational Buildings, Health and Mosques",
                      "Social Buildings and Governmental",
                      "Total"
         ]*/
        
        let keys = KMAUIConstants.shared.establishmentPermitKeys // KMAUIConstants.shared.buildingPermitKeys
        
        var totalArray = [AnyObject]()
        
        for (index1, title) in titles.enumerated() {
            let value = values[index1]
            var titleDictionary = [String: Int]()
            
            for (index2, key) in keys.enumerated() {
                titleDictionary[key] = value[index2]
            }
            
            totalArray.append([title: titleDictionary] as AnyObject)
        }
        
        //
        let newDataset = PFObject(className: "KMADataGovSADataSet")
        newDataset["name"] = "New and Renewed Establishments Permits: 1426 A.H." // "Building Permits: 1424 A.H." // "Building Permits: 1434 A.H." // "Building Permits Issued by Municipalities by Regions and Type of Permit : 1434 A.H."
        newDataset["owner"] = "Ministry of Municipal and Rural Affairs (Statistics and Researches Department)" // "Ministry of Municipal and Rural Affairs"
        newDataset["region"] = PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId)
        newDataset["type"] = "establishmentPermits" // "buildingPermits"
        
        let jsonData = KMAUIUtilities.shared.dictionaryToJSONData(dict: ["Dataset": totalArray as AnyObject])
        // JSON String for Parse
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\nTotal dictionary:\n\(jsonString)")
            newDataset["json"] = jsonString
        }
        
        newDataset.saveInBackground { (success, error) in
            if let error = error {
                print("Error creating a dataset for a region \(regionId): \(error.localizedDescription).")
            } else if success {
                print("Dataset created for the region \(regionId).")
            }
        }
    }
    
    // 01 Hospital Beds in Other Governmental Sector by Speciality during 1439H
    
    public func prepareHospitalBeds1439HDataset() {
        let values = [
            [0, 733, 760, 72, 102, 3, 639, 419, 808, 8, 3, 37, 3, 32, 97, 93, 1542, 5351],
            [0, 891, 338, 66, 4, 0, 279, 686, 204, 3, 2, 15, 0, 5, 0, 65, 22, 2580],
            [0, 148, 110, 26, 9, 2, 112, 225, 61, 9, 8, 0, 0, 7, 0, 28, 80, 825],
            [0, 220, 131, 26, 30, 2, 67, 108, 200, 22, 2, 15, 1, 8, 11, 0, 363, 1206],
            [0, 81, 79, 28, 0, 0, 65, 131, 26, 0, 0, 0, 0, 0, 0, 24, 12, 446],
            [0, 102, 41, 37, 0, 0, 56, 78, 26, 0, 0, 0, 0, 0, 20, 16, 0, 376],
            [0, 399, 360, 62, 21, 9, 200, 298, 168, 57, 39, 13, 3, 29, 59, 62, 99, 1878],
            [0, 2574, 1819, 317, 166, 16, 1418, 1945, 1493, 99, 54, 80, 7, 81, 187, 288, 2118, 12662]
        ]
        
        setupHospitalBeds1439HDataset(values: values, objectId: "grU4aHAAIx")
    }
    
    func setupHospitalBeds1439HDataset(values: [[Int]], objectId: String) {
        // Creating the demo array
        let titles = ["A.F.Hs.", "N.G.Hs.", "S.F.Hs.", "K.F.S.H.,R-J.", "R.C.Hs.", "ARAMCO Hs.", "MOE"]
        let keys = KMAUIConstants.shared.hospitalBedsKeys
        
        var totalArray = [AnyObject]()
        
        for (index1, title) in titles.enumerated() {
            let value = values[index1]
            var titleDictionary = [String: Int]()
            
            for (index2, key) in keys.enumerated() {
                titleDictionary[key] = value[index2]
            }
            
            totalArray.append([title: titleDictionary] as AnyObject)
        }
        
        //
        let newDataset = PFObject(withoutDataWithClassName: "KMADataGovSADataSet", objectId: objectId)
        
        let jsonData = KMAUIUtilities.shared.dictionaryToJSONData(dict: ["Dataset": totalArray as AnyObject])
        // JSON String for Parse
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\nTotal dictionary:\n\(jsonString)")
            newDataset["json"] = jsonString
        }
        
        newDataset.saveInBackground { (success, error) in
            if let error = error {
                print("Error creating a dataset: \(error.localizedDescription).")
            } else if success {
                print("Dataset created.")
            }
        }
    }
    
    public func createDatasetHospitalBedsSectors() {
        let sectionTitles = [
            "Ministry of Health",
            "Other governmental Sector",
            "Private  sector",
            "Total",
            "Rate of beds/10,000 population"
        ]
        
        let years = [
            "1435H (2014G)",
            "1436H (2015G)",
            "1437H (2016G)",
            "1438H (2017G)",
            "1439H (2018G)"
        ]
        
        let points = [
            "Hospitals",
            "Beds"
        ]
        
        let values = [
            [[270, 40300], [274, 41297], [274, 41835], [282, 43080], [284, 43680]],
            [[42, 12032], [43, 11449], [44, 11581], [47, 12279], [47, 12662]],
            [[141, 15665], [145, 16648], [152, 17428], [158, 17622], [163, 18883]],
            [[453, 67997], [462, 69394], [470, 70844], [487, 72981], [494, 75225]],
            [[0, 22.1], [0, 22.0], [0, 22.3], [0, 22.4], [0, 22.5]]
        ]
        
        var datasetData = [String: AnyObject]()
        
        for (rowIndex, row) in sectionTitles.enumerated() {
            print("\nROW: \(row)")
            let rowValue = values[rowIndex]
            var rowData = [String: [String: Double]]()
            
            for (yearIndex, year) in years.enumerated() {
                print("\nYEAR: \(year)")
                let yearData = rowValue[yearIndex]
                
                var pointData = [String: Double]()
                for (pointIndex, point) in points.enumerated() {
                    print("\(point) - \(yearData[pointIndex])")
                    pointData[point] = yearData[pointIndex]
                }
                
                rowData[year] = pointData
            }
            
            datasetData[row] = rowData as AnyObject
        }
                
        var datasetDictionary = [String: AnyObject]()
        datasetDictionary["sectionTitles"] = sectionTitles as AnyObject
        datasetDictionary["rowTitles"] = years as AnyObject
        datasetDictionary["points"] = points as AnyObject
        datasetDictionary["data"] = datasetData as AnyObject
        
        let newDataset = PFObject(withoutDataWithClassName: "KMADataGovSADataSet", objectId: "pmmml8JsgZ")
        
        let jsonData = KMAUIUtilities.shared.dictionaryToJSONData(dict: ["Dataset": datasetDictionary as AnyObject])
        // JSON String for Parse
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("\nTotal dictionary:\n\(jsonString)")
            newDataset["json"] = jsonString
        }
        
        newDataset.saveInBackground { (success, error) in
            if let error = error {
                print("Error creating a dataset: \(error.localizedDescription).")
            } else if success {
                print("Dataset created.")
            }
        }
    }
}

// MARK: - Int extension
public extension Int {
    
    // Formatting the currency with commas
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
    
    func withDollarK() -> String {
        let doubleValue = Double(Int((Double(self) / 1000) * 10)) / 10
        
        return "$\(doubleValue)k"
    }
}

// MARK: - Double extension
public extension Double {
    
    // Format the currenty with commas
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        return numberFormatter.string(from: NSNumber(value: self.formatNumbersAfterDot()))!
    }
    
    // Format 2 numbers after do
    func formatNumbersAfterDot() -> Double {
        return Double(Int((self - Double(Int(self))) * 100)) / 100 + Double(Int(self))
    }
}

// MARK: - UITableView extension

public extension UITableView {
    
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        
        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
}

// MARK: - UIDevice extension

/**
 Detect if iPhone has a notch.
 */

public extension UIDevice {
    var hasNotch: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod touch (5th generation)"
            case "iPod7,1":                                 return "iPod touch (6th generation)"
            case "iPod9,1":                                 return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPhone12,1":                              return "iPhone 11"
            case "iPhone12,3":                              return "iPhone 11 Pro"
            case "iPhone12,5":                              return "iPhone 11 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
}

// MARK: Getting the mailing address format for address

public extension Formatter {
    static let mailingAddress: CNPostalAddressFormatter = {
        let formatter = CNPostalAddressFormatter()
        formatter.style = .mailingAddress
        return formatter
    }()
}

public extension CLPlacemark {
    var mailingAddress: String? {
        return postalAddress?.mailingAddress
    }
}

public extension CNPostalAddress {
    var mailingAddress: String {
        return Formatter.mailingAddress.string(from: self)
    }
}

public extension String {
    var encodeUrl: String {
        return self.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    var decodeUrl: String {
        return self.removingPercentEncoding!
    }
    
    func formatUsername() -> String {
        return "@" + self.replacingOccurrences(of: "@", with: "")
    }
    
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    
    func withSquareMeters() -> String {
        return "\(self) m²"
    }
    
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
    
    func addGaps() -> String {
        return "\(KMAUIConstants.shared.stringGap)\(self)\(KMAUIConstants.shared.stringGap)"
    }
}

public extension CLLocationCoordinate2D {
    var isEmpty: Bool {
        return ((self.latitude == 0 && self.longitude == 0) || self.latitude == -180 && self.longitude == -180)
    }
}

// MARK: - Array extension

public extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

// MARK: - UIStackView extension

public extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

// MARK: - UIImage extension

public extension UIImage {
    var noir: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectNoir") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}

// MARK: - Location extension

public extension CLLocationCoordinate2D {

    /// Get coordinate moved from current to `distanceMeters` meters with azimuth `azimuth` [0, Double.pi)
    ///
    /// - Parameters:
    ///   - distanceMeters: the distance in meters
    ///   - azimuth: the azimuth (bearing)
    /// - Returns: new coordinate
    func shift(byDistance distanceMeters: Double, azimuth: Double) -> CLLocationCoordinate2D {
        let bearing = azimuth
        let origin = self
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}

// MARK: - UIView extension

public extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    /**
     Corner views
     */
    func setRoundCorners(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1.0
        self.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        self.clipsToBounds = true
    }
    
    /**
     Round corners for selected corners only
     */
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func rotate(degrees: CGFloat) {
        rotate(radians: CGFloat.pi * degrees / 180.0)
    }

    func rotate(radians: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

// MARK: - UISegmentedControl extension

public extension UISegmentedControl {
    
    // Getting the correct background color without a shadow
    func fixBackgroundSegmentControl() {
        if #available(iOS 13.0, *) {
            //just to be sure it is full loaded
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                for i in 0...(self.numberOfSegments - 1)  {
                    let backgroundSegmentView = self.subviews[i]
                    //it is not enogh changing the background color. It has some kind of shadow layer
                    backgroundSegmentView.isHidden = true
                }
            }
        }
    }
    
    // Prepare the segmentedControl UI
    func updateUI() {
        // Create the new segmentControl
        self.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        self.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        self.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        }
        
        self.layer.borderWidth = 0
        
        let normalAttritutes = [NSAttributedString.Key.font.rawValue: KMAUIConstants.shared.KMAUIRegularFont.withSize(12), NSAttributedString.Key.foregroundColor: KMAUIConstants.shared.KMAUITextColor] as! [NSAttributedString.Key: Any]
        self.setTitleTextAttributes(normalAttritutes, for: .normal)
        
        let selectedAttributes = [NSAttributedString.Key.font.rawValue: KMAUIConstants.shared.KMAUIBoldFont.withSize(12), NSAttributedString.Key.foregroundColor: UIColor.white] as! [NSAttributedString.Key: Any]
        self.setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}

// MARK: - UIButton extension methods

public extension UIButton {
    
    func setupArrowButton(isDecrease: Bool) {
        self.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        self.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        self.contentMode = .center
        self.layer.cornerRadius = 2
        self.clipsToBounds = true
        
        if isDecrease {
            self.setImage(KMAUIConstants.shared.decreaseArrow.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            self.setImage(KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}

// MARK: - UILabel extension

public extension UILabel {
    
    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0, alignment: NSTextAlignment? = nil) {
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        } else {
            paragraphStyle.alignment = .center
        }
        
        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

// MARK: - UILabel extension

public extension UITextView {
    
    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0, alignment: NSTextAlignment? = nil) {
        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        } else {
        paragraphStyle.alignment = .center
        }

        let attributedString: NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
