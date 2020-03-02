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
    
    /**
     Get Saudi Arabia regions
     */
    
    public func getSaudiArabiaRegions(completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
        // Saudi Arabia Parse object id
        let saudiArabiaId = "ocRDUNG9ZR"
        // Get the items
        KMAUIParse.shared.getMapArea(level: 2, parentObjectId: saudiArabiaId) { (areaItems) in
            KMAUIParse.shared.getLandPlans(items: areaItems) { (items) in
                completion(items)
            }
        }
    }
    
    /**
     Get land plans
     */
    
    public func getLandPlans(items: [KMAMapAreaStruct], completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
        var items = items
        
        // Get plans for regions
        var parseItems = [PFObject]()
        
        for item in items {
            parseItems.append(PFObject(withoutDataWithClassName: "KMAMapArea", objectId: item.objectId))
        }
        
        // Clean the land plands
        for (index, item) in items.enumerated() {
            var itemObject = item
            itemObject.landPlans = [KMAUILandPlanStruct]()
            items[index] = itemObject
        }
        
        if !parseItems.isEmpty {
            let query = PFQuery(className: "KMALandPlan")
            query.order(byAscending: "planName")
            query.whereKey("region", containedIn: parseItems)
            
            query.findObjectsInBackground { (plans, error) in
                if let error = error {
                    print("Error getting the Land Plans for regions: \(error.localizedDescription).")
                    completion(items)
                } else if let plans = plans {
                    if plans.isEmpty {
                        print("No Land Plans loaded for regions.")
                    } else {
                        print("\nLand Plans loaded for regions: \(plans.count)")
                        
                        for plan in plans {
                            var landPlanObject = KMAUILandPlanStruct()
                            
                            // planName
                            if let planName = plan["planName"] as? String {
                                landPlanObject.landName = planName
                            }
                            // startDate
                            if let startDate = plan["startDate"] as? Date {
                                landPlanObject.startDate = startDate
                            }
                            // endDate
                            if let endDate = plan["endDate"] as? Date {
                                landPlanObject.endDate = endDate
                            }
                            // subLandsCount
                            if let subLandsCount = plan["subLandsCount"] as? Int {
                                landPlanObject.subLandsCount = subLandsCount
                            }
                            // landArea
                            if let landArea = plan["landArea"] as? String {
                                landPlanObject.geojson = landArea
                            }
                            // centerCoordinate
                            if let location = plan["location"] as? PFGeoPoint {
                                landPlanObject.centerCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                            }
                            // minX, minY
                            if let minX = plan["minX"] as? Double, let minY = plan["minY"] as? Double {
                                landPlanObject.sw = CLLocationCoordinate2D(latitude: minY, longitude: minX)
                            }
                            // maxX, maxY
                            if let maxX = plan["maxX"] as? Double, let maxY = plan["maxY"] as? Double {
                                landPlanObject.ne = CLLocationCoordinate2D(latitude: maxY, longitude: maxX)
                            }

                            if let region = plan["region"] as? PFObject, let regionId = region.objectId {
                                // Region id
                                landPlanObject.regionId = regionId
                                // Arrays of Plan Land for regions
                                for (index, item) in items.enumerated() {
                                    if item.objectId == regionId {
                                        var itemObject = item
                                        var landPlans = itemObject.landPlans
                                        landPlans.append(landPlanObject)
                                        itemObject.landPlans = landPlans
                                        items[index] = itemObject
                                        
                                        break
                                    }
                                }
                            }
                        }
                        
                        completion(items)
                    }
                }
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
    
    // MARK: - Joined regions for lotteries
    
    public func getLandPlanCitizenRegions(citizenId: String, completion: @escaping (_ regionIds: [String])->()) {
        let query = PFQuery(className: "KMALotteryMember")
        query.whereKey("citizen", equalTo: PFUser(withoutDataWithObjectId: citizenId))
        query.whereKey("isActive", equalTo: true)
        
        query.findObjectsInBackground { (regions, error) in
            var regionIds = [String]()
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let regions = regions {
                for region in regions {
                    if let regionObject = region["region"] as? PFObject, let objectId = regionObject.objectId, !regionIds.contains(objectId) {
                        regionIds.append(objectId)
                    }
                }
            }
            
            completion(regionIds)
        }
    }
    
    // MARK: - Join / leave queue
    
    public func setLotteryMember(citizenId: String, regionId: String, isActive: Bool, completion: @escaping (_ done: Bool)->()) {
        // Check if item exists
        let query = PFQuery(className: "KMALotteryMember")
        query.whereKey("citizen", equalTo: PFUser(withoutDataWithObjectId: citizenId))
        query.whereKey("region", equalTo: PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId))
        query.limit = 1
        // Get results
        query.findObjectsInBackground { (items, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else if let items = items {
                if items.isEmpty {
                    let newItem = PFObject(className: "KMALotteryMember")
                    newItem["citizen"] = PFUser(withoutDataWithObjectId: citizenId)
                    newItem["region"] = PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId)
                    newItem["isActive"] = isActive
                    // Save new item
                    newItem.saveInBackground { (success, saveError) in
                        if let saveError = saveError {
                            print(saveError.localizedDescription)
                            completion(false)
                        } else if success {
                            print("New lottery member added with status `\(isActive)`.")
                            completion(true)
                        }
                    }
                } else {
                    let item = items[0]
                    item["isActive"] = isActive
                    // Save result
                    item.saveInBackground { (success, saveError) in
                        if let saveError = saveError {
                            print(saveError.localizedDescription)
                            completion(false)
                        } else if success {
                            print("Lottery member status changed to `\(isActive)`.")
                            completion(true)
                        }
                    }
                }
            }
        }
    }
}
