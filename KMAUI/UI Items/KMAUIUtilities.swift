//
//  KMAUIUtilities.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse
import MapKit
import Contacts
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
    
    public func headerView(title: String, isRound: Bool? = nil) -> UITableViewHeaderFooterView {
        var offset: CGFloat = 0
        
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
        headerView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        backgroundView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        headerView.addSubview(backgroundView)
        
        // Header title label
        let headerTitleLabel = KMAUITitleLabel(frame: CGRect(x: 16, y: 8 + offset, width: KMAUIConstants.shared.KMAScreenWidth - 32, height: 36))
        headerTitleLabel.text = title
        headerTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        headerView.addSubview(headerTitleLabel)
        
        // Auto-layout for label
        KMAUIUtilities.shared.setConstaints(parentView: headerView, childView: headerTitleLabel, left: 16, right: -16, top: offset, bottom: 0)
        
        // Create a view cell and attach the custom view to it
        let headerViewObject = UITableViewHeaderFooterView()
        headerViewObject.backgroundView = UIView(frame: headerView.bounds)
        headerViewObject.backgroundView?.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
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
    
    func attributedText(text: String, search: String, fontSize: CGFloat, noColor: Bool? = nil) -> NSAttributedString {
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
                        fileValue.fillFrom(dictionary: fileObject)
                        items.append(fileValue)
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
    
    public func downloadfile(urlString: String, fileName: String, uploadId: String, completion: @escaping (_ success: Bool,_ fileLocation: URL?) -> Void){
        if let itemUrl = URL(string: urlString) {
            // then lets create your document folder url
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

            // lets create your destination file url
            let destinationUrl = documentsDirectoryURL.appendingPathComponent("\(uploadId)_\(fileName)")
            
            // to check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                debugPrint("The file already exists at path")
                completion(true, destinationUrl)
            } else {
                // Displaying the loading alert
                KMAUIUtilities.shared.startLoading(title: "Getting a file...")
                
                // you can use NSURLSession.sharedSession to download the data asynchronously
                URLSession.shared.downloadTask(with: itemUrl, completionHandler: { (location, response, error) -> Void in
                    guard let tempLocation = location, error == nil else { return }
                    do {
                        // after downloading your file you need to move it to your destination url
                        try FileManager.default.moveItem(at: tempLocation, to: destinationUrl)
                        DispatchQueue.main.async {
                            KMAUIUtilities.shared.stopLoadingWith { (loaded) in
                                print("File moved to documents folder")
                                completion(true, destinationUrl)
                            }
                        }
                    } catch let error as NSError {
                        DispatchQueue.main.async {
                            KMAUIUtilities.shared.stopLoadingWith { (loaded) in
                                print(error.localizedDescription)
                                completion(false, nil)
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
    
    // Prepare 
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
            self.setImage(KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}

// MARK: - UILabel extension

extension UILabel {

    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
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
