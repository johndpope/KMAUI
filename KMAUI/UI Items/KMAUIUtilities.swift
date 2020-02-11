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
        headerView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        backgroundView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
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
        headerViewObject.backgroundView?.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
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
        loadingIndicator.color = KMAUIConstants.shared.KMABrightBlueColor
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
        loadingIndicator.color = KMAUIConstants.shared.KMABrightBlueColor
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
        imageView.image = KMAUIConstants.shared.rightArrow.withRenderingMode(.alwaysTemplate)
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
        let clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        clearButton.titleLabel?.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        clearButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColor, for: .normal)
        clearButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColor.withAlphaComponent(0.75), for: .highlighted)
        clearButton.setTitle("Clear selection", for: .normal)
        clearButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        clearButton.layer.cornerRadius = 15
        
        return UIBarButtonItem(customView: clearButton)
    }
    
    /**
     Filter bar button
     */
    
    public func getFilterBarButton() -> UIBarButtonItem {
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 74, height: 30))
        filterButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
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
        let showOnMapButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        showOnMapButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
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

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}

// MARK: - UIImage extension

extension UIImage {
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
