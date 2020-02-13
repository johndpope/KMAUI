//
//  KMAParse.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse

public class KMAUIParse {
    // Access variable
    public static let shared = KMAUIParse()
    
    public func getMapArea(level: Int, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        getMapArea(skip: 0, items: [KMAMapAreaStruct](), level: level, parentObjectId: parentObjectId) { (items) in
            completion(items)
        }
    }
    
    /**
     Get the map area
     */
    
    func getMapArea(skip: Int, items: [KMAMapAreaStruct], level: Int, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        var items = items
        
        // Get the countries list
        let mapAreaQuery = PFQuery(className: "KMAMapArea")
        mapAreaQuery.skip = skip

        if parentObjectId.isEmpty {
            // Get the top level items - Countries
            mapAreaQuery.whereKey("level", equalTo: 1)
        } else  {
            // Get the items for a parent
            mapAreaQuery.whereKey("parent", equalTo: PFObject(withoutDataWithClassName: "KMAMapArea", objectId: parentObjectId))
        }
        
        mapAreaQuery.order(byAscending: "nameE")
        mapAreaQuery.includeKey("country")
        mapAreaQuery.includeKey("city")

        // Get inf from Parse, prepare an array and return the items with the completion handler
        mapAreaQuery.findObjectsInBackground { (countriesArray, error) in
            if let error = error {
                print("Error getting countries: \(error.localizedDescription).")
            } else if let countriesArray = countriesArray {
                print("\nTotal items loaded: \(countriesArray.count)")

                for (index, country) in countriesArray.enumerated() {
                    if let nameE = country["nameE"] as? String {
                        print("\(index + 1). \(nameE)")
                        var item = KMAMapAreaStruct()
                        item.fillFrom(object: country)
                        
                        if item.isActive {
                            items.append(item)
                        }
                    }
                }
                
                if countriesArray.count == 100 {
                    self.getMapArea(skip: skip + 100, items: items, level: level, parentObjectId: parentObjectId) { (itemsArray) in
                        completion(itemsArray)
                    }
                } else {
                    completion(items)
                }
            } else {
                completion(items)
            }
        }
    }
    
    /*
    /**
     Get the map area by the level and parent id
     */
    
    public func getMapArea(level: Int, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        // Get the countries list
        let mapAreaQuery = PFQuery(className: "KMAMapArea")

        if parentObjectId.isEmpty {
            // Get the top level items - Countries
            mapAreaQuery.whereKey("level", equalTo: 1)
        } else  {
            // Get the items for a parent
            mapAreaQuery.whereKey("parent", equalTo: PFObject(withoutDataWithClassName: "KMAMapArea", objectId: parentObjectId))
        }
        
        mapAreaQuery.order(byAscending: "nameE")
        mapAreaQuery.includeKey("country")
        mapAreaQuery.includeKey("city")

        // Get inf from Parse, prepare an array and return the items with the completion handler
        mapAreaQuery.findObjectsInBackground { (countriesArray, error) in
            var items = [KMAMapAreaStruct]()
            
            if let error = error {
                print("Error getting countries: \(error.localizedDescription).")
            } else if let countriesArray = countriesArray {
                print("Total countries loaded: \(countriesArray.count)")

                for (index, country) in countriesArray.enumerated() {
                    if let nameE = country["nameE"] as? String {
                        print("\(index + 1). \(nameE)")
                        var item = KMAMapAreaStruct()
                        item.fillFrom(object: country)
                        
                        if item.isActive {
                            items.append(item)
                        }
                    }
                }
            }
            
            completion(items)
        }
    }*/
}
