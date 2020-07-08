//
//  KMAParse.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Parse

final public class KMAUIParse {
    // Access variable
    public static let shared = KMAUIParse()
    
    public func getMapAreas(level: Int, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil, parentObjectId: String, updatedAfter: Date? = nil, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        getMapAreas(skip: 0, sw: sw, ne: ne, items: [KMAMapAreaStruct](), level: level, parentObjectId: parentObjectId, updatedAfter: updatedAfter) { (items) in
            completion(items)
        }
    }
    
    /**
     Get the map area
     */
    
    public func getMapAreas(skip: Int, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil,  items: [KMAMapAreaStruct], level: Int, parentObjectId: String, updatedAfter: Date? = nil, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
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
        
        // set search radius
        if let sw = sw,
            let ne = ne {
            mapAreaQuery.whereKey("minX", lessThan: ne.longitude)
            mapAreaQuery.whereKey("maxX", greaterThan: sw.longitude)
            mapAreaQuery.whereKey("minY", lessThan: ne.latitude)
            mapAreaQuery.whereKey("maxY", greaterThan: sw.latitude)
        }
        
        if let updatedAfter = updatedAfter {
            mapAreaQuery.whereKey("updatedAt", greaterThan: updatedAfter)
        }
        
        mapAreaQuery.order(byAscending: "nameE")
        mapAreaQuery.includeKey("country")
        mapAreaQuery.includeKey("city")
        
        // Get inf from Parse, prepare an array and return the items with the completion handler
        mapAreaQuery.findObjectsInBackground { (countriesArray, error) in
            if let error = error {
                print("Error getting countries: \(error.localizedDescription).")
            } else if let countriesArray = countriesArray {
                for country in countriesArray {
                    var item = KMAMapAreaStruct()
                    item.fillFrom(object: country)
                    
                    if item.isActive {
                        items.append(item)
                    }
                }
                
                if countriesArray.count == 100 {
                    self.getMapAreas(skip: skip + 100, sw: sw, ne: ne, items: items, level: level, parentObjectId: parentObjectId) { (itemsArray) in
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
    
    func getMapArea(objectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        // Get the countries list
        let mapAreaQuery = PFQuery(className: "KMAMapArea")
        
        mapAreaQuery.whereKey("objectId", equalTo: objectId)
        mapAreaQuery.order(byAscending: "nameE")
        mapAreaQuery.includeKey("country")
        mapAreaQuery.includeKey("city")
        
        // Get inf from Parse, prepare an array and return the items with the completion handler
        mapAreaQuery.findObjectsInBackground { (countriesArray, error) in
            if let error = error {
                print("Error getting countries: \(error.localizedDescription).")
            } else if let countriesArray = countriesArray {
                var items: [KMAMapAreaStruct] = []
                for country in countriesArray {
                    var item = KMAMapAreaStruct()
                    item.fillFrom(object: country)
                    items.append(item)
                    
                }
                completion(items)
            } else {
                completion([])
            }
        }
    }
    
    // MARK: - Joined regions for lotteries
    
    public func getLandPlanCitizenRegions(citizenId: String, updatedAfter: Date? = nil, completion: @escaping (_ joinedRegionIds: [String], _ leftRegionIds: [String])->()) {
        let query = PFQuery(className: "KMALotteryMember")
        query.whereKey("citizen", equalTo: PFUser(withoutDataWithObjectId: citizenId))
        
        if let updatedAfter = updatedAfter {
            query.whereKey("updatedAt", greaterThan: updatedAfter)
        }
        
        query.findObjectsInBackground { (regions, error) in
            // Get the changes for joined / left regions queues
            var joinedRegionIds = [String]()
            var leftRegionIds = [String]()
            
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let regions = regions {
                for region in regions {
                    if let regionObject = region["region"] as? PFObject,
                        let objectId = regionObject.objectId,
                        let isActive = region["isActive"] as? Bool {
                        if isActive {
                            if !joinedRegionIds.contains(objectId) {
                                joinedRegionIds.append(objectId)
                            }
                        } else {
                            if !leftRegionIds.contains(objectId) {
                                leftRegionIds.append(objectId)
                            }
                        }
                    }
                }
            }
            
            completion(joinedRegionIds, leftRegionIds)
        }
    }
    
    /**
     Get lotteries for region
     */
    
    public func getLotteries(regionId: String, updatedAfter: Date, hasDate: Bool, completion: @escaping (_ updatedLotteries: [KMAUILandPlanStruct])->()) {
        let query = PFQuery(className: "KMALandPlan")
        query.whereKey("region", equalTo: PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId))
        query.includeKey("region")
        query.includeKey("responsibleDivision")
        query.includeKey("responsibleDivision.mapArea")
        query.order(byDescending: "updatedAt")
        
        if hasDate {
            query.whereKey("updatedAt", greaterThan: updatedAfter)
        }
        
        query.findObjectsInBackground { (lotteriesArray, error) in
            var updatedLotteries = [KMAUILandPlanStruct]()
            
            if let error = error {
                print(error.localizedDescription)
            } else if let lotteriesArray = lotteriesArray {
                for lottery in lotteriesArray {
                    // Update in Core Data
                    var lotteryObject = KMAUILandPlanStruct()
                    lotteryObject.fillFromParse(plan: lottery)
                    // region id
                    if let region = lottery["region"] as? PFObject {
                        // Region id
                        var regionStruct = KMAMapAreaStruct()
                        regionStruct.fillFrom(object: region)
                        lotteryObject.region = regionStruct
                        lotteryObject.regionId = regionStruct.objectId
                    }
                    // Add lottery into an array
                    updatedLotteries.append(lotteryObject)
                }
            }
            
            completion(updatedLotteries)
        }
    }
    
    /**
     Get Saudi Arabia regions
     */
    
    public func getSaudiArabiaRegions(responsibleDivisionId: String? = nil, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil, regionsOnly: Bool? = nil, completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
        // Saudi Arabia Parse object id
        let saudiArabiaId = "ocRDUNG9ZR"
        // Get the items
        KMAUIParse.shared.getMapAreas(level: 2, sw: sw, ne: ne, parentObjectId: saudiArabiaId) { (areaItems) in
            if let regionsOnly = regionsOnly, regionsOnly {
                completion(areaItems)
            } else {
                KMAUIParse.shared.getLandPlans(responsibleDivisionId: responsibleDivisionId, sw: sw, ne: ne, items: areaItems) { (items) in
                    completion(items)
                }
            }
        }
    }
    
    public func getSaudiArabiaRegion(responsibleDivisionId: String? = nil, regionId: String, completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
        // Get the items
        KMAUIParse.shared.getMapArea(objectId: regionId) { (areaItems) in
            KMAUIParse.shared.getLandPlans(responsibleDivisionId: responsibleDivisionId, items: areaItems) { (items) in
                completion(items)
            }
        }
    }
    
    /**
     Get land plans
     */
    
    public func getLandPlans(responsibleDivisionId: String? = nil, landPlanId: String? = nil, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil, items: [KMAMapAreaStruct], completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
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
        
        guard !parseItems.isEmpty else {
            completion([])
            return
        }
        
        let query = PFQuery(className: "KMALandPlan")
        query.order(byDescending: "updatedAt")
        query.whereKey("region", containedIn: parseItems)
        if let objectId = responsibleDivisionId {
            query.whereKey("responsibleDivision", equalTo: PFObject(withoutDataWithClassName: "KMADepartment", objectId: objectId))
        }
        // Update the specific land plan
        if let landPlanId = landPlanId {
            query.whereKey("objectId", equalTo: landPlanId)
        }
        query.includeKey("responsibleDivision")
        query.includeKey("responsibleDivision.mapArea")
        
        // set search radius
        if let sw = sw,
            let ne = ne {
            query.whereKey("minX", lessThan: ne.longitude)
            query.whereKey("maxX", greaterThan: sw.longitude)
            query.whereKey("minY", lessThan: ne.latitude)
            query.whereKey("maxY", greaterThan: sw.latitude)
        }
        
        query.findObjectsInBackground { (plans, error) in
            if let error = error {
                print("Error getting the Land Plans for regions: \(error.localizedDescription).")
                completion(items)
            } else if let plans = plans {
                if plans.isEmpty {
                    print("\nNo Land Plans loaded for regions.")
                } else {
                    print("\nLand Plans loaded for regions: \(plans.count)")
                    
                    for plan in plans {
                        var landPlanObject = KMAUILandPlanStruct()
                        landPlanObject.fillFromParse(plan: plan)
                        // Check if isDeleted
                        if !landPlanObject.isDeleted {
                            // region id
                            if let region = plan["region"] as? PFObject, let regionId = region.objectId {
                                // Region id
                                landPlanObject.regionId = regionId
                                // Arrays of Plan Land for regions
                                for (index, item) in items.enumerated() {
                                    if item.objectId == regionId {
                                        var itemObject = item
                                        var landPlans = itemObject.landPlans
                                        landPlanObject.queueCount = item.lotteryMembersCount
                                        landPlans.append(landPlanObject)
                                        itemObject.landPlans = landPlans
                                        items[index] = itemObject
                                        
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                                
                // Order regions to have regions with lotteries displayed on the top
                var regionsWithLotteries = [KMAMapAreaStruct]()
                var regionsEmpty = [KMAMapAreaStruct]()
                
                for region in items {
                    if region.landPlans.isEmpty {
                        regionsEmpty.append(region)
                    } else {
                        regionsWithLotteries.append(region)
                    }
                }
                
                items = [KMAMapAreaStruct]()
                items.append(contentsOf: regionsWithLotteries)
                items.append(contentsOf: regionsEmpty)
                
                completion(items)
            }
        }
    }
    
    public func getLandPlan(landPlanId: String, completion: @escaping (_ landPlan: KMAUILandPlanStruct?, _ error: String?)->()) {
        let query = PFQuery(className: "KMALandPlan")
        query.whereKey("objectId", equalTo: landPlanId)
        query.includeKey("responsibleDivision")
        query.includeKey("responsibleDivision.mapArea")
        query.includeKey("region")
        
        query.findObjectsInBackground { (plans, error) in
            if let error = error {
                print("Error getting the Land Plans for regions: \(error.localizedDescription).")
                completion(nil, error.localizedDescription)
            } else if let plans = plans {
                guard let plan = plans.first else {
                    print("\nNo Land Plans loaded for regions.")
                    completion(nil, "Land plan not found.")
                    return
                }
                
                print("\nLand Plans loaded for regions: \(plans.count)")
                
                var landPlanObject = KMAUILandPlanStruct()
                landPlanObject.fillFromParse(plan: plan)
                // region id
                if let region = plan["region"] as? PFObject, let regionId = region.objectId {
                    // Region id
                    var regionStruct = KMAMapAreaStruct()
                    regionStruct.fillFrom(object: region)
                    landPlanObject.regionId = regionId
                    landPlanObject.regionName = regionStruct.nameE
                    landPlanObject.region = regionStruct
                    landPlanObject.queueCount = regionStruct.lotteryMembersCount
                }
                
                completion(landPlanObject, "")
            }
        }
    }
    
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
                let region = PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId)
                
                if items.isEmpty {
                    let newItem = PFObject(className: "KMALotteryMember")
                    newItem["citizen"] = PFUser(withoutDataWithObjectId: citizenId)
                    newItem["region"] = region
                    newItem["isActive"] = isActive
                    // Save new item
                    newItem.saveInBackground { (success, saveError) in
                        if let saveError = saveError {
                            print(saveError.localizedDescription)
                            completion(false)
                        } else if success {
                            print("New lottery member added with status `\(isActive)`.")
                            // Update members for region
                            if isActive {
                                region.incrementKey("lotteryMembersCount")
                            } else {
                                region.incrementKey("lotteryMembersCount", byAmount: -1)
                            }
                            region.saveInBackground()
                            // Data saved
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
                            //                            print("Lottery member status changed to `\(isActive)`.")
                            // Update members for region
                            if isActive {
                                region.incrementKey("lotteryMembersCount")
                            } else {
                                region.incrementKey("lotteryMembersCount", byAmount: -1)
                            }
                            region.saveInBackground()
                            // Data saved
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Get queue for region
    
    public func getQueue(regionId: String, completion: @escaping (_ citizens: [KMAPerson])->()) {
        // Load citizens for region queue
        let query = PFQuery(className: "KMALotteryMember")
        query.whereKey("region", equalTo: PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId))
        query.whereKey("isActive", equalTo: true)
        query.includeKey("citizen")
        query.includeKey("citizen.homeAddress")
        query.includeKey("citizen.homeAddress.building")
        query.order(byAscending: "createdAt")
        // Citizen query
        let citizenQuery = PFQuery(className: "_User")
        citizenQuery.whereKey("receivedSubLand", equalTo: false)
        query.whereKey("citizen", matchesQuery: citizenQuery)
        
        // Run the query
        query.findObjectsInBackground { (citizens, error) in
            var citizensArray = [KMAPerson]()
            
            if let error = error {
                print(error.localizedDescription)
            } else if let citizens = citizens {
                for lotteryMember in citizens {
                    if let objectId = lotteryMember.objectId, let person = lotteryMember["citizen"] as? PFUser {
                        var personObject = KMAPerson()
                        personObject.fillFrom(person: person)
                        personObject.lotteryObjectId = objectId
                        // Only add the person to queue if he hasn't received the Sub Land yet
                        citizensArray.append(personObject)
                    }
                }
            }
            
            citizensArray = KMAUIUtilities.shared.orderPersonArray(array: citizensArray)
            
            completion(citizensArray)
        }
    }
    
    // MARK: - Lottery results
    
    /**
     Get lottery results from Parse
     */
    
    public func getLotteryResults(landPlan: KMAUILandPlanStruct, completion: @escaping (_ lottery: KMAUILandPlanStruct)->()) {
        var pairsCount = 0
        var subLandIndexes = [Int]()
        var queueIndexes = [Int]()
        var landPlan = landPlan
        
        let lotteryResultQuery = PFQuery(className: "KMALotteryResult")
        lotteryResultQuery.whereKey("landPlan", equalTo: PFObject(withoutDataWithClassName: "KMALandPlan", objectId: landPlan.landPlanId))
        lotteryResultQuery.includeKey("citizen")
        lotteryResultQuery.includeKey("citizen.homeAddress")
        lotteryResultQuery.includeKey("citizen.homeAddress.building")
        // Getting the region name
        lotteryResultQuery.includeKey("landPlan")
        lotteryResultQuery.includeKey("landPlan.region")
        lotteryResultQuery.includeKey("landPlan.responsibleDivision")
        lotteryResultQuery.includeKey("subLand")
        lotteryResultQuery.includeKey("subLand.landPlan")
        lotteryResultQuery.includeKey("subLand.landPlan.region")
        lotteryResultQuery.includeKey("subLand.landPlan.responsibleDivision")
        lotteryResultQuery.includeKey("subLand.region")
        // Only active lottery result can be accepted
        lotteryResultQuery.whereKey("isActive", equalTo: true)
        
        lotteryResultQuery.findObjectsInBackground { (results, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let results = results, !results.isEmpty {
                print("Results: \(results.count)")
                print("Sub Lands: \(landPlan.lotterySubLandArray.count)")
                print("Queue: \(landPlan.queueArray.count)")
                
                // queueResultsArray
                landPlan.queueResultsArray = [KMAPerson]()
                
                for result in results {
                    if let citizen = result["citizen"] as? PFUser,
                        let subLand = result["subLand"] as? PFObject,
                        let subLandObjectId = subLand.objectId {
                        var personObject = KMAPerson()
                        personObject.fillFrom(person: citizen)
                        // Only add the person to queue if he hasn't received the Sub Land yet
                        landPlan.queueResultsArray.append(personObject)
                        queueIndexes.append(landPlan.queueResultsArray.count - 1)
                        // Getting Sub Land indexes
                        for (index, subLandItem) in landPlan.lotterySubLandArray.enumerated() {
                            if subLandObjectId == subLandItem.objectId {
                                subLandIndexes.append(index)
                                // Update the sub land item with the confirmed, status and paid data
                                var subLandCopy = subLandItem
                                // Status
                                if let status = result["status"] as? String {
                                    subLandCopy.status = status
                                }
                                // Update the Sub land info
                                landPlan.lotterySubLandArray[index] = subLandCopy
                                // Quit the loop
                                break
                            }
                        }
                    }
                }
                
                landPlan.queueResultsDisplay = landPlan.queueResultsArray
                pairsCount = subLandIndexes.count
            }
            
            landPlan.pairsCount = pairsCount
            landPlan.subLandIndexes = subLandIndexes
            landPlan.queueIndexes = queueIndexes
            landPlan.resultLoaded = true
            
            completion(landPlan)
        }
    }
    
    public func getCitizenResults(sublandPlan: KMAUISubLandStruct, completion: @escaping (_ person: KMAPerson?)->()) {
        let lotteryResultQuery = PFQuery(className: "KMALotteryResult")
        lotteryResultQuery.whereKey("subLand", equalTo: PFObject(withoutDataWithClassName: "KMASubLand", objectId: sublandPlan.objectId))
        lotteryResultQuery.includeKey("citizen")
        lotteryResultQuery.includeKey("citizen.homeAddress")
        lotteryResultQuery.includeKey("citizen.homeAddress.building")
        // Only active lottery result can be accepted
        lotteryResultQuery.whereKey("isActive", equalTo: true)
        
        lotteryResultQuery.findObjectsInBackground { (results, error) in
            var personObject: KMAPerson?
            if let error = error {
                print(error.localizedDescription)
            } else if let result = results?.first {
                
                if let citizen = result["citizen"] as? PFUser {
                    personObject = KMAPerson()
                    personObject?.fillFrom(person: citizen)
                }
            }
            
            completion(personObject)
        }
    }
    
    public func getLotteryResult(lotteryResultId: String, fileName: String, completion: @escaping (_ citizen: KMAPerson, _ error: String, _ document: KMADocumentData, _ subLand: KMAUISubLandStruct, _ loaded: Bool, _ lotteryResultStatus: String)->()) {
        let lotteryResultQuery = PFQuery(className: "KMALotteryResult")
        lotteryResultQuery.includeKey("citizen")
        lotteryResultQuery.includeKey("citizen.homeAddress")
        lotteryResultQuery.includeKey("citizen.homeAddress.building")
        lotteryResultQuery.includeKey("subLand")
        lotteryResultQuery.includeKey("subLand.landPlan")
        lotteryResultQuery.includeKey("subLand.landPlan.region")
        lotteryResultQuery.includeKey("subLand.landPlan.responsibleDivision")
        lotteryResultQuery.includeKey("subLand.region")
        // Only active lottery result can be accepted
        lotteryResultQuery.whereKey("isActive", equalTo: true)
        
        lotteryResultQuery.getObjectInBackground(withId: lotteryResultId) { (lotteryResult, error) in
            var errorValue = ""
            
            if let error = error {
                print(error.localizedDescription)
                errorValue = error.localizedDescription
            } else if let lotteryResult = lotteryResult, let lotteryResultStatus = lotteryResult["status"] as? String {
                if let citizen = lotteryResult["citizen"] as? PFUser, let subLand = lotteryResult["subLand"] as? PFObject {
                    // Citizen details
                    var citizenObject = KMAPerson()
                    citizenObject.fillFrom(person: citizen)
                    // Sub land details
                    var subLandObject = KMAUISubLandStruct()
                    subLandObject.fillFromParse(item: subLand)
                    
                    if fileName.isEmpty {
                        // This is the lotteryResultUpdate, no need to get any specific document
                        completion(citizenObject, "", KMADocumentData(), subLandObject, true, lotteryResultStatus)
                        
                        return
                    } else {
                        // Sub land images
                        for document in subLandObject.subLandImagesAllArray {
                            if document.name == fileName {
                                print("Document `\(fileName)` found:\n\(document)")
                                completion(citizenObject, "", document, subLandObject, true, lotteryResultStatus)
                                
                                return
                            }
                        }
                    }
                    
                    print("Document `\(fileName)` not found.")
                }
            }
            
            completion(KMAPerson(), errorValue, KMADocumentData(), KMAUISubLandStruct(), false, "")
        }
    }
    
    // MARK: Get rules for Land plan from Ministry
    
    public func getLotteryRules(completion: @escaping (_ rules: KMAUILotteryRules)->()) {
        // Rules query
        let rulesQuery = PFQuery(className: "KMALotteryRules")
        rulesQuery.order(byAscending: "updatedAt")
        rulesQuery.getFirstObjectInBackground { (rulesObject, error) in
            var rules = KMAUILotteryRules()
            
            if let error = error {
                print("Error loading rules: `\(error.localizedDescription)`")
            } else if let rulesObject = rulesObject {
                print("Rules from Parse: \(rulesObject)")
                rules.fillFromParse(object: rulesObject)
            }
            
            completion(rules)
        }
    }
    
    public func saveLotteryRules(rules: KMAUILotteryRules, completion: @escaping (_ done: Bool)->()) {
        KMAUIUtilities.shared.startLoading(title: "Saving...")
        // Preparing the lottery rules object
        let rulesObject = PFObject(withoutDataWithClassName: "KMALotteryRules", objectId: rules.objectId)
        // Filling the lottery rules object
        rulesObject["areaWidth"] = rules.areaWidth
        rulesObject["areaHeight"] = rules.areaHeight
        rulesObject["mainRoadWidth"] = rules.mainRoadWidth
        rulesObject["regularRoadWidth"] = rules.regularRoadWidth
        rulesObject["rowsPerBlock"] = rules.rowsPerBlock
        rulesObject["squareMeterPrice"] = rules.squareMeterPrice
        rulesObject["servicesPercent"] = rules.servicesPercent
        rulesObject["commercialPercent"] = rules.commercialPercent
        rulesObject["lotteryPercent"] = rules.lotteryPercent
        rulesObject["salePercent"] = rules.salePercent
        rulesObject["rangePercent"] = rules.rangePercent
        // Saving the lottery rules object
        rulesObject.saveInBackground { (success, error) in
            KMAUIUtilities.shared.stopLoadingWith { (done) in
                if let error = error {
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error saving the Land rules.\n\n\(error.localizedDescription)") { (done) in }
                    completion(false)
                } else if success {
                    KMAUIUtilities.shared.globalAlert(title: "Thank you!", message: "The Land rules were succesfully updated.") { (done) in }
                    completion(true)
                }
            }
        }
    }
    
    // MARK: - Get user documents from KMAUserUpload
    
    public func getDocumentsUserUploads(citizenId: String, completion: @escaping (_ documents: [KMAPropertyDocument])->()) {
        let query = PFQuery(className: "KMAUserUpload")
        query.whereKey("KMACitizen", equalTo: PFUser(withoutDataWithObjectId: citizenId))
        query.whereKeyExists("documentName")
        
        query.findObjectsInBackground { (documentsArray, error) in
            var documents = [KMAPropertyDocument]()
            
            if let error = error {
                print("Error loading documents from KMAUserUpload: \(error.localizedDescription)")
            } else if let documentsArray = documentsArray {
                for document in documentsArray {
                    var documentItem = KMAPropertyDocument()
                    documentItem.fillFrom(documentLoaded: document)
                    documents.append(documentItem)
                }
            }
            
            completion(documents)
        }
    }
    
    // MARK: - Get the property and documents for the citizen id
    
    public func updatePropertyAndDocuments(citizenId: String, completion: @escaping (_ subLands: [KMAUISubLandStruct], _ property: [KMACitizenProperty], _ documents: [KMAPropertyDocument])->()) {
        // Get Sub lands from Parse
        KMAUIPerson.shared.getCitizenSubLands(citizenId: citizenId) { (subLandsArray) in
            // Get property from Parse
            KMAUIPerson.shared.getProperty(personId: citizenId) { (propertyArray, error) in
                // Get documents from KMAUserUpload
                KMAUIParse.shared.getDocumentsUserUploads(citizenId: citizenId) { (documentsArray) in
                    // Save the property
                    let property = propertyArray
                    // Clear documents and property array
                    var uniqueDocumentIds = [String]()
                    var documents = [KMAPropertyDocument]()
                    // Fill the property items
                    for propertyItem in propertyArray {
                        let propertyDocuments = propertyItem.documents
                        // Fill the document from KMADocument
                        for document in propertyDocuments {
                            if !uniqueDocumentIds.contains(document.objectId) {
                                uniqueDocumentIds.append(document.objectId)
                                documents.append(document)
                            }
                        }
                    }
                    // Fill the documents from KMAUserUpload
                    for document in documentsArray {
                        if !uniqueDocumentIds.contains(document.objectId) {
                            uniqueDocumentIds.append(document.objectId)
                            documents.append(document)
                        }
                    }
                    // Completion handle
                    completion(subLandsArray, property, documents)
                }
            }
        }
    }
    
    // MARK: - Change status the lottery
    
    public func changeLotteryStatus(to lotteryStatus: LotteryStatus, for lotteryId: String, comment: LotteryComment? = nil, completion: @escaping (_ success: Bool, _ error: Error?)->()) {
        let object = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: lotteryId)
        object.setObject(lotteryStatus.rawValue, forKey: "lotteryStatus")
        if let comment = comment,
            let data = try? JSONSerialization.data(withJSONObject: comment.json(), options: .prettyPrinted),
            let string = String(data: data, encoding: .utf8) {
            object.setObject(string, forKey: "lotteryComments")
        }
        PFObject.saveAll(inBackground: [object]) { (success, error) in
            completion(success, error)
        }
    }
    
    // MARK: - Store comments
    
    public func storeComments(_ comment: LotteryComment, for lotteryId: String, completion: @escaping (_ error: Error?) -> Void) {
        let object = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: lotteryId)
        if let data = try? JSONSerialization.data(withJSONObject: comment.json(), options: .prettyPrinted),
            let string = String(data: data, encoding: .utf8) {
            object.setObject(string, forKey: "lotteryComments")
        }
        
        PFObject.saveAll(inBackground: [object]) { (success, error) in
            completion(error)
        }
    }
    
    // MARK: - Start the lottery
    public func startLottery(landPlan: KMAUILandPlanStruct, completion: @escaping (_ landPlan: KMAUILandPlanStruct)->()) {
        var landPlan = landPlan
        print("Eligible Sub Lands: \(landPlan.lotterySubLandArray.count), Citizens in queue: \(landPlan.queueArray.count)")
        
        // Sub Land indexes
        landPlan.subLandIndexes = [Int]()
        for index in 0..<landPlan.lotterySubLandArray.count {
            landPlan.subLandIndexes.append(index)
        }
        landPlan.subLandIndexes = landPlan.subLandIndexes.shuffled()
        
        // Qeueu indexes
        landPlan.queueIndexes = [Int]()
        for index in 0..<landPlan.queueArray.count {
            landPlan.queueIndexes.append(index)
        }
        landPlan.queueIndexes = landPlan.queueIndexes.shuffled()
        
        landPlan.pairsCount = landPlan.lotterySubLandArray.count
        
        if landPlan.queueArray.count < landPlan.lotterySubLandArray.count {
            landPlan.pairsCount = landPlan.queueArray.count
        }
        
        if landPlan.pairsCount > 0 {
            print("Pairs to be created: \(landPlan.pairsCount)")
            
            for index in 0..<landPlan.pairsCount {
                print("\(index + 1). Citizen \(landPlan.queueIndexes[index]) - Sub Land \(landPlan.subLandIndexes[index])")
            }
        } else {
            print("No pairs to create.")
        }
                
        // Create the array of PFObjects for KMALotteryResult
        var lotteryResults = [PFObject]()
        
        var notificationsArray = [PFObject]()
        
        for index in 0..<landPlan.pairsCount {
            let citizenIndex = landPlan.queueIndexes[index]
            let subLandIndex = landPlan.subLandIndexes[index]
            
            let citizen = landPlan.queueArray[citizenIndex]
            let subLand = landPlan.lotterySubLandArray[subLandIndex]
            
            let newLotteryResult = PFObject(className: "KMALotteryResult")
            newLotteryResult["citizen"] = PFUser(withoutDataWithObjectId: citizen.objectId)
            newLotteryResult["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLand.objectId)
            newLotteryResult["landPlan"] = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: landPlan.landPlanId)
            newLotteryResult["status"] = "pending"
            lotteryResults.append(newLotteryResult)
            
            // Prepare the notification Parse object
            let newNotification = PFObject(className: "KMANotification")
            newNotification["user"] = PFUser(withoutDataWithObjectId: citizen.objectId)
            newNotification["title"] = "Land lottery win!"
            newNotification["message"] = "You've received the sub land \(subLand.subLandId) as a result of the \(landPlan.landName) lottery draw in \(landPlan.region.nameE) Region."
            // Fill the items for Notification
            let items = ["objectId": subLand.objectId as AnyObject,
                         "objectType": "subLand" as AnyObject,
                         "eventType": "lotteryWin" as AnyObject,
                         "subLandId": subLand.subLandId as AnyObject,
                         "landPlanName": landPlan.landName as AnyObject,
                         "landPlanId": landPlan.landPlanId as AnyObject,
                         "region": landPlan.region.nameE as AnyObject,
                         "regionId": landPlan.region.objectId as AnyObject
            ]
            // items json string from dictionary
            if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                newNotification["items"] = jsonStr
            }
            newNotification["read"] = false
            notificationsArray.append(newNotification)
        }
        
        // Saving the lottery results array
        PFObject.saveAll(inBackground: lotteryResults) { (success, error) in
            if let error = error {
                KMAUIUtilities.shared.stopLoadingWith { (done) in
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error saving the lottery results.\n\n\(error.localizedDescription)") { (done) in }
                }
            } else if success {
                print("Lottery results saved.")
                
                // Save notifications
                if !notificationsArray.isEmpty {
                    PFObject.saveAll(inBackground: notificationsArray) { (notificationsSaved, notificationsSaveError) in
                        if let notificationsSaveError = notificationsSaveError {
                            print("Error saving notifications: \(notificationsSaveError.localizedDescription)")
                        } else {
                            print("Notifications saved, add the notification id into the push payload")
                        }
                        
                        // Push params array
                        var pushParams = [[String: AnyObject]]()
                        
                        // Prepare the push data
                        for index in 0..<landPlan.pairsCount {
                            let citizenIndex = landPlan.queueIndexes[index]
                            let subLandIndex = landPlan.subLandIndexes[index]
                            
                            let citizen = landPlan.queueArray[citizenIndex]
                            let subLand = landPlan.lotterySubLandArray[subLandIndex]
                            
                            // Fill the items for Notification
                            var items = ["objectId": subLand.objectId as AnyObject,
                                         "objectType": "subLand" as AnyObject,
                                         "eventType": "lotteryWin" as AnyObject,
                                         "subLandId": subLand.subLandId as AnyObject,
                                         "landPlanName": landPlan.landName as AnyObject,
                                         "landPlanId": landPlan.landPlanId as AnyObject,
                                         "region": landPlan.region.nameE as AnyObject,
                                         "regionId": landPlan.region.objectId as AnyObject
                            ]
                            
                            if notificationsArray.count == landPlan.pairsCount {
                                let notificationObject = notificationsArray[index]
                                
                                if let notificationId = notificationObject.objectId {
                                    items["notificationId"] = notificationId as AnyObject
                                }
                            }
                            
                            // Push parameters
                            let newSubLandParams = [
                                "userId" : citizen.objectId as AnyObject,
                                "title": "Land lottery win!" as AnyObject,
                                "message": "You've received the sub land \(subLand.subLandId) as a result of the \(landPlan.landName) lottery draw in \(landPlan.region.nameE) Region." as AnyObject,
                                "kmaItems": items as AnyObject,
                                "appType": "Consumer" as AnyObject
                            ]
                            
                            pushParams.append(newSubLandParams)
                        }
                        
                        // Send push notifications to the winners
                        for subLandParams in pushParams {
                            print("\nSend a push notification: \(subLandParams)")
                            KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                        }
                    }
                }
                // Update the Land plan status
                let landPlanObject = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: landPlan.landPlanId)
                landPlanObject["lotteryStatus"] = "Finished"
                
                landPlanObject.saveInBackground { (saveSuccess, saveError) in
                    if let saveError = saveError {
                        KMAUIUtilities.shared.stopLoadingWith { (done) in
                            print(saveError.localizedDescription)
                            KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error saving the lottery results.\n\n\(saveError.localizedDescription)") { (done) in }
                        }
                    } else {
                        print("Land Plan status changed to completed.")
                        landPlan.lotteryStatus = .finished
                        completion(landPlan)
                    }
                }
            }
        }
    }
    
    // MARK: - Citizens
    
    /**
     Get the citizen details by citizen id
     */
    
    public func loadCitizenDetails(citizenId: String, completion: @escaping (_ citizenObject: PFUser)->()) {
        let peopleQuery = PFQuery(className: "_User")
        peopleQuery.whereKey("objectId", equalTo: citizenId)
        peopleQuery.includeKey("homeAddress")
        peopleQuery.includeKey("homeAddress.building")
        peopleQuery.limit = 1
        
        peopleQuery.findObjectsInBackground { (people, error) in
            if let error = error {
                print("Error loading citizens: \(error.localizedDescription)")
                completion(PFUser())
            } else if let people = people, !people.isEmpty,
                let person = people[0] as? PFUser {
                completion(person)
            }
        }
    }
    
    /**
     Get the citizen propety and uploads
     */
    
    public func loadCitizensPropertyUploads(citizenId: String, completion: @escaping (_ subLands: [KMAUISubLandStruct], _ property: [KMACitizenProperty], _ uploads: [KMACitizenUpload])->()) {
        // Get Sub lands from Parse
        KMAUIPerson.shared.getCitizenSubLands(citizenId: citizenId) { (subLandsArray) in
            // Get property from Parse
            KMAUIPerson.shared.getProperty(personId: citizenId) { (propertyArray, error) in
                // Get uploads from Parse
                KMAUIPerson.shared.getUploads(personId: citizenId, skip: 0, uploadArrayCurrent: [PFObject]()) { (uploadArray, error) in
                    completion(subLandsArray, propertyArray, uploadArray)
                }
            }
        }
    }
    
    /**
     Get the citizens list from Parse
     */
    
    public func loadCitizens(completion: @escaping (_ citizens: [KMAPerson], _ citizensBackup: [KMAPerson])->()) {
        let peopleQuery = PFQuery(className: "_User")
        peopleQuery.order(byDescending: "uploadsCount")
        peopleQuery.includeKey("homeAddress")
        peopleQuery.includeKey("homeAddress.building")
        
        peopleQuery.findObjectsInBackground { (people, error) in
            var citizens = [KMAPerson]()
            var citizensBackup = [KMAPerson]()
            
            if let error = error {
                print("Error loading citizens: \(error.localizedDescription)")
            } else if let people = people {
                print("Citizens loaded: \(people.count)\n")
                
                for person in people {
                    if let person = person as? PFUser {
                        var personObject = KMAPerson()
                        personObject.fillFrom(person: person)
                        citizensBackup.append(personObject)
                        
                        if personObject.uploadsCount > 0 {
                            citizens.append(personObject)
                        }
                    }
                }
            }
            
            completion(citizens, citizensBackup)
        }
    }
    
    // MARK: - Search methods
    
    public func universalSearch(searchObject: KMAUISearch, completion: @escaping (_ searchObject: KMAUISearch)->()) {
        // Backup the Search object
        var searchObject = searchObject
        // Check if search is empty
        if searchObject.search.isEmpty {
            print("The search is empty")
            searchObject.clearSearch()
            completion(searchObject)
        } else {
            searchObject.updateSearch()
            if !searchObject.citizens.isEmpty {
                completion(searchObject)
            }
            print("Searching for: \(searchObject.search)")
            // Update land plans
            landPlanSearch(search: searchObject.search, ids: searchObject.landPlansBackupIds) { (newLandPlans) in
                // Update sub lands
                self.subLandSearch(search: searchObject.search, ids: searchObject.subLandsBackupIds) { (newSubLands) in
                    // Update citizens
                    self.citizenSearch(search: searchObject.search, ids: searchObject.citizensBackupIds) { (newCitizens) in
                        // Update arrays
                        searchObject.updateArrays(newLandPlans: newLandPlans, newSubLands: newSubLands, newCitizens: newCitizens)
                        // Return the updated item
                        searchObject.updateSearch()
                        searchObject.searchActive = false
                        completion(searchObject)
                    }
                }
            }
        }
    }
    
    public func landPlanSearch(search: String, ids: [String], completion: @escaping (_ newLandPlans: [KMAUILandPlanStruct])->()) {
        // Search by: planName
        let query = PFQuery(className: "KMALandPlan")
        query.whereKey("planName", matchesRegex: String(format: "(?i)%@", search))
        query.whereKey("objectId", notContainedIn: ids)
        query.includeKey("responsibleDivision")
        query.includeKey("responsibleDivision.mapArea")
        //        query.order(byAscending: "planName")
        query.order(byDescending: "updatedAt")
        query.limit = 10
        query.findObjectsInBackground { (landPlans, error) in
            var newLandPlans = [KMAUILandPlanStruct]()
            
            if let error = error {
                print("Error loading Land plans: `\(error.localizedDescription)`.")
            } else if let landPlans = landPlans {
                for landPlan in landPlans {
                    var landPlanObject = KMAUILandPlanStruct()
                    landPlanObject.fillFromParse(plan: landPlan)
                    newLandPlans.append(landPlanObject)
                }
            }
            
            print("New Land plans found: \(newLandPlans.count)")
            completion(newLandPlans)
        }
    }
    
    public func subLandSearch(search: String, ids: [String], completion: @escaping (_ newSubLands: [KMAUISubLandStruct])->()) {
        // Search by: subLandId, subLandIndex, subLandType
        let idQuery = PFQuery(className: "KMASubLand")
        idQuery.whereKey("subLandId", matchesRegex: String(format: "(?i)%@", search))
        let indexQuery = PFQuery(className: "KMASubLand")
        indexQuery.whereKey("subLandIndex", matchesRegex: String(format: "(?i)%@", search))
        let typeQuery = PFQuery(className: "KMASubLand")
        typeQuery.whereKey("subLandType", matchesRegex: String(format: "(?i)%@", search))
        // Combined query
        let combinedQuery = PFQuery.orQuery(withSubqueries: [idQuery, indexQuery, typeQuery])
        combinedQuery.includeKey("landPlan")
        combinedQuery.includeKey("landPlan.region")
        combinedQuery.includeKey("landPlan.responsibleDivision")
        combinedQuery.includeKey("region")
        combinedQuery.order(byAscending: "subLandIndex")
        combinedQuery.whereKey("objectId", notContainedIn: ids)
        combinedQuery.limit = 10
        combinedQuery.findObjectsInBackground { (subLands, error) in
            var newSubLands = [KMAUISubLandStruct]()
            
            if let error = error {
                print("Error loading Sub lands: `\(error.localizedDescription)`.")
            } else if let subLands = subLands {
                for subLand in subLands {
                    var subLandObject = KMAUISubLandStruct()
                    subLandObject.fillFromParse(item: subLand) //, noRegion: true)
                    newSubLands.append(subLandObject)
                }
            }
            
            print("New Sub lands found: \(newSubLands.count)")
            completion(newSubLands)
        }
    }
    
    public func updateDocumentStatus(subLandId: String, documentId: String, status: String, comment: String? = nil, subLand: KMAUISubLandStruct, completion: @escaping (_ done: Bool)->()) {
        let query = PFQuery(className: "KMASubLand")
        query.getObjectInBackground(withId: subLandId) { (subLandObject, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let subLandObject = subLandObject {
                if let subLandImages = subLandObject["subLandImages"] as? String {
                    let currentDict = KMAUIUtilities.shared.jsonToDictionary(jsonText: subLandImages)
                    
                    if var files = currentDict["files"] as? [[String: AnyObject]] {
                        for (index, file) in files.enumerated() {
                            if let fileObjectId = file["objectId"] as? String {
                                if fileObjectId == documentId {
                                    var fileUpdated = file
                                    fileUpdated["status"] = status as AnyObject
                                    
                                    // Add the comment if included
                                    if let comment = comment, !comment.isEmpty {
                                        var commentDictionary = [String: AnyObject]()
                                        commentDictionary["text"] = comment as AnyObject
                                        commentDictionary["action"] = status as AnyObject
                                        commentDictionary["createdAt"] = KMAUIUtilities.shared.UTCStringFrom(date: Date()) as AnyObject
                                        commentDictionary["departmentId"] = subLand.departmentId as AnyObject
                                        commentDictionary["departmentName"] = subLand.departmentName as AnyObject
                                        
                                        var commentsArray = [[String: AnyObject]]()
                                        
                                        // Check if previous comments exist
                                        if let commentsDictionaryString = fileUpdated["comments"] as? String {
                                            let commentsDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: commentsDictionaryString)
                                            
                                            if let commentsArrayLoaded = commentsDictionary["comments"] as? [[String: AnyObject]], !commentsArrayLoaded.isEmpty {
                                                commentsArray = commentsArrayLoaded
                                            }
                                        }
                                        
                                        // Add the new comment to be the first in the row
                                        commentsArray.insert(commentDictionary, at: 0)
                                        
                                        let commentsDictionary = ["comments": commentsArray]
                                        let jsonCommentsDictionary = KMAUIUtilities.shared.dictionaryToJSONData(dict: commentsDictionary)
                                        var commentsString = ""
                                        
                                        // JSON String for Parse
                                        if let commentsStringValue = String(data: jsonCommentsDictionary, encoding: .utf8) {
                                            commentsString = commentsStringValue
                                        }
                                        
                                        fileUpdated["comments"] = commentsString as AnyObject
                                    }
                                    
                                    files[index] = fileUpdated
                                    
                                    let jsonFileBodyData = KMAUIUtilities.shared.dictionaryToJSONData(dict: ["files": files])
                                    var fileBody = ""
                                    
                                    // JSON String for Parse
                                    if let jsonFileBodyString = String(data: jsonFileBodyData, encoding: .utf8) {
                                        fileBody = jsonFileBodyString
                                    }
                                    
                                    subLandObject["subLandImages"] = fileBody
                                    subLandObject.saveInBackground { (success, error) in
                                        KMAUIUtilities.shared.stopLoadingWith { (_) in
                                            if let error = error {
                                                KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (done) in }
                                            } else {
                                                completion(true)
                                            }
                                        }
                                    }
                                    
                                    return
                                }
                            }
                        }
                    }
                }
                
                KMAUIUtilities.shared.stopLoadingWith { (_) in
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: "Can't \(status) the attachment, please try again.") { (done) in }
                }
            }
        }
    }
    
    public func citizenSearch(search: String, ids: [String], completion: @escaping (_ newCitizens: [KMAPerson])->()) {
        // search by: fullName, objectId
        let nameQuery = PFQuery(className: "_User")
        nameQuery.whereKey("fullName", matchesRegex: String(format: "(?i)%@", search))
        let idQuery = PFQuery(className: "_User")
        idQuery.whereKey("objectId", matchesRegex: String(format: "(?i)%@", search))
        // Combined query
        let combinedQuery = PFQuery.orQuery(withSubqueries: [nameQuery, idQuery])
        combinedQuery.includeKey("homeAddress")
        combinedQuery.includeKey("homeAddress.building")
        combinedQuery.order(byAscending: "fullName")
        combinedQuery.whereKey("objectId", notContainedIn: ids)
        combinedQuery.limit = 10
        combinedQuery.findObjectsInBackground { (citizens, error) in
            var newCitizens = [KMAPerson]()
            
            if let error = error {
                print("Error loading Sub lands: `\(error.localizedDescription)`.")
            } else if let citizens = citizens {
                for citizen in citizens {
                    if let citizen = citizen as? PFUser {
                        var citizenObject = KMAPerson()
                        citizenObject.fillFrom(person: citizen)
                        newCitizens.append(citizenObject)
                    }
                }
            }
            
            print("New Citizens found: \(newCitizens.count)")
            completion(newCitizens)
        }
    }
    
    // MARK: - Push notifications
    
    /**
     Send a push notification to user
     */
    
    public func sendPushNotification(cloudParams: [String: AnyObject]) {
        PFCloud.callFunction(inBackground: "pushToUser", withParameters: cloudParams) { (result, error) in
            if let error = error {
                print("Error sending push notification: `\(error.localizedDescription)`")
            } else if let result = result {
                if let resultString = result as? String, resultString == "Message sent!" {
                    print("Push notifications sent.")
                } else {
                    print("Wrong result.")
                }
            }
        }
    }
    
    // MARK: - Get Sub land by objectId
    
    public func getSubLand(objectId: String, completion: @escaping (_ updatedSubLand: KMAUISubLandStruct)->()) {
        // Search by: subLandId, subLandIndex, subLandType
        let query = PFQuery(className: "KMASubLand")
        query.includeKey("landPlan")
        query.includeKey("landPlan.region")
        query.includeKey("landPlan.responsibleDivision")
        query.includeKey("region")
        query.getObjectInBackground(withId: objectId) { (subLandValue, error) in
            var updatedSubLand = KMAUISubLandStruct()
            
            if let error = error {
                print("Error loading Sub lands: `\(error.localizedDescription)`.")
            } else if let subLandValue = subLandValue {
                updatedSubLand.fillFromParse(item: subLandValue)
            }
            
            completion(updatedSubLand)
        }
    }
    
    // MARK: - Get Departments in area
    
    public func getDepartments(sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil, completion: @escaping ([KMADepartmentStruct]) -> Void) {
        
        let query = PFQuery(className:"KMADepartment")
        
        if let sw = sw,
            let ne = ne {
            let southWest = PFGeoPoint(latitude: sw.latitude, longitude: sw.longitude)
            let northEast = PFGeoPoint(latitude: ne.latitude, longitude: ne.longitude)
            query.whereKey("location", withinGeoBoxFromSouthwest: southWest, toNortheast: northEast)
        }
        
        query.whereKey("type", equalTo: "department")
        query.includeKey("mapArea")
        query.findObjectsInBackground { (departments, error) in
            var newDepartments = [KMADepartmentStruct]()
            
            if let error = error {
                print("Error loading Sub lands: `\(error.localizedDescription)`.")
            } else if let departments = departments {
                for department in departments {
                    var departmentObject = KMADepartmentStruct()
                    departmentObject.fillFromParse(departmentObject: department)
                    newDepartments.append(departmentObject)
                }
            }
            
            completion(newDepartments)
        }
    }
    
    // MARK: - Update Notifications
    
    public func updateNotifications(hasUpdatedAt: Bool, updatedAt: Date, notificationsType: String, completion: @escaping (_ notificationsArray: [KMANotificationStruct])->()) {
        let query = PFQuery(className: "KMANotification")
        query.order(byDescending: "createdAt")
        
        if let currentUser = PFUser.current() {
            query.whereKey("user", equalTo: currentUser)
        }
        
        // Check if updatedAt check required
        if hasUpdatedAt {
            query.whereKey("updatedAt", greaterThan: updatedAt)
        }
        
        var updatedNotifications = [KMANotificationStruct]()
        
        query.findObjectsInBackground { (notifications, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let notifications = notifications {
                for notification in notifications {
                    var notificationObject = KMANotificationStruct()
                    notificationObject.fillFromParse(object: notification)
                    updatedNotifications.append(notificationObject)
                }
            }
            
            // Clear notification arrays
            KMAUIConstants.shared.landLotteryNotifications = [KMANotificationStruct]()
            KMAUIConstants.shared.landCasesNotifications = [KMANotificationStruct]()
            KMAUIConstants.shared.trespassCasesNotifications = [KMANotificationStruct]()
            KMAUIConstants.shared.generalNotifications = [KMANotificationStruct]()
            // Fill notification arrays
            for notification in updatedNotifications {
                let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: notification.items)
                // Get events
                if let eventType = dict["eventType"] as? String, !eventType.isEmpty {
                    // Setup notifications
                    if KMAUIConstants.shared.landLotteryTypes.contains(eventType) {
                        KMAUIConstants.shared.landLotteryNotifications.append(notification)
                    } else if KMAUIConstants.shared.landCasesTypes.contains(eventType) {
                        KMAUIConstants.shared.landCasesNotifications.append(notification)
                    } else if KMAUIConstants.shared.trespassCasesTypes.contains(eventType) {
                        KMAUIConstants.shared.trespassCasesNotifications.append(notification)
                    } else {
                        KMAUIConstants.shared.generalNotifications.append(notification)
                    }
                } else {
                    KMAUIConstants.shared.generalNotifications.append(notification)
                }
            }
            
            var notificationsArray = KMAUIConstants.shared.generalNotifications // general
            
            if notificationsType == "landLottery" {
                notificationsArray = KMAUIConstants.shared.landLotteryNotifications
            } else if notificationsType == "landCases" {
                notificationsArray = KMAUIConstants.shared.landCasesNotifications
            } else if notificationsType == "trespassCases" {
                notificationsArray = KMAUIConstants.shared.trespassCasesNotifications
            }
             
            completion(notificationsArray)
        }
    }
    
    public func setNotificationRead(notificationId: String, completion: @escaping (_ read: Bool)->()) {
        let notificationObject = PFObject(withoutDataWithClassName: "KMANotification", objectId: notificationId)
        notificationObject["read"] = true
        notificationObject.saveInBackground { (success, error) in
            if let error = error {
                print("Error setting the notification \(notificationId) as read: \(error.localizedDescription)")
            } else if success {
                print("Notification \(notificationId) is set to read")
                completion(KMAUIParse.shared.updateNotificationsAfterRead(notificationId: notificationId))
            }
        }
    }
    
    public func updateNotificationsAfterRead(notificationId: String) -> Bool {
        let lotteryUpdate = updateNotificationRead(notificationId: notificationId, notifications: KMAUIConstants.shared.landLotteryNotifications)
        let landCasesUpdate = updateNotificationRead(notificationId: notificationId, notifications: KMAUIConstants.shared.landCasesNotifications)
        let trespassCasesUpdate = updateNotificationRead(notificationId: notificationId, notifications: KMAUIConstants.shared.trespassCasesNotifications)
        let generalUpdate = updateNotificationRead(notificationId: notificationId, notifications: KMAUIConstants.shared.generalNotifications)
        
        KMAUIConstants.shared.landLotteryNotifications = lotteryUpdate.0
        KMAUIConstants.shared.landCasesNotifications = landCasesUpdate.0
        KMAUIConstants.shared.trespassCasesNotifications = trespassCasesUpdate.0
        KMAUIConstants.shared.generalNotifications = generalUpdate.0
        
        if lotteryUpdate.1 || landCasesUpdate.1 || trespassCasesUpdate.1 || generalUpdate.1 {
            return true
        }
        
        return false
    }
    
    public func updateNotificationRead(notificationId: String, notifications: [KMANotificationStruct]) -> ([KMANotificationStruct], Bool) {
        var notificationsArray = notifications
        var found = false
        
        for (index, notification) in notifications.enumerated() {
            var notificationItem = notification
            
            if notificationItem.objectId == notificationId {
                found = true
                notificationItem.read = true
                print("Notification updated to be read.")
                notificationsArray[index] = notificationItem
            }
        }
        
        return (notificationsArray, found)
    }
    
    // MARK: - Random sub land for document
    
    /**
     Get the random Sub land
     */
    
    public func getRandomSubLand(completion: @escaping (_ loaded: Bool, _ subLand: KMAUISubLandStruct)->()) {
        // Get the sub lands count in the KMASubLand Parse class
        let query = PFQuery(className: "KMASubLand")
        query.whereKey("subLandType", equalTo: "Residential Lottery")
        query.countObjectsInBackground { (subLandCount, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, KMAUISubLandStruct())
            } else {
                self.getSubLand(subLandCount: Int(subLandCount)) { (loaded, subLand) in
                    completion(loaded, subLand)
                }
            }
        }
    }
    
    public func getSubLand(subLandCount: Int, completion: @escaping (_ loaded: Bool, _ subLand: KMAUISubLandStruct)->()) {
        let skip = Int.random(in: 0 ..< subLandCount)
        let randomQuery = PFQuery(className: "KMASubLand")
        randomQuery.whereKey("subLandType", equalTo: "Residential Lottery")
        randomQuery.includeKey("landPlan")
        randomQuery.includeKey("landPlan.region")
        randomQuery.includeKey("landPlan.responsibleDivision")
        randomQuery.includeKey("region")
        randomQuery.order(byAscending: "createdAt")
        randomQuery.skip = skip
        randomQuery.limit = 1
        // Get the random Sub land
        randomQuery.findObjectsInBackground { (randomSubLands, randomError) in
            if let randomError = randomError {
                print(randomError.localizedDescription)
                completion(false, KMAUISubLandStruct())
            } else if let randomSubLands = randomSubLands {
                if randomSubLands.isEmpty {
                    completion(false, KMAUISubLandStruct())
                } else {
                    var subLandObject = KMAUISubLandStruct()
                    subLandObject.fillFromParse(item: randomSubLands[0])
                    
                    if subLandObject.landPlanId.isEmpty || subLandObject.regionId.isEmpty || subLandObject.regionName != "Makkah" {
                        print("\nSub land not verified, trying again...")
                        
                        if subLandObject.landPlanId.isEmpty {
                            print("Land plan id is empty.")
                        }
                        
                        if subLandObject.regionId.isEmpty {
                            print("Region is empty")
                        }
                        
                        if subLandObject.regionName != "Makkah" {
                            if subLandObject.regionName.isEmpty {
                                print("Region name is empty")
                            } else {
                                print("Region is not Makkah - \(subLandObject.regionName)")
                            }
                        }
                        
                        // Try again
                        self.getSubLand(subLandCount: subLandCount) { (loadedValue, loadedSubLand) in
                            completion(loadedValue, loadedSubLand)
                        }
                    } else {
                        self.checkSubLandLottery(subLandId: subLandObject.objectId) { (verified, error) in
                            if verified {
                                print("\nSub land verified, land plan: \(subLandObject.landPlanName) in \(subLandObject.regionName)")
                                completion(true, subLandObject)
                            } else {
                                if error.isEmpty {
                                    // Try again
                                    self.getSubLand(subLandCount: subLandCount) { (loadedValue, loadedSubLand) in
                                        completion(loadedValue, loadedSubLand)
                                    }
                                } else {
                                    completion(false, KMAUISubLandStruct())
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func checkSubLandLottery(subLandId: String, completion: @escaping (_ loaded: Bool, _ error: String)->()) {
        let resultQuery = PFQuery(className: "KMALotteryResult")
        resultQuery.whereKey("subLand", equalTo: PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLandId))
        resultQuery.whereKey("status", notEqualTo: "declined")
        // Only active lottery result can be accepted
        resultQuery.whereKey("isActive", equalTo: true)
        resultQuery.findObjectsInBackground { (results, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else if let results = results {
                if results.isEmpty {
                    completion(true, "")
                } else {
                    completion(false, "")
                }
            }
        }
    }
    
    // MARK: - Send a document for confirmation
    
    public func sendDocument(subLand: KMAUISubLandStruct, rows: [KMADocumentData], uploadedDocument: [String: String], completion: @escaping (_ updated: Bool)->()) {
        var documentName = ""
        
        if let documentNameValue = uploadedDocument["name"] {
            documentName = documentNameValue
        }
        
        KMAUIUtilities.shared.startLoading(title: "Submitting...")
        // Save the document
        KMAUIParse.shared.saveDocument(subLandId: subLand.objectId, newDocuments: [uploadedDocument as AnyObject], recognizedDetails: rows) { (subLandUpdated) in
            // Adding the recognizedDetails
            let newLotteryResult = PFObject(className: "KMALotteryResult")
            newLotteryResult["citizen"] = PFUser.current()
            newLotteryResult["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLand.objectId)
            newLotteryResult["landPlan"] = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: subLand.landPlanId)
            newLotteryResult["status"] = "awaiting verification"
            
            newLotteryResult.saveInBackground { (success, error) in
                KMAUIUtilities.shared.stopLoadingWith { (done) in
                    if let error = error {
                        KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (loaded) in }
                    } else if success, let lotteryResultId = newLotteryResult.objectId {
                        // Send a notification to the KMADepartment user stating he has to verify the document
                        self.notifyDepartmentAdmins(subLand: subLand, lotteryResultId: lotteryResultId, eventType: "documentUploaded", status: documentName)
                        completion(true)
                    }
                }
            }
        }
    }
    
    public func notifyDepartmentAdmins(subLand: KMAUISubLandStruct, lotteryResultId: String, eventType: String, status: String) {
        if let currentUser = PFUser.current(), let fullName = currentUser["fullName"] as? String {
            var notificationTitle = "New document received"
            var notificationMessage = "The new Land document was uploaded by \(fullName) and waits for verification."
            
            if eventType == "lotteryResultUpdate" {
                notificationTitle = "New status for Sub land"
                
                if status == "declined" {
                    notificationMessage = "\(fullName) has declined the Sub land \(subLand.subLandId) from the \"\(subLand.landPlanName)\" lottery."
                } else if status == "confirmed" {
                    notificationMessage = "\(fullName) has accepted the Sub land \(subLand.subLandId) from the \"\(subLand.landPlanName)\" lottery."
                    
                    if subLand.extraPrice > 0 {
                        notificationMessage = "\(fullName) has accepted the Sub land \(subLand.subLandId) from the \"\(subLand.landPlanName)\" lottery. The extra payment of $ \(subLand.extraPrice.formatNumbersAfterDot().withCommas()) was received."
                    }
                } else if status == "awaiting payment" {
                    notificationMessage = "\(fullName) has accepted the Sub land \(subLand.subLandId) from the \"\(subLand.landPlanName)\" lottery. The extra payment of $ \(subLand.extraPrice.formatNumbersAfterDot().withCommas()) is pending."
                }
            } else if eventType == "subLandDocumentAdded" {
                notificationTitle = "New document for Sub land"
                notificationMessage = "\(fullName) has uploaded the new document called \"\(status)\" for the Sub land \(subLand.subLandId) from the \"\(subLand.landPlanName)\" lottery."
            }
            
            let query = PFQuery(className: "KMADepartmentEmployee")
            query.whereKey("department", equalTo: PFObject(withoutDataWithClassName: "KMADepartment", objectId: subLand.departmentId))
            query.whereKey("isActive", equalTo: true)
            query.includeKey("employee")
            query.findObjectsInBackground { (employees, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let employees = employees {
                    // KMANotification objects
                    var notificationsArray = [PFObject]()
                    // Push params array
                    var pushParams = [[String: AnyObject]]()
                    var itemsArray = [[String: AnyObject]]()
                    
                    print("Employees for department \(subLand.departmentId): \(employees.count)")
                    for employee in employees {
                        if let citizen = employee["employee"] as? PFUser, let citizenId = citizen.objectId {
                            print("Send a KMANotification to citizen \(citizenId)")
                            // Prepare the notification Parse object
                            let newNotification = PFObject(className: "KMANotification")
                            newNotification["user"] = PFUser(withoutDataWithObjectId: citizenId)
                            newNotification["title"] = notificationTitle
                            newNotification["message"] = notificationMessage
                            // Fill the items for Notification
                            let items = ["objectId": subLand.objectId as AnyObject,
                                         "objectType": "subLand" as AnyObject,
                                         "eventType": eventType as AnyObject,
                                         "subLandId": subLand.subLandId as AnyObject,
                                         "landPlanName": subLand.landPlanName as AnyObject,
                                         "landPlanId": subLand.landPlanId as AnyObject,
                                         "region": subLand.regionName as AnyObject,
                                         "regionId": subLand.regionId as AnyObject,
                                         "departmentId": subLand.departmentId as AnyObject,
                                         "departmentName": subLand.departmentName as AnyObject,
                                         "lotteryResultId": lotteryResultId as AnyObject,
                                         "status": status as AnyObject
                            ]
                            // Save item into array for push notifications
                            itemsArray.append(items)
                            // items json string from dictionary
                            if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                                newNotification["items"] = jsonStr
                            }
                            newNotification["read"] = false
                            notificationsArray.append(newNotification)
                        }
                    }
                    
                    if !notificationsArray.isEmpty {
                        PFObject.saveAll(inBackground: notificationsArray) { (success, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else if success {
                                for (index, notification) in notificationsArray.enumerated() {
                                    if let notificationId = notification.objectId, let citizen = notification["user"] as? PFUser, let citizenId = citizen.objectId {
                                        var items = itemsArray[index]
                                        items["notificationId"] = notificationId as AnyObject
                                        // Push parameters
                                        let newSubLandParams = [
                                            "userId" : citizenId as AnyObject,
                                            "title": notificationTitle as AnyObject,
                                            "message": notificationMessage as AnyObject,
                                            "kmaItems": items as AnyObject,
                                            "appType": "Business" as AnyObject
                                        ]
                                        
                                        pushParams.append(newSubLandParams)
                                    }
                                }
                                
                                // Send push notifications to the winners
                                for subLandParams in pushParams {
                                    print("\nSend a push notification: \(subLandParams)")
                                    KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                                }
                                
                                // Also send a push to the user, stating the document received by the Department
                                if eventType == "documentUploaded" {
                                    self.notifyUser(subLand: subLand, type: "created")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Notify Department Admin
    
    public func notifyDepartmentAdmins(landPlan: KMAUILandPlanStruct, status: String, comment: String? = nil) {
        let notificationTitle = status.capitalized
        var notificationMessage = ""
        
        if status == "rejected" {
            notificationMessage = "\(landPlan.landName) is being transferred  to status \"rejected\"."
        } else if status == "approved" {
            notificationMessage = "\(landPlan.landName) is being transferred  to status \"approved to start\"."
        } else if status == "deleted" {
            notificationMessage = "\(landPlan.landName) is being transferred  to status \"deleted\"."
        }
        
        if let comment = comment, !comment.isEmpty {
            notificationMessage += "\nMinistry comment: \(comment)"
        }
        
        let responsibleDivision = landPlan.responsibleDivision
        let departmentId = responsibleDivision.departmentId
        let departmentName = responsibleDivision.departmentName
        
        let query = PFQuery(className: "KMADepartmentEmployee")
        query.whereKey("department", equalTo: PFObject(withoutDataWithClassName: "KMADepartment", objectId: departmentId))
        query.whereKey("isActive", equalTo: true)
        query.includeKey("employee")
        query.findObjectsInBackground { (employees, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let employees = employees {
                // KMANotification objects
                var notificationsArray = [PFObject]()
                // Push params array
                var pushParams = [[String: AnyObject]]()
                var itemsArray = [[String: AnyObject]]()

                print("Employees for department \(departmentId): \(employees.count)")
                for employee in employees {
                    if let citizen = employee["employee"] as? PFUser, let citizenId = citizen.objectId {
                        print("Send a KMANotification to citizen \(citizenId)")
                        // Prepare the notification Parse object
                        let newNotification = PFObject(className: "KMANotification")
                        newNotification["user"] = PFUser(withoutDataWithObjectId: citizenId)
                        newNotification["title"] = notificationTitle
                        newNotification["message"] = notificationMessage
                        // Fill the items for Notification
                        let items = ["objectId": landPlan.landPlanId as AnyObject,
                                     "objectType": "landPlan" as AnyObject,
                                     "eventType": "landPlanStatusChanged" as AnyObject,
                                     "landPlanName": landPlan.landName as AnyObject,
                                     "region": landPlan.regionName as AnyObject,
                                     "regionId": landPlan.regionId as AnyObject,
                                     "departmentId": departmentId as AnyObject,
                                     "departmentName": departmentName as AnyObject,
                                     "status": status as AnyObject
                        ]
                        // Save item into array for push notifications
                        itemsArray.append(items)
                        // items json string from dictionary
                        if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                            newNotification["items"] = jsonStr
                        }
                        newNotification["read"] = false
                        notificationsArray.append(newNotification)
                    }
                }

                if !notificationsArray.isEmpty {
                    PFObject.saveAll(inBackground: notificationsArray) { (success, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if success {
                            for (index, notification) in notificationsArray.enumerated() {
                                if let notificationId = notification.objectId, let citizen = notification["user"] as? PFUser, let citizenId = citizen.objectId {
                                    var items = itemsArray[index]
                                    items["notificationId"] = notificationId as AnyObject
                                    // Push parameters
                                    let newSubLandParams = [
                                        "userId" : citizenId as AnyObject,
                                        "title": notificationTitle as AnyObject,
                                        "message": notificationMessage as AnyObject,
                                        "kmaItems": items as AnyObject,
                                        "appType": "Business" as AnyObject
                                    ]

                                    pushParams.append(newSubLandParams)
                                }
                            }

                            // Send push notifications to the winners
                            for subLandParams in pushParams {
                                print("\nSend a push notification: \(subLandParams)")
                                KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func notifyUserPenalty(trespassCase: KMAUITrespassCaseStruct) {
        let title = "Building violation"
        let message = "As a result of the investigation on the Trespass case #\(trespassCase.caseNumber) the Municipality has decided to charge you with the penalty payment. Please send the appropriate payment as soon as possible."
        
        let newNotification = PFObject(className: "KMANotification")
        newNotification["user"] = PFUser(withoutDataWithObjectId: trespassCase.owner.objectId)
        newNotification["title"] = title
        newNotification["message"] = message
        // Fill the items for Notification
        var items = ["objectId": trespassCase.objectId as AnyObject,
                     "objectType": "trespassCase" as AnyObject,
                     "eventType": "penaltyPaymentRequest" as AnyObject
        ]
        // items json string from dictionary
        if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
            newNotification["items"] = jsonStr
        }
        newNotification["read"] = false
        // Save notification
        newNotification.saveInBackground { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if success, let notificationId = newNotification.objectId {
                items["notificationId"] = notificationId as AnyObject
                // Push parameters
                let subLandParams = [
                    "userId" : trespassCase.owner.objectId as AnyObject,
                    "title": title as AnyObject,
                    "message": message as AnyObject,
                    "kmaItems": items as AnyObject,
                    "appType": "Consumer" as AnyObject
                ]
                // Send push notification
                KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
            }
        }
    }
    
    public func notifyUser(subLand: KMAUISubLandStruct, type: String, status: String? = nil, documentName: String? = nil, citizenId: String? = nil, comment: String? = nil) {
        var title = ""
        var message = ""
        
        if type == "created" {
            // The new Document uploaded to create the KMALotteryResult
            title = "Document submitted"
            message = "Your Land document was received by the \(subLand.departmentName). You'll receive a notification when it's processed."
        } else if type == "uploaded" {
            // The new Document uploaded to the accepted KMASubLand
            if let status = status, let documentName = documentName {
                title = "Document \(status)"
                message = "The \"\(documentName)\" document for the Sub land \(subLand.subLandId) was \(status) by the \(subLand.departmentName)."
            }
        } else if type == "ownership" {
            // The new Document uploaded to the accepted KMASubLand
            if let status = status, let documentName = documentName {
                title = "Ownership \(status)"
                message = "The land ownership for Sub land \(subLand.subLandId) was \(status) by the \(subLand.departmentName) after checking the \"\(documentName)\" document."
                
                if status == "approved", subLand.extraPrice > 0 {
                    message += " The extra payment of $ \(subLand.extraPrice.formatNumbersAfterDot().withCommas()) is required."
                }
            }
        }
        
        if let comment = comment, !comment.isEmpty {
            message += "\nComment: \(comment)"
        }
        
        if !title.isEmpty, !message.isEmpty {
            if let currentUser = PFUser.current(), let currentUserId = currentUser.objectId {
                var userId = currentUserId
                // Send a message to the selected user
                if let citizenId = citizenId {
                    userId = citizenId
                }
                
                let newNotification = PFObject(className: "KMANotification")
                newNotification["user"] = PFUser(withoutDataWithObjectId: userId)
                newNotification["title"] = title
                newNotification["message"] = message
                // Fill the items for Notification
                var items = ["objectId": subLand.objectId as AnyObject,
                             "objectType": "subLand" as AnyObject,
                             "eventType": "documentUploaded" as AnyObject,
                             "subLandId": subLand.subLandId as AnyObject,
                             "landPlanName": subLand.landPlanName as AnyObject,
                             "landPlanId": subLand.landPlanId as AnyObject,
                             "region": subLand.regionName as AnyObject,
                             "regionId": subLand.regionId as AnyObject,
                             "departmentId": subLand.departmentId as AnyObject,
                             "departmentName": subLand.departmentName as AnyObject
                ]
                // items json string from dictionary
                if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                    newNotification["items"] = jsonStr
                }
                newNotification["read"] = false
                // Save notification
                newNotification.saveInBackground { (success, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if success, let notificationId = newNotification.objectId {
                        items["notificationId"] = notificationId as AnyObject
                        // Push parameters
                        let subLandParams = [
                            "userId" : userId as AnyObject,
                            "title": title as AnyObject,
                            "message": message as AnyObject,
                            "kmaItems": items as AnyObject,
                            "appType": "Consumer" as AnyObject
                        ]
                        // Send push notification
                        KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                    }
                }
            }
        }
    }
    
    /**
     Approve / Reject the Land ownership for Upload a document flow
     */
    
    public func landOwnership(lotteryResultId: String, status: String, comment: String? = nil, subLand: KMAUISubLandStruct, document: KMADocumentData, completion: @escaping (_ success: Bool)->()) {
        let lotteryResult = PFQuery(className: "KMALotteryResult")
        lotteryResult.getObjectInBackground(withId: lotteryResultId) { (lotteryResult, error) in
            if let error = error {
                KMAUIUtilities.shared.stopLoadingWith { (_) in
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (done) in }
                }
            } else if let lotteryResult = lotteryResult {
                var isActive = true
                if let isActiveValue = lotteryResult["isActive"] as? Bool, !isActiveValue {
                    isActive = isActiveValue
                }
                // Update status
                lotteryResult["status"] = status
                // Add comment
                if let comment = comment, !comment.isEmpty {
                    var commentDictionary = [String: AnyObject]()
                    commentDictionary["text"] = comment as AnyObject
                    commentDictionary["action"] = status as AnyObject
                    commentDictionary["documentId"] = document.objectId as AnyObject
                    commentDictionary["createdAt"] = KMAUIUtilities.shared.UTCStringFrom(date: Date()) as AnyObject
                    commentDictionary["departmentId"] = subLand.departmentId as AnyObject
                    commentDictionary["departmentName"] = subLand.departmentName as AnyObject
                    
                    var commentsArray = [[String: AnyObject]]()
                    
                    // Check if previous comments exist
                    if let commentsDictionaryString = lotteryResult["comments"] as? String {
                        let commentsDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: commentsDictionaryString)
                        
                        if let commentsArrayLoaded = commentsDictionary["comments"] as? [[String: AnyObject]], !commentsArrayLoaded.isEmpty {
                            commentsArray = commentsArrayLoaded
                        }
                    }
                    
                    print("Comments found: \(commentsArray.count)")
                    // Add the new comment to be the first in the row
                    commentsArray.insert(commentDictionary, at: 0)
                    print("Comments after update: \(commentsArray)")
                    
                    let commentsDictionary = ["comments": commentsArray]
                    let jsonCommentsDictionary = KMAUIUtilities.shared.dictionaryToJSONData(dict: commentsDictionary)
                    var commentsString = ""
                    
                    // JSON String for Parse
                    if let commentsStringValue = String(data: jsonCommentsDictionary, encoding: .utf8) {
                        commentsString = commentsStringValue
                    }
                    
                    lotteryResult["comments"] = commentsString as AnyObject
                }
                // Save result
                lotteryResult.saveInBackground { (success, error) in
                    if !isActive {
                        KMAUIUtilities.shared.stopLoadingWith { (_) in
                            KMAUIUtilities.shared.globalAlert(title: "Error", message: "This Land lottery result is inactive.") { (done) in }
                        }
                    } else {
                        KMAUIUtilities.shared.stopLoadingWith { (_) in
                            if let error = error {
                                KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (done) in }
                            } else if success {
                                completion(true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Save document for Sub Land
    
    public func saveDocument(subLandId: String, newDocuments: [AnyObject], recognizedDetails: [KMADocumentData]? = nil, completion: @escaping (_ updatedSubLand: KMAUISubLandStruct)->()) {
        // Update the Core Data and reload UI
        let updatedSubLand = KMAUISubLandStruct()
        
        if !newDocuments.isEmpty {
            if let newDocument = newDocuments[0] as? [String: String] {
                print("Add this new document into the `subLandImages` for the subLand \(subLandId):\n\(newDocument)")
                
                // Search by: subLandId, subLandIndex, subLandType
                let query = PFQuery(className: "KMASubLand")
                query.includeKey("landPlan")
                query.includeKey("landPlan.region")
                query.includeKey("landPlan.responsibleDivision")
                query.includeKey("region")
                
                query.getObjectInBackground(withId: subLandId) { (subLandValue, error) in
                    if let error = error {
                        print("Error loading Sub lands: `\(error.localizedDescription)`.")
                        completion(updatedSubLand)
                    } else if let subLandValue = subLandValue {
                        if let subLandImages = subLandValue["subLandImages"] as? String, !subLandImages.isEmpty {
                            let uploadBodyDictionary = KMAUIUtilities.shared.jsonToDictionary(jsonText: subLandImages)
                            
                            if var filesArray = uploadBodyDictionary["files"] as? [AnyObject] {
                                filesArray.insert(newDocument as AnyObject, at: 0)
                                let fileBodyDict = ["files": filesArray as AnyObject]
                                self.saveSubLandImages(fileBodyDict: fileBodyDict, subLandValue: subLandValue, recognizedDetails: recognizedDetails) { (subLandUpdated) in
                                    completion(subLandUpdated)
                                }
                            } else {
                                completion(updatedSubLand)
                            }
                        } else {
                            print("No documents uploaded yet")
                            let fileBodyDict = ["files": [newDocument] as AnyObject]
                            self.saveSubLandImages(fileBodyDict: fileBodyDict, subLandValue: subLandValue, recognizedDetails: recognizedDetails) { (subLandUpdated) in
                                completion(subLandUpdated)
                            }
                        }
                    }
                }
            }
        } else {
            completion(updatedSubLand)
        }
    }
    
    public func saveSubLandImages(fileBodyDict: [String: AnyObject], subLandValue: PFObject, recognizedDetails: [KMADocumentData]? = nil, completion: @escaping (_ updatedSubLand: KMAUISubLandStruct)->()) {
        var updatedSubLand = KMAUISubLandStruct()
        let jsonFileBodyData = KMAUIUtilities.shared.dictionaryToJSONData(dict: fileBodyDict)
        var fileBody = ""
        
        // JSON String for Parse
        if let jsonFileBodyString = String(data: jsonFileBodyData, encoding: .utf8) {
            fileBody = jsonFileBodyString
        }
        
        subLandValue["subLandImages"] = fileBody
        
        // Check for recognizedDetails
        if let recognizedDetails = recognizedDetails {
            var recognizedDetailsDictionary = [String: AnyObject]()
            
            for value in recognizedDetails {
                recognizedDetailsDictionary[value.type] = value.name as AnyObject
            }
            
            let recognizedItem = ["recognizedDetails": recognizedDetailsDictionary as AnyObject]
            
            let jsonRecognizedBodyData = KMAUIUtilities.shared.dictionaryToJSONData(dict: recognizedItem)
            var recognizedBody = ""
            
            // JSON String for Parse
            if let jsonRecognizedBodyString = String(data: jsonRecognizedBodyData, encoding: .utf8) {
                recognizedBody = jsonRecognizedBodyString
            }
            
            subLandValue["recognizedDetails"] = recognizedBody
        }
        
        subLandValue.saveInBackground { (success, saveError) in
            if let saveError = saveError {
                print("Error saving the document: \(saveError.localizedDescription)")
            } else if success {
                updatedSubLand.fillFromParse(item: subLandValue)
            }
            
            completion(updatedSubLand)
        }
    }
    
    /**
     Notify region queue
     */
    
    public func notifyRegionQueue(landPlanId: String, landPlanName: String, regionId: String, regionName: String, lotteryStatus: String? = nil) {
        var notificationTitle = "The new lottery in your region"
        var notificationMessage = "The \"\(landPlanName)\" lottery created in the \(regionName) region."
        var eventType = "lotteryCreated"
        
        if lotteryStatus == "Approved to start" {
            notificationTitle = "The lottery approved"
            notificationMessage = "The \"\(landPlanName)\" lottery is approved to start in the \(regionName) region."
            eventType = "lotteryUpdated"
        }
        
        KMAUIParse.shared.getQueue(regionId: regionId) { (queueArray) in
            var notificationsArray = [PFObject]()
            var pushParams = [[String: AnyObject]]()
            var itemsArray = [[String: AnyObject]]()
            
            for citizen in queueArray {
                let newNotification = PFObject(className: "KMANotification")
                newNotification["user"] = PFUser(withoutDataWithObjectId: citizen.objectId)
                newNotification["title"] = notificationTitle
                newNotification["message"] = notificationMessage
                // Fill the items for Notification
                let items = ["objectId": landPlanId as AnyObject,
                             "objectType": "landPlan" as AnyObject,
                             "eventType": eventType as AnyObject,
                             "landPlanName": landPlanName as AnyObject,
                             "region": regionName as AnyObject,
                             "regionId": regionId as AnyObject
                ]
                // Save item into array for push notifications
                itemsArray.append(items)
                // items json string from dictionary
                if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                    newNotification["items"] = jsonStr
                }
                newNotification["read"] = false
                notificationsArray.append(newNotification)
            }
            
            PFObject.saveAll(inBackground: notificationsArray) { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if success {
                    for (index, notification) in notificationsArray.enumerated() {
                        if let notificationId = notification.objectId, let citizen = notification["user"] as? PFUser, let citizenId = citizen.objectId {
                            var items = itemsArray[index]
                            items["notificationId"] = notificationId as AnyObject
                            // Push parameters
                            let newSubLandParams = [
                                "userId" : citizenId as AnyObject,
                                "title": notificationTitle as AnyObject,
                                "message": notificationMessage as AnyObject,
                                "kmaItems": items as AnyObject,
                                "appType": "Consumer" as AnyObject
                            ]
                            
                            pushParams.append(newSubLandParams)
                        }
                    }
                    
                    // Send push notifications to the winners
                    for subLandParams in pushParams {
                        print("\nSend a push notification: \(subLandParams)")
                        KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                    }
                }
            }
        }
    }
    
    /**
     Notify ministry admin about the lottery status changes
     */
    
    public func notifyMinistry(citizenDepartment: KMADepartmentStruct, landPlanId: String, landPlanName: String, regionId: String, regionName: String, lotteryStatus: String) {
        let departmentQuery = PFQuery(className: "KMADepartment")
        departmentQuery.getObjectInBackground(withId: citizenDepartment.departmentId) { (departmentObject, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let departmentObject = departmentObject {
                if let ministryObject = departmentObject["parent"] as? PFObject, let ministryId = ministryObject.objectId {
                    print("Ministry found, id: \(ministryId)")
                    // Get ministry admin
                    let adminsQuery = PFQuery(className: "KMADepartmentEmployee")
                    adminsQuery.whereKey("department", equalTo: ministryObject)
                    adminsQuery.findObjectsInBackground { (adminArray, adminError) in
                        if let adminError = adminError {
                            print(adminError.localizedDescription)
                        } else if let adminArray = adminArray {
                            if adminArray.isEmpty {
                                print("No ministry admins")
                            } else {
                                print("Ministry admins: \(adminArray.count)")
                                
                                for adminObject in adminArray {
                                    if let admin = adminObject["employee"] as? PFUser, let adminId = admin.objectId {
                                        print("Admin: \(adminId)")
                                        // Title and message
                                        let notificationTitle = lotteryStatus
                                        let notificationMessage = "\(landPlanName) is being transferred  to status \"\(lotteryStatus.lowercased())\"."
                                        // Prepare the notification Parse object
                                        let newNotification = PFObject(className: "KMANotification")
                                        newNotification["user"] = PFUser(withoutDataWithObjectId: adminId)
                                        newNotification["title"] = notificationTitle
                                        newNotification["message"] = notificationMessage
                                        // Fill the items for Notification
                                        var items = ["objectId": landPlanId as AnyObject,
                                                     "objectType": "landPlan" as AnyObject,
                                                     "eventType": "landPlanStatusChanged" as AnyObject,
                                                     "landPlanName": landPlanName as AnyObject,
                                                     "region": regionName as AnyObject,
                                                     "regionId": regionId as AnyObject,
                                                     "departmentId": citizenDepartment.departmentId as AnyObject,
                                                     "departmentName": citizenDepartment.departmentName as AnyObject,
                                                     "status": lotteryStatus as AnyObject
                                        ]
                                        // items json string from dictionary
                                        if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                                            newNotification["items"] = jsonStr
                                        }
                                        newNotification["read"] = false
                                        // Save notification
                                        newNotification.saveInBackground { (success, error) in
                                            if let error = error {
                                                print(error.localizedDescription)
                                            } else if success, let notificationId = newNotification.objectId {
                                                items["notificationId"] = notificationId as AnyObject
                                                // Push parameters
                                                let newPushParams = [
                                                    "userId" : adminId as AnyObject,
                                                    "title": notificationTitle as AnyObject,
                                                    "message": notificationMessage as AnyObject,
                                                    "kmaItems": items as AnyObject,
                                                    "appType": "Business" as AnyObject
                                                ]
                                                // Send push notification
                                                KMAUIParse.shared.sendPushNotification(cloudParams: newPushParams)
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                } else {
                    print("Ministry not found")
                }
            }
        }
    }
    
    // MARK: - Start the Lottery flow
    
    public func startLottery(lottery: KMAUILandPlanStruct, completion: @escaping (_ updatedLottery: KMAUILandPlanStruct)->()) {
        let lotteryAlert = UIAlertController(title: "Start the Lottery", message: "Are you sure you'd like to start the lottery?\n\nThis will run a random algorithm to give the Sub Land items to the Citizens.", preferredStyle: .alert)
        lotteryAlert.view.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        
        lotteryAlert.addAction(UIAlertAction(title: "Start", style: .default, handler: { (action) in
            self.startLotteryFlow(lottery: lottery) { (updatedLottery) in
                completion(updatedLottery)
            }
        }))
        
        lotteryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in }))
        
        KMAUIUtilities.shared.displayAlert(viewController: lotteryAlert)
    }
    
    public func startLotteryFlow(lottery: KMAUILandPlanStruct, completion: @escaping (_ updatedLottery: KMAUILandPlanStruct)->()) {
        var lottery = lottery
        
        KMAUIUtilities.shared.startLoading(title: "Processing...")
        // Update the queue list
        KMAUIParse.shared.getQueue(regionId: lottery.regionId) { (citizenQueue) in
            lottery.queueArray = citizenQueue
            lottery.queueDisplay = citizenQueue
            lottery.queueCount = citizenQueue.count
            lottery.setupResultArray()
            lottery.queueLoaded = true
            
            if lottery.lotterySubLandArray.isEmpty {
                KMAUIUtilities.shared.stopLoadingWith { (_) in
                    KMAUIUtilities.shared.globalAlert(title: "Warning", message: "This lottery has no Sub Land items to assign to Citizens.") { (done) in }
                }
                return
            }
            
            if lottery.queueArray.isEmpty {
                KMAUIUtilities.shared.stopLoadingWith { (_) in
                    KMAUIUtilities.shared.globalAlert(title: "Warning", message: "This lottery has no Citizens to assign the Sub Land items to.") { (done) in }
                }
                return
            }
            
            KMAUIParse.shared.startLottery(landPlan: lottery) { (landPlanUpdated) in
                // Get the lottery results data
                KMAUIParse.shared.getLotteryResults(landPlan: lottery) { (planUpdated) in
                    KMAUIUtilities.shared.stopLoadingWith { (_) in
                        lottery = planUpdated
                        lottery.lotteryStatus = landPlanUpdated.lotteryStatus
                        lottery.resultLoaded = true
                        // Return the completed lottery
                        completion(lottery)
                    }
                }
            }
        }
    }
    
    // MARK: - Get Trespass Cases
    
    public func getTrespassCases(objectId: String? = nil, completion: @escaping (_ trespassCasesArray: [KMAUITrespassCaseStruct])->()) {
        // Trespass cases array
        var trespassCases = [KMAUITrespassCaseStruct]()
        // Get details
        let query = PFQuery(className: "KMATrespassCase")
        query.order(byDescending: "updatedAt")
        query.includeKey("subLand")
        query.includeKey("subLand.landPlan")
        query.includeKey("subLand.region")
        query.includeKey("department")
        query.includeKey("department.mapArea")
        query.includeKey("owner")
        query.includeKey("owner.homeAddress")
        query.includeKey("owner.homeAddress.building")
        query.includeKey("violator")
        query.includeKey("violator.homeAddress")
        query.includeKey("violator.homeAddress.building")
        
        // Get the specific trespass case only
        if let objectId = objectId, !objectId.isEmpty {
            query.whereKey("objectId", equalTo: objectId)
        }
        
        query.findObjectsInBackground { (trespassCasesArray, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let trespassCasesArray = trespassCasesArray {
                for trespassCaseObject in trespassCasesArray {
                    var trespassCase = KMAUITrespassCaseStruct()
                    trespassCase.fillFromParse(object: trespassCaseObject)
                    trespassCases.append(trespassCase)
                }
            }

            var inProgressCases = [KMAUITrespassCaseStruct]()
            var approvedCases = [KMAUITrespassCaseStruct]()
            var declinedCases = [KMAUITrespassCaseStruct]()
            
            for trespassCase in trespassCases {
                let status = trespassCase.caseStatus
                
                if status == "Resolved" {
                    approvedCases.append(trespassCase)
                } else if status == "Declined" || status == "Outside the Urban Range" {
                    declinedCases.append(trespassCase)
                } else {
                    inProgressCases.append(trespassCase)
                }
            }
            
            trespassCases = [KMAUITrespassCaseStruct]()
            trespassCases.append(contentsOf: inProgressCases)
            trespassCases.append(contentsOf: approvedCases)
            trespassCases.append(contentsOf: declinedCases)
            
            completion(trespassCases)
            
        }
    }
    
    // MARK: - Get Land Cases
    
    public func getLandCases(objectId: String? = nil, judgeId: String? = nil, completion: @escaping (_ landCasesArray: [KMAUILandCaseStruct])->()) {
        // Land cases array
        var landCases = [KMAUILandCaseStruct]()
        // Get details
        let query = PFQuery(className: "KMALandCase")
        query.order(byDescending: "updatedAt")
        query.includeKey("citizen.homeAddress")
        query.includeKey("citizen.homeAddress.building")
        query.includeKey("citizen")
        query.includeKey("judge")
        query.includeKey("judge.homeAddress")
        query.includeKey("judge.homeAddress.building")
        query.includeKey("subLand")
        query.includeKey("subLand.landPlan")
        query.includeKey("subLand.region")
        query.includeKey("department")
        query.includeKey("department.mapArea")
        // Get specific land case for notifications
        if let objectId = objectId, !objectId.isEmpty {
            query.whereKey("objectId", equalTo: objectId)
        }
        // Get specific judge for notifcations
        if let judgeId = judgeId, !judgeId.isEmpty {
            query.whereKey("judge", equalTo: PFUser(withoutDataWithObjectId: judgeId))
        }
        query.findObjectsInBackground { (landCasesArray, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let landCasesArray = landCasesArray {
                for landCaseObject in landCasesArray {
                    var landCase = KMAUILandCaseStruct()
                    landCase.fillFromParse(object: landCaseObject)
                    landCases.append(landCase)
                }
            }

            var pendingCases = [KMAUILandCaseStruct]()
            var approvedCases = [KMAUILandCaseStruct]()
            var declinedCases = [KMAUILandCaseStruct]()
            
            for landCase in landCases {
                let status = landCase.courtStatus.lowercased()
                
                if status == "in progress" {
                    pendingCases.append(landCase)
                } else if status == "approved" {
                    approvedCases.append(landCase)
                } else if status == "declined" {
                    declinedCases.append(landCase)
                }
            }
            
            landCases = [KMAUILandCaseStruct]()
            landCases.append(contentsOf: pendingCases)
            landCases.append(contentsOf: approvedCases)
            landCases.append(contentsOf: declinedCases)
            
            completion(landCases)
        }
    }
    
    // MARK: - Get decisions for Land Case
    
    public func getLandCaseDecisions(landCaseId: String, completion: @escaping (_ decisionsArray: [KMAUIMinistryDecisionStruct], _ departmentDecisions: [KMAUIMinistryDecisionStruct])->()) {
        var ministryDecisions = [KMAUIMinistryDecisionStruct]()
        var departmentDecisions = [KMAUIMinistryDecisionStruct]()
        let query = PFQuery(className: "KMALandCaseMinistryDecision")
        query.includeKey("ministry")
        query.includeKey("ministry.mapArea")
        query.whereKey("landCase", equalTo: PFObject(withoutDataWithClassName: "KMALandCase", objectId: landCaseId))
        query.order(byDescending: "updatedAt")
        query.findObjectsInBackground { (decisions, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let decisions = decisions {
                for decision in decisions {
                    var ministryDecision = KMAUIMinistryDecisionStruct()
                    ministryDecision.fillFromParse(object: decision)
                    
                    if ministryDecision.type == "ministry" {
                        ministryDecisions.append(ministryDecision)
                    } else if ministryDecision.type == "department" {
                        departmentDecisions.append(ministryDecision)
                    }
                    
                }
            }
            completion(ministryDecisions, departmentDecisions)
        }
    }
    
    // MARK: - Uploading attachments

    /**
     Upload files method.
    */
    
    public func uploadFiles(pickedArray: [KMADocumentData], location: CLLocationCoordinate2D? = nil, subLandId: String? = nil, documentPreview: UIImage? = nil, name: String? = nil, description: String? = nil, completion: @escaping (_ urls: [AnyObject]) -> ()) {
        var objectArray = [PFObject]()
        
        for item in pickedArray {
            if let itemURL = item.url?.path, let dataObject = NSData(contentsOfFile: itemURL) {
                let documentData = KMAUIUtilities.shared.getItemData(documentObject: item)
                let newFileUpload = PFObject(className: "KMAUploadedFile")
                newFileUpload["fileName"] = documentData.1 //item.name
                newFileUpload["fileType"] = documentData.2 //item.type
                newFileUpload["fileExtension"] = documentData.3
                
                if let name = name {
                    newFileUpload["fileName"] = name
                }
                
                if let description = description {
                    newFileUpload["fileDescription"] = description
                }
                
                // Citizen
                if let citizen = PFUser.current() {
                    newFileUpload["citizen"] = citizen
                }
                
                // Sub land
                if let subLandId = subLandId, !subLandId.isEmpty {
                    newFileUpload["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLandId)
                }
                
                // Location
                if item.hasLocation {
                    print("The EXIF location is: \(item.location)")
                    newFileUpload["location"] = PFGeoPoint(latitude: item.location.latitude, longitude: item.location.longitude)
                } else if let location = location, !location.isEmpty {
                    print("The upload location is: \(location)")
                    newFileUpload["location"] = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
                }
                
                // Capture data
                if item.hasCreatedAt {
                    print("Capture date: \(item.captureDate)")
                    newFileUpload["captureDate"] = item.captureDate
                }
                
                // Address
                if !item.address.isEmpty {
                    newFileUpload["address"] = item.address
                }
                
                if let documentPreview = documentPreview, documentPreview.size.width > 0, let previewImage = documentPreview.jpegData(compressionQuality: 0.5) {
                    newFileUpload["filePreview"] = PFFileObject(name: "previewImage.jpg", data: previewImage)
                } else if documentData.0.size.width > 0, let previewImage = documentData.0.jpegData(compressionQuality: 0.5) {
                    newFileUpload["filePreview"] = PFFileObject(name: "previewImage.jpg", data: previewImage)
                }

                var fileName = "file"
                
                let fileArray = item.name.components(separatedBy: ".")
                
                if fileArray.count > 1, let last = fileArray.last {
                    fileName = "file." + last
                }
                
                newFileUpload["fileContent"] = PFFileObject(name: fileName, data: dataObject as Data)
                objectArray.append(newFileUpload)
            }
        }
        
        if objectArray.isEmpty {
            KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error uploading files. Please try again.") { (done) in }
            completion([AnyObject]())
        } else {
            if objectArray.count == 1 {
                KMAUIUtilities.shared.startLoading(title: "Uploading...")
            } else {
                KMAUIUtilities.shared.uploadProgressAlert(title: "Uploading...", message: "Progress: 0/\(objectArray.count)")
            }

            files(urls: [AnyObject](), objectArray: objectArray, index: 0) { (urlsArray) in
                if urlsArray.isEmpty || objectArray.count > urlsArray.count {
                    KMAUIUtilities.shared.stopLoadingWith(completion: { (done) in
                        KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error uploading files. Please try again.") { (done) in }
                    })
                }
                
                completion(urlsArray)
            }
        }
    }
    
    /**
         Save file and update progress.
        */
        
        public func files(urls: [AnyObject], objectArray: [PFObject], index: Int, completion: @escaping (_ urls: [AnyObject]) -> ()) {
            var urlsArray = urls
            
            // Update the progress message
            if urls.count > 1 {
                KMAUIUtilities.shared.uploadAlert.message = "Progress: \(index)/\(objectArray.count)"
            }
            
            if index < objectArray.count {
                let file = objectArray[index]
    //            print("File to save: \(file)")
                file.saveInBackground { (success, error) in
                    if let error = error {
                        print("Error saving a file: \(error.localizedDescription)")
                        completion([AnyObject]())
                    } else if success {
                        urlsArray.append(self.getUploadBody(object: file))
                        
                        self.files(urls: urlsArray, objectArray: objectArray, index: index + 1, completion: { (urlsArrayUpdated) in
                            completion((urlsArrayUpdated))
                        })
                    }
                }
            } else {
                completion(urlsArray)
            }
        }
    
    /**
     Prepare uploadBody.
    */
    
    public func getUploadBody(object: PFObject) -> AnyObject {
        var itemDictionary = [String: String]()
        
        if let fileName = object["fileName"] as? String {
            itemDictionary["name"] = fileName
        }
        
        if let fileType = object["fileType"] as? String {
            itemDictionary["type"] = fileType
        }
        
        if let filePreview = object["filePreview"] as? PFFileObject, let previewURL = filePreview.url {
            itemDictionary["previewURL"] = previewURL
        }
        
        if let fileContent = object["fileContent"] as? PFFileObject, let fileURL = fileContent.url {
            itemDictionary["fileURL"] = fileURL
        }
        
        if let fileId = object.objectId {
            itemDictionary["objectId"] = fileId
        }
        
        if let fileExtension = object["fileExtension"] as? String {
            itemDictionary["fileExtension"] = fileExtension
        }
        
        if let fileDescription = object["fileDescription"] as? String {
            itemDictionary["fileDescription"] = fileDescription
        }
        
        if let captureDate = object["captureDate"] as? Date {
            itemDictionary["captureDate"] = KMAUIUtilities.shared.UTCStringFrom(date: captureDate)
        }
        
        if let location = object["location"] as? PFGeoPoint {
            itemDictionary["latitude"] = "\(location.latitude)"
            itemDictionary["longitude"] = "\(location.longitude)"
        }
        
        if let address = object["address"] as? String {
            itemDictionary["address"] = address
        }
        
        if let createdAt = object.createdAt {
            itemDictionary["createdAt"] = KMAUIUtilities.shared.UTCStringFrom(date: createdAt)
        }
        
        if let updatedAt = object.updatedAt {
            itemDictionary["updatedAt"] = KMAUIUtilities.shared.UTCStringFrom(date: updatedAt)
        }
        
        return itemDictionary as AnyObject
    }
    
    public func checkLandCase(completion: @escaping (_ urls: [PFObject]) -> ()) {
        if let currentUser = PFUser.current() {
            let query = PFQuery(className: "KMALandCase")
            query.whereKey("citizen", equalTo: currentUser)
            // Citizen includes
            query.includeKey("citizen")
            query.includeKey("citizen.homeAddress")
            query.includeKey("citizen.homeAddress.building")
            query.includeKey("citizen.homeAddress.building.address")
            query.includeKey("citizen.homeAddress.building.address.district")
            query.includeKey("citizen.homeAddress.building.address.district.city")
            query.includeKey("citizen.homeAddress.building.address.district.city.region")
            query.includeKey("citizen.homeAddress.building.address.district.city.region.country")
            query.includeKey("citizen.homeAddress.building.address.region")
            query.includeKey("citizen.homeAddress.building.address.region.country")
            query.includeKey("citizen.homeAddress.documentPointers")
            // Judge includes
            query.includeKey("judge")
            query.includeKey("judge.homeAddress")
            query.includeKey("judge.homeAddress.building")
            query.includeKey("judge.homeAddress.building.address")
            query.includeKey("judge.homeAddress.building.address.district")
            query.includeKey("judge.homeAddress.building.address.district.city")
            query.includeKey("judge.homeAddress.building.address.district.city.region")
            query.includeKey("judge.homeAddress.building.address.district.city.region.country")
            query.includeKey("judge.homeAddress.building.address.region")
            query.includeKey("judge.homeAddress.building.address.region.country")
            query.includeKey("judge.homeAddress.documentPointers")
            // Sub land
            query.includeKey("subLand")
            query.includeKey("subLand.landPlan")
            query.includeKey("subLand.landPlan.region")
            query.includeKey("subLand.landPlan.responsibleDivision")
            query.includeKey("subLand.region")
            // Department
            query.includeKey("department")
            query.includeKey("department.mapArea")
            // Get land cases list
            query.findObjectsInBackground { (landCases, error) in
                var landCasesArray = [PFObject]()
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let landCases = landCases {
                    landCasesArray = landCases
                }
                
                completion(landCasesArray)
            }
        }
    }
    
    // MARK: - New Land Case by Consumer app
    
    public func getRegion(coordinatesArray: [CLLocationCoordinate2D], completion: @escaping (_ regionId: String) -> ()) {
        if !coordinatesArray.isEmpty {
            let coordinate = coordinatesArray[0]
            
            // Save coordinates and save the box
            KMAUIUtilities.shared.getAddressFromApple(location: coordinate) { (status, addressDict, regionId) in
                completion(regionId)
            }
        } else {
            completion("")
        }
    }
    
    public func createLandCaseSubLand(coordinatesArray: [CLLocationCoordinate2D], tempAttachments: String, isTrespass: Bool? = nil, completion: @escaping (_ subLandId: String, _ error: String) -> ()) {
        KMAUIParse.shared.getRegion(coordinatesArray: coordinatesArray) { (regionId) in
            // Create the new Sub land
            let newSubLand = PFObject(className: "KMASubLand")
            let uniqueId = String(UUID().uuidString.suffix(4))
            newSubLand["subLandId"] = uniqueId
            newSubLand["subLandIndex"] = uniqueId
            var type = ""
            
            if let isTrespass = isTrespass, isTrespass {
                newSubLand["subLandType"] = "Trespass"
                type = "Trespass"
            } else {
                newSubLand["subLandType"] = "Earned Land"
                type = "Earned Land"
            }
            
            if !regionId.isEmpty {
                newSubLand["region"] = PFObject(withoutDataWithClassName: "KMAMapArea", objectId: regionId)
            }
            
            var coordinates = [[Double]]()
            
            for coordinate in coordinatesArray {
                let array = [coordinate.longitude, coordinate.latitude]
                coordinates.append(array)
            }
            
            if !coordinates.isEmpty {
                coordinates.append(coordinates[0])
            }
            
            var geometry = [String: AnyObject]()
            geometry["type"] = "LineString" as AnyObject
            geometry["coordinates"] = coordinates as AnyObject
            
            let square = KMAUIUtilities.shared.regionAreaLocation(locations: coordinatesArray)
            let subLandPercent = square / (24 * 24)
            
            let widthValue = CLLocation(latitude: coordinatesArray[0].latitude, longitude: coordinatesArray[0].longitude).distance(from: CLLocation(latitude: coordinatesArray[1].latitude, longitude: coordinatesArray[1].longitude))
            let heightValue = square / widthValue
            
            // x - longitude, y - latitude
            var minX: Double = 0
            var minY: Double = 0
            var maxX: Double = 0
            var maxY: Double = 0
            
            for coordinate in coordinatesArray {
                if coordinate.longitude < minX || minX == 0 {
                    minX = coordinate.longitude
                }
                
                if coordinate.longitude > maxX || maxX == 0 {
                    maxX = coordinate.longitude
                }
                
                if coordinate.latitude < minY || minY == 0 {
                    minY = coordinate.latitude
                }
                
                if coordinate.latitude > maxY || maxY == 0 {
                    maxY = coordinate.latitude
                }
            }
            
            let latitude = (minY + maxY) / 2
            let longitude = (minX + maxX) / 2
            
            newSubLand["subLandSquare"] = square
            newSubLand["subLandWidth"] = widthValue
            newSubLand["subLandHeight"] = heightValue
            newSubLand["location"] = PFGeoPoint(latitude: latitude, longitude: longitude)
            newSubLand["minX"] = minX
            newSubLand["minY"] = minY
            newSubLand["maxX"] = maxX
            newSubLand["maxY"] = maxY
            newSubLand["subLandPercent"] = subLandPercent
            newSubLand["extraPrice"] = 0
            newSubLand["subLandImages"] = tempAttachments
            
            newSubLand.saveInBackground { (success, error) in
                if let error = error {
                    completion("", error.localizedDescription)
                } else if success, let objectId = newSubLand.objectId {
                    print("Initial value saved.")
                    
                    let properties = ["name": "\(uniqueId)" as AnyObject, "subLandSquare": square as AnyObject, "subLandPercent": subLandPercent as AnyObject, "type": "Sub Land", "subLandType": type as AnyObject, "subLandWidth": widthValue as AnyObject, "subLandHeight": heightValue as AnyObject, "minX": minX as AnyObject, "maxX": maxX as AnyObject, "minY": minY as AnyObject, "maxY": maxY as AnyObject, "latitude": latitude as AnyObject, "longitude": longitude as AnyObject, "objectId": objectId as AnyObject] as AnyObject
                    let feature = ["type": "Feature" as AnyObject, "geometry": geometry as AnyObject, "properties": properties]
                    
                    let dictionary = ["type": "FeatureCollection" as AnyObject, "features": [feature] as AnyObject]
                    
                    let jsonFileBodyData = KMAUIUtilities.shared.dictionaryToJSONData(dict: dictionary)
                    var fileBody = ""
                    
                    // JSON String for Parse
                    if let jsonFileBodyString = String(data: jsonFileBodyData, encoding: .utf8) {
                        fileBody = jsonFileBodyString
                    }
                    
                    newSubLand["subLandArea"] = fileBody
                    
                    newSubLand.saveInBackground { (updateSuccess, updateError) in
                        if let updateError = updateError {
                            completion("", updateError.localizedDescription)
                        } else if updateSuccess, let subLandId = newSubLand.objectId, !subLandId.isEmpty {
                            completion(subLandId, "")
                        } else {
                            completion("", "Can't prepare the new sub alnd for Land case.")
                        }
                    }
                }
            }
        }
    }
    
    public func createTrespassCaseObject(subLandId: String, comment: String, completion: @escaping (_ trespassCaseId: String, _ error: String) -> ()) {
        let newTrespassCase = PFObject(className: "KMATrespassCase")
        newTrespassCase["caseNumber"] = "\(Int.random(in: 10000 ..< 100000))"
        newTrespassCase["caseStatus"] = "Created"
        newTrespassCase["department"] = PFObject(withoutDataWithClassName: "KMADepartment", objectId: "poqIHPw4NS")
        newTrespassCase["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLandId)
        newTrespassCase["initialComment"] = comment
        
        newTrespassCase.saveInBackground { (success, error) in
            if let error = error {
                completion("", error.localizedDescription)
            } else if success, let trespassCaseId = newTrespassCase.objectId, !trespassCaseId.isEmpty {
                completion(trespassCaseId, "")
            } else {
                completion("", "Can't prepare the new Trespass case data.")
            }
        }
    }
    
    public func createLandCaseObject(subLandId: String, trespassCase: KMAUITrespassCaseStruct? = nil, completion: @escaping (_ landCaseId: String, _ landCaseNumber: String, _ error: String) -> ()) {
        if let currentUser = PFUser.current() {
            let newLandCase = PFObject(className: "KMALandCase")
            newLandCase["judge"] = PFUser(withoutDataWithObjectId: "XdwTy8armc")
            newLandCase["date"] = Date().addingTimeInterval(30*24*60*60)
            newLandCase["courtName"] = "Jeddah General Court"
            newLandCase["courtStatus"] = "In progress"
            
            // The new Land case from the Trespass case
            if let trespassCase = trespassCase, !trespassCase.objectId.isEmpty {
                newLandCase["citizen"] = PFUser(withoutDataWithObjectId: trespassCase.owner.objectId)
                newLandCase["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: trespassCase.subLand.objectId)
            } else if !subLandId.isEmpty {
                newLandCase["citizen"] = currentUser
                newLandCase["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLandId)
            }
                        
            let fileBodyDict = ["files": KMAUIConstants.shared.placeholderFilesArray]
            let jsonFileBodyData = KMAUIUtilities.shared.dictionaryToJSONData(dict: fileBodyDict)
            var fileBody = ""
            
            // JSON String for Parse
            if let jsonFileBodyString = String(data: jsonFileBodyData, encoding: .utf8) {
                fileBody = jsonFileBodyString
            }
            
            newLandCase["documents"] = fileBody
            newLandCase["department"] = PFObject(withoutDataWithClassName: "KMADepartment", objectId: "poqIHPw4NS")
            
            let caseNumber = "\(Int.random(in: 10000 ..< 100000))"
            newLandCase["caseNumber"] = caseNumber
            newLandCase["titleNumber"] = "\(Int.random(in: 100000 ..< 1000000))"
            
            newLandCase.saveInBackground { (success, error) in
                if let error = error {
                    completion("", "", error.localizedDescription)
                } else if success, let landCaseId = newLandCase.objectId, !landCaseId.isEmpty {
                    completion(landCaseId, caseNumber, "")
                } else {
                    completion("", "", "Can't prepare the new Land case data.")
                }
            }
        } else {
            completion("", "", "Can't prepare the new Land case data.")
        }
    }
    
    public func createLandCaseDecisions(landCaseId: String, completion: @escaping (_ success: Bool, _ error: String) -> ()) {
        let query = PFQuery(className: "KMADepartment")
        query.whereKey("landCases", equalTo: true)
        query.findObjectsInBackground { (departments, error) in
            if let error = error {
                completion(false, error.localizedDescription)
            } else if let departments = departments {
                var decisions = [PFObject]()
                
                for department in departments {
                    if let type = department["type"] as? String, let departmentId = department.objectId, let departmentName = department["departmentName"] as? String {
                        let newDecision = PFObject(className: "KMALandCaseMinistryDecision")
                        newDecision["landCase"] = PFObject(withoutDataWithClassName: "KMALandCase", objectId: landCaseId)
                        newDecision["ministry"] = PFObject(withoutDataWithClassName: "KMADepartment", objectId: departmentId)
                        newDecision["date"] = Date()
                        newDecision["type"] = type
                        
                        let randomDecision = Int.random(in: 0..<2)
                        
                        if randomDecision == 1 {
                            newDecision["ministryStatus"] = "approved"
                        } else if randomDecision == 0 {
                            newDecision["ministryStatus"] = "rejected"
                        }
                        
                        newDecision["comment"] = KMAUIUtilities.shared.prepareMinistryComment(name: departmentName, isApproved: randomDecision == 1)
                        newDecision["attachments"] = KMAUIUtilities.shared.prepareMinistryFile()
                        decisions.append(newDecision)
                    }
                }
                
                if decisions.isEmpty {
                    completion(false, "Can't retrieve the Ministry and Department decisions for the Land case.")
                } else {
                    PFObject.saveAll(inBackground: decisions) { (success, saveError) in
                        if let saveError = saveError {
                            completion(false, saveError.localizedDescription)
                        } else if success {
                            completion(true, "")
                        }
                    }
                }
            }
        }
    }
    
    // Notify Department Admin
    
    public func notifyDepartmentNewLandCase(landCaseId: String, caseNumber: String) {
        let notificationTitle = "New Land case created"
        var notificationMessage = "The new Land case #\(caseNumber) added for Department of Urban Planning."
        
        if let currentUser = PFUser.current(), let fullName = currentUser["fullName"] as? String, !fullName.isEmpty {
            notificationMessage = "\(fullName) has created the new Land case #\(caseNumber) for Department of Urban Planning."
        }
        
        let departmentId = "poqIHPw4NS"
        let departmentName = "Makkah Department of Housing"
        
        let query = PFQuery(className: "KMADepartmentEmployee")
        query.whereKey("department", equalTo: PFObject(withoutDataWithClassName: "KMADepartment", objectId: departmentId))
        query.whereKey("isActive", equalTo: true)
        query.includeKey("employee")
        query.findObjectsInBackground { (employees, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let employees = employees {
                // KMANotification objects
                var notificationsArray = [PFObject]()
                // Push params array
                var pushParams = [[String: AnyObject]]()
                var itemsArray = [[String: AnyObject]]()

                print("Employees for department \(departmentId): \(employees.count)")
                for employee in employees {
                    if let citizen = employee["employee"] as? PFUser, let citizenId = citizen.objectId {
                        print("Send a KMANotification to citizen \(citizenId)")
                        // Prepare the notification Parse object
                        let newNotification = PFObject(className: "KMANotification")
                        newNotification["user"] = PFUser(withoutDataWithObjectId: citizenId)
                        newNotification["title"] = notificationTitle
                        newNotification["message"] = notificationMessage
                        // Fill the items for Notification
                        let items = ["objectId": landCaseId as AnyObject,
                                     "objectType": "landCase" as AnyObject,
                                     "eventType": "landCaseCreated" as AnyObject,
                                     "landCaseNumber": caseNumber as AnyObject,
                                     "departmentId": departmentId as AnyObject,
                                     "departmentName": departmentName as AnyObject
                        ]
                        // Save item into array for push notifications
                        itemsArray.append(items)
                        // items json string from dictionary
                        if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                            newNotification["items"] = jsonStr
                        }
                        newNotification["read"] = false
                        notificationsArray.append(newNotification)
                    }
                }

                if !notificationsArray.isEmpty {
                    PFObject.saveAll(inBackground: notificationsArray) { (success, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        } else if success {
                            for (index, notification) in notificationsArray.enumerated() {
                                if let notificationId = notification.objectId, let citizen = notification["user"] as? PFUser, let citizenId = citizen.objectId {
                                    var items = itemsArray[index]
                                    items["notificationId"] = notificationId as AnyObject
                                    // Push parameters
                                    let newSubLandParams = [
                                        "userId" : citizenId as AnyObject,
                                        "title": notificationTitle as AnyObject,
                                        "message": notificationMessage as AnyObject,
                                        "kmaItems": items as AnyObject,
                                        "appType": "Business" as AnyObject
                                    ]

                                    pushParams.append(newSubLandParams)
                                }
                            }

                            // Send push notifications to the winners
                            for subLandParams in pushParams {
                                print("\nSend a push notification: \(subLandParams)")
                                KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Notify Department Admin
    
    public func notifyDepartmentTrespassPenaltyPaid(trespassCase: KMAUITrespassCaseStruct) {
        if let currentUser = PFUser.current(), let fullName = currentUser["fullName"] as? String {
            let notificationTitle = "Trespass case penalty payment"
            let notificationMessage = "The Trespass case #\(trespassCase.caseNumber) is set as \"Resolved\", as \(fullName) has just paid the full penalty sum."
            let departmentId = "poqIHPw4NS"

            let query = PFQuery(className: "KMADepartmentEmployee")
            query.whereKey("department", equalTo: PFObject(withoutDataWithClassName: "KMADepartment", objectId: departmentId))
            query.whereKey("isActive", equalTo: true)
            query.includeKey("employee")
            query.findObjectsInBackground { (employees, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let employees = employees {
                    // KMANotification objects
                    var notificationsArray = [PFObject]()
                    // Push params array
                    var pushParams = [[String: AnyObject]]()
                    var itemsArray = [[String: AnyObject]]()
                    
                    print("Employees for department \(departmentId): \(employees.count)")
                    for employee in employees {
                        if let citizen = employee["employee"] as? PFUser, let citizenId = citizen.objectId {
                            print("Send a KMANotification to citizen \(citizenId)")
                            // Prepare the notification Parse object
                            let newNotification = PFObject(className: "KMANotification")
                            newNotification["user"] = PFUser(withoutDataWithObjectId: citizenId)
                            newNotification["title"] = notificationTitle
                            newNotification["message"] = notificationMessage
                            // Fill the items for Notification
                            let items = ["objectId": trespassCase.objectId as AnyObject,
                                         "objectType": "trespassCase" as AnyObject,
                                         "eventType": "penaltyPaymentReceived" as AnyObject
                            ]
                            // Save item into array for push notifications
                            itemsArray.append(items)
                            // items json string from dictionary
                            if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                                newNotification["items"] = jsonStr
                            }
                            newNotification["read"] = false
                            notificationsArray.append(newNotification)
                        }
                    }
                    
                    if !notificationsArray.isEmpty {
                        PFObject.saveAll(inBackground: notificationsArray) { (success, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else if success {
                                for (index, notification) in notificationsArray.enumerated() {
                                    if let notificationId = notification.objectId, let citizen = notification["user"] as? PFUser, let citizenId = citizen.objectId {
                                        var items = itemsArray[index]
                                        items["notificationId"] = notificationId as AnyObject
                                        // Push parameters
                                        let newSubLandParams = [
                                            "userId" : citizenId as AnyObject,
                                            "title": notificationTitle as AnyObject,
                                            "message": notificationMessage as AnyObject,
                                            "kmaItems": items as AnyObject,
                                            "appType": "Business" as AnyObject
                                        ]
                                        
                                        pushParams.append(newSubLandParams)
                                    }
                                }
                                
                                // Send push notifications to the winners
                                for subLandParams in pushParams {
                                    print("\nSend a push notification: \(subLandParams)")
                                    KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                                }
                            }
                        }
                    }
                }
        }
        }
    }
    
    // MARK: - Save the decision with comment and attachment
    
    public func saveDecision(decisionType: String, commentItem: String, attachmentItem: String, selectedAction: Bool, landCase: KMAUILandCaseStruct, completion: @escaping (_ landCase: KMAUILandCaseStruct) -> ()) {
        var landCase = landCase
        let landCaseObject = PFObject(withoutDataWithClassName: "KMALandCase", objectId: landCase.objectId)
        
        if decisionType == "judge" {
            landCaseObject["judgeComment"] = commentItem
            landCaseObject["judgeAttachment"] = attachmentItem
            // Setup status
            if selectedAction {
                landCaseObject["courtStatus"] = "Approved"
            } else {
                landCaseObject["courtStatus"] = "Declined"
            }
        } else if decisionType == "department" {
            landCaseObject["departmentComment"] = commentItem
            landCaseObject["departmentAttachment"] = attachmentItem
            // Setup status
            if selectedAction {
                landCaseObject["departmentDecision"] = "Approved"
            } else {
                landCaseObject["departmentDecision"] = "Declined"
            }
        }

        KMAUIUtilities.shared.startLoading(title: "Saving...")
        
        landCaseObject.saveInBackground { (success, error) in
            KMAUIUtilities.shared.stopLoadingWith { (_) in
                if let error = error {
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (_) in }
                } else if success {
                    // Don't forger to save details into the local data
                    if decisionType == "department" {
                        landCase.departmentComment = commentItem
                        landCase.departmentAttachment = attachmentItem
                        // Setup status
                        if selectedAction {
                            landCase.departmentDecision = "Approved"
                        } else {
                            landCase.departmentDecision = "Declined"
                        }
                    } else if decisionType == "judge" {
                        landCase.judgeComment = commentItem
                        landCase.judgeAttachment = attachmentItem
                        // Setup status
                        if selectedAction {
                            landCase.courtStatus = "Approved"
                        } else {
                            landCase.courtStatus = "Declined"
                        }
                    }
                    landCase.setupAttachments()
                    KMAUIParse.shared.notifyUser(landCase: landCase, selectedAction: selectedAction, decisionType: decisionType, comment: commentItem)
                    // Completion
                    completion(landCase)
                }
            }
        }
    }
    
    // MARK: - Sav the Trespass field observer report
    
    public func saveTrespassFieldObserverReport(commentItem: String, attachmentItem: String, ownerItem: KMAPerson, trespassCase: KMAUITrespassCaseStruct, isViolation: Bool, completion: @escaping (_ landCase: KMAUITrespassCaseStruct) -> ()) {
        var trespassCase = trespassCase
        let trespassCaseObject = PFObject(withoutDataWithClassName: "KMATrespassCase", objectId: trespassCase.objectId)
        
        trespassCaseObject["fieldObserverReport"] = commentItem
        trespassCaseObject["fieldObserverUploads"] = attachmentItem
        
        if !ownerItem.objectId.isEmpty {
            trespassCaseObject["owner"] = PFUser(withoutDataWithObjectId: ownerItem.objectId)
        }

        trespassCaseObject["isViolation"] = isViolation
        trespassCaseObject["caseStatus"] = "Awaiting decision"
        
        KMAUIUtilities.shared.startLoading(title: "Saving...")
        
        trespassCaseObject.saveInBackground { (success, error) in
            KMAUIUtilities.shared.stopLoadingWith { (_) in
                if let error = error {
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (_) in }
                } else if success {
                    // Don't forger to save details into the local data
                    trespassCase.fieldObserverReport = commentItem
                    trespassCase.fieldObserverUploads = attachmentItem
                    trespassCase.setupAttachments()
                    trespassCase.owner = ownerItem
                    trespassCase.isViolation = isViolation
                    trespassCase.caseStatus = "Awaiting decision"
                    // Completion
                    completion(trespassCase)
                }
            }
        }
    }
    
    // MARK: - Save the Trespass decision with comment and attachment
    
    public func saveTrespassDecision(decisionType: String, commentItem: String, attachmentItem: String, selectedAction: Bool, trespassCase: KMAUITrespassCaseStruct, completion: @escaping (_ landCase: KMAUITrespassCaseStruct) -> ()) {
        var trespassCase = trespassCase
        let trespassCaseObject = PFObject(withoutDataWithClassName: "KMATrespassCase", objectId: trespassCase.objectId)
        
        if decisionType == "initialCheck" {
            trespassCaseObject["initialCheckComment"] = commentItem
            trespassCaseObject["initialCheckAttachments"] = attachmentItem
            // Setup status
            if selectedAction {
                trespassCaseObject["caseStatus"] = "Awaiting report"
            } else {
                trespassCaseObject["caseStatus"] = "Declined"
            }
        }

        KMAUIUtilities.shared.startLoading(title: "Saving...")
        
        trespassCaseObject.saveInBackground { (success, error) in
            KMAUIUtilities.shared.stopLoadingWith { (_) in
                if let error = error {
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (_) in }
                } else if success {
                    // Don't forger to save details into the local data
                    if decisionType == "initialCheck" {
                        trespassCase.initialCheckComment = commentItem
                        trespassCase.initialCheckAttachments = attachmentItem
                        // Setup status
                        if selectedAction {
                            trespassCase.caseStatus = "Awaiting report"
                        } else {
                            trespassCase.caseStatus = "Declined"
                        }
                    }
                    trespassCase.setupAttachments()
                    // Completion
                    completion(trespassCase)
                }
            }
        }
    }
    
    public func notifyUser(landCase: KMAUILandCaseStruct, selectedAction: Bool, decisionType: String, comment: String) {
        let title = "Land case \(decisionType) decision"
        var message = ""
        
        var status = "declined"
        
        if selectedAction {
            status = "approved"
        }
        
        if decisionType == "judge" {
            message = "Your Land case #\(landCase.caseNumber) was \(status) by the judge \(landCase.judge.fullName)."
        } else if decisionType == "department" {
            message = "Your Land case #\(landCase.caseNumber) was \(status) by the Department of Urban Planning. Please wait for it to be proceeded by the judge \(landCase.judge.fullName)."
        }

        message += "\nComment: \(comment)"
        
        if !title.isEmpty, !message.isEmpty {
            let userId = landCase.citizen.objectId
            let newNotification = PFObject(className: "KMANotification")
            newNotification["user"] = PFUser(withoutDataWithObjectId: userId)
            newNotification["title"] = title
            newNotification["message"] = message
            // Fill the items for Notification
            var items = ["objectId": landCase.objectId as AnyObject,
                         "objectType": "landCaseChanged" as AnyObject,
                         "eventType": "decision\(decisionType.capitalized)" as AnyObject
            ]
            // items json string from dictionary
            if let data = try? JSONSerialization.data(withJSONObject: items, options: .prettyPrinted), let jsonStr = String(bytes: data, encoding: .utf8) {
                newNotification["items"] = jsonStr
            }
            newNotification["read"] = false
            // Save notification
            newNotification.saveInBackground { (success, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if success, let notificationId = newNotification.objectId {
                    items["notificationId"] = notificationId as AnyObject
                    // Push parameters
                    let subLandParams = [
                        "userId" : userId as AnyObject,
                        "title": title as AnyObject,
                        "message": message as AnyObject,
                        "kmaItems": items as AnyObject,
                        "appType": "Consumer" as AnyObject
                    ]
                    // Send push notification
                    KMAUIParse.shared.sendPushNotification(cloudParams: subLandParams)
                }
            }
        }
    }
    
    // MARK: - Trespass case
    
    public func closeTrespassCase(trespassCase: KMAUITrespassCaseStruct, type: String, completion: @escaping (_ landCase: KMAUITrespassCaseStruct) -> ()) {
        var message = "The Trespass case will be marked as Resolved and no penalty will be charged from the land owner."
        var newStatus = "Resolved"
        var decision = "noPenalty"
        var title = "Final decision"
        
        if type == "penalty" {
            message = "The Trespass case status will be set to \"Awaiting penalty payment\" and the land owner will recieve the corresponding notification."
            newStatus = "Awaiting penalty payment"
            decision = "penalty"
        } else if type == "outside" {
            message = "The Trespass case status will be set to \"Outside the Urban Range\". This case can't be Resolved by the Department or Urban Planning."
            newStatus = "Outside the Urban Range"
            decision = "outside"
        } else if type == "inside" {
            message = "The Trespass case status will be set to \"Awaiting Municipality decision\". One more step required to Resolve the case."
            newStatus = "Awaiting Municipality decision"
            decision = "inside"
            title = "Range decision"
        } else if type == "demolition" {
            message = "The Department of Urban Planning will send an order for an Immediate demolition of the Illegal building. The Trespass case status will be set to \"Resolved\"."
            newStatus = "Resolved"
            decision = "demolition"
        } else if type == "landCase" {
            message = "The Department of Urban Planning will send an order to create the new Land case for the Land owner. The Trespass case status will be set to \"Resolved\"."
            newStatus = "Resolved"
            decision = "Land case"
        } else if type == "payPenalty" {
            title = "Penalty payment"
            message = "You're going to pay the penalty for the illegal building on the Land.\nThe full penalty sum will be charged from your bank account and the Trespass case will be set to \"Resolved\""
            newStatus = "Resolved"
            decision = "Penalty paid"
        }
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            let trespassCaseObject = PFObject(withoutDataWithClassName: "KMATrespassCase", objectId: trespassCase.objectId)
            
            trespassCaseObject["trespassDecision"] = decision
            trespassCaseObject["caseStatus"] = newStatus
            
            KMAUIUtilities.shared.startLoading(title: "Saving...")
            
            if type == "landCase" {
                KMAUIParse.shared.createLandCaseObject(subLandId: "", trespassCase: trespassCase) { (landCaseId, landCaseNumber, error) in
                    if !error.isEmpty {
                        KMAUIUtilities.shared.stopLoadingWith { (_) in
                            KMAUIUtilities.shared.globalAlert(title: "Error", message: error) { (_) in }
                        }
                    } else {
                        // Create the Department and Ministry decisions / Notify the Department admin
                        KMAUIParse.shared.createLandCaseDecisions(landCaseId: landCaseId) { (success, errorString) in
                            if !errorString.isEmpty {
                                print("Error creating the Land case decisions.")
                            } else {
                                KMAUIParse.shared.notifyDepartmentNewLandCase(landCaseId: landCaseId, caseNumber: landCaseNumber)
                            }
                        }
                        
                        // Add the Land case connection
                        if !landCaseId.isEmpty {
                            trespassCaseObject["landCase"] = PFObject(withoutDataWithClassName: "KMALandCase", objectId: landCaseId)
                            decision = "Land case #\(landCaseNumber)"
                            trespassCaseObject["trespassDecision"] = decision
                        }
                        // Update the Trespass case
                        KMAUIParse.shared.saveTrespassCase(trespassCaseObject: trespassCaseObject, trespassCase: trespassCase, decision: decision, newStatus: newStatus, type: type) { (trespassCaseUpdated) in
                            completion(trespassCaseUpdated)
                        }
                    }
                }
            } else {
                // Update the Trespass case
                KMAUIParse.shared.saveTrespassCase(trespassCaseObject: trespassCaseObject, trespassCase: trespassCase, decision: decision, newStatus: newStatus, type: type) { (trespassCaseUpdated) in
                    completion(trespassCaseUpdated)
                }
            }
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }))
        KMAUIUtilities.shared.displayAlert(viewController: alertView)
    }
    
    func saveTrespassCase(trespassCaseObject: PFObject, trespassCase: KMAUITrespassCaseStruct, decision: String, newStatus: String, type: String, completion: @escaping (_ landCase: KMAUITrespassCaseStruct) -> ()) {
        var trespassCase = trespassCase
        
        trespassCaseObject.saveInBackground { (success, error) in
            KMAUIUtilities.shared.stopLoadingWith { (_) in
                if let error = error {
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: error.localizedDescription) { (_) in }
                } else if success {
                    // Don't forger to save details into the local data
                    trespassCase.trespassDecision = decision
                    trespassCase.caseStatus = newStatus
                    // Notify user
                    if type == "penalty" {
                        KMAUIParse.shared.notifyUserPenalty(trespassCase: trespassCase)
                    } else if type == "payPenalty" {
                        KMAUIParse.shared.notifyDepartmentTrespassPenaltyPaid(trespassCase: trespassCase)
                    }
                    // Completion
                    completion(trespassCase)
                }
            }
        }
    }
}
