//
//  KMAUIPerson.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse

class KMAUIPerson {
    
    // Access variable
    public static let shared = KMAUIPolice()
    
    // MARK: - Property
    
    public func getProperty(personId: String, completion: @escaping (_ propertyArray: [KMACitizenProperty], _ error: String)->()) {
        var property = [KMACitizenProperty]()
        
        let query = PFQuery(className: "KMAProperty")
        query.whereKey("isActive", equalTo: true)
        query.whereKey("owner", equalTo: PFUser(withoutDataWithObjectId: personId))
        query.order(byDescending: "createdAt")
        query.includeKey("building")
        query.includeKey("documentPointers")
        
        query.findObjectsInBackground { (propertyArray, error) in
            if let error = error {
                print("Error getting user's property: `\(error.localizedDescription)`.")
                completion(property, error.localizedDescription)
            } else if let propertyArray = propertyArray, !propertyArray.isEmpty {
                print("User property: \(propertyArray.count)")
                
                for propertyLoaded in propertyArray {
                    // The property item
                    var propertyItem = KMACitizenProperty()
                    propertyItem.fillFrom(propertyLoaded: propertyLoaded)
                    property.append(propertyItem)
                }
                
                completion(property, "")
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
    var objectId = ""
    var createdAt = Date()
    var updatedAt = Date()
    var name = ""
    var descriptionText = ""
    var issueDate = Date()
    var files = ""
    
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
