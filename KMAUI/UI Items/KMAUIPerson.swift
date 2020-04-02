//
//  KMAUIPerson.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse

public class KMAUIPerson {
    
    // Access variable
    public static let shared = KMAUIPerson()
    
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
                print("Error getting citizen's property: `\(error.localizedDescription)`.")
                completion(property, error.localizedDescription)
            } else if let propertyArray = propertyArray {
//                print("User property: \(propertyArray.count)")
                
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
    
    // MARK: - Uploads
    
    public func getUploads(personId: String, skip: Int, uploadArrayCurrent: [PFObject], completion: @escaping (_ uploadArray: [KMACitizenUpload], _ error: String)->()) {
        var uploadArrayCurrent = uploadArrayCurrent
        let query = PFQuery(className: "KMAUserUpload")
        query.whereKey("KMACitizen", equalTo: PFUser(withoutDataWithObjectId: personId))
        query.order(byDescending: "createdAt")
        query.includeKey("departmentAssigned")
        query.includeKey("departmentAssigned.mapArea")
        query.includeKey("category")
        query.skip = skip
        
        query.findObjectsInBackground { (uploadArray, error) in
            if let error = error {
                print("Error getting citizen's uploads: `\(error.localizedDescription)`.")
                completion([KMACitizenUpload](), error.localizedDescription)
            } else if let uploadArray = uploadArray {
                uploadArrayCurrent.append(contentsOf: uploadArray)
                
                if uploadArray.count == 100 {
                    self.getUploads(personId: personId, skip: skip + 100, uploadArrayCurrent: uploadArrayCurrent) { (uploadArrayValue, error) in
                        completion(uploadArrayValue, error)
                    }
                } else {
                    completion(self.processUploads(uploadArrayCurrent: uploadArrayCurrent), "")
                }
            }
        }
    }
    
    public func processUploads(uploadArrayCurrent: [PFObject]) -> [KMACitizenUpload] {
        var uploads = [KMACitizenUpload]()
        
        for uploadLoaded in uploadArrayCurrent {
            if let _ = uploadLoaded["category"] as? PFObject {
                // The property item
                var uploadItem = KMACitizenUpload()
                uploadItem.fillFromParse(uploadLoaded: uploadLoaded)
                uploads.append(uploadItem)
            }
        }
        
        print("User uploads: \(uploads.count)")
        
        return uploads
    }
    
    public func getCitizenSubLands(citizenId: String, completion: @escaping (_ subLandsArray: [KMAUISubLandStruct])->()) {
        let query = PFQuery(className: "KMALotteryResult")
        query.whereKey("citizen", equalTo: PFUser(withoutDataWithObjectId: citizenId))
        query.includeKey("subLand")
        query.findObjectsInBackground { (resultsArray, error) in
            var subLandsValues = [KMAUISubLandStruct]()
            
            if let error = error {
                print("Error getting citizen's Sub lands: `\(error.localizedDescription)`.")
            } else if let resultsArray = resultsArray {
                print("User has Sub lands: \(resultsArray.count)")
                
                
                for resultObject in resultsArray {
                    if let subLandObject = resultObject["subLand"] as? PFObject {
                        var subLandItem = KMAUISubLandStruct()
                        subLandItem.fillFromParse(item: subLandObject)
                        subLandsValues.append(subLandItem)
                    }
                }
                
                print("Sub lands for citizen: \(subLandsValues.count)")
            }
            
            completion(subLandsValues)
        }
    }
}


