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
        // Get the countries list
        let mapAreaQuery = PFQuery(className: "KMAMapArea")
        mapAreaQuery.whereKey("level", equalTo: level)
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
    }
}
