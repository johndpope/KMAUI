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
        //        query.order(byAscending: "planName")
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
    
    public func getSaudiArabiaRegions(responsibleDivisionId: String? = nil, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil, completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
        // Saudi Arabia Parse object id
        let saudiArabiaId = "ocRDUNG9ZR"
        // Get the items
        KMAUIParse.shared.getMapAreas(level: 2, sw: sw, ne: ne, parentObjectId: saudiArabiaId) { (areaItems) in
            KMAUIParse.shared.getLandPlans(responsibleDivisionId: responsibleDivisionId, sw: sw, ne: ne, items: areaItems) { (items) in
                completion(items)
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
        //        query.order(byAscending: "planName")
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
                
                completion(items)
            }
        }
    }
    
    public func getLandPlan(landPlanId: String, completion: @escaping (_ landPlan: KMAUILandPlanStruct?)->()) {
        let query = PFQuery(className: "KMALandPlan")
        query.whereKey("objectId", equalTo: landPlanId)
        query.includeKey("responsibleDivision")
        query.includeKey("responsibleDivision.mapArea")
        query.includeKey("region")
        
        query.findObjectsInBackground { (plans, error) in
            if let error = error {
                print("Error getting the Land Plans for regions: \(error.localizedDescription).")
                completion(nil)
            } else if let plans = plans {
                guard let plan = plans.first else {
                    print("\nNo Land Plans loaded for regions.")
                    completion(nil)
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
                    landPlanObject.queueCount = regionStruct.lotteryMembersCount
                }
                
                completion(landPlanObject)
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
    
    public func getLotteryResult(lotteryResultId: String, fileName: String, completion: @escaping (_ citizen: KMAPerson, _ error: String, _ document: KMADocumentData, _ subLand: KMAUISubLandStruct, _ loaded: Bool)->()) {
        let lotteryResultQuery = PFQuery(className: "KMALotteryResult")
        lotteryResultQuery.includeKey("citizen")
        lotteryResultQuery.includeKey("citizen.homeAddress")
        lotteryResultQuery.includeKey("citizen.homeAddress.building")
        lotteryResultQuery.includeKey("subLand")
        lotteryResultQuery.includeKey("subLand.landPlan")
        lotteryResultQuery.includeKey("subLand.landPlan.region")
        lotteryResultQuery.includeKey("subLand.landPlan.responsibleDivision")
        
        lotteryResultQuery.getObjectInBackground(withId: lotteryResultId) { (lotteryResult, error) in
            var errorValue = ""
            
            if let error = error {
                print(error.localizedDescription)
                errorValue = error.localizedDescription
            } else if let lotteryResult = lotteryResult {
                if let citizen = lotteryResult["citizen"] as? PFUser, let subLand = lotteryResult["subLand"] as? PFObject {
                    // Citizen details
                    var citizenObject = KMAPerson()
                    citizenObject.fillFrom(person: citizen)
                    // Sub land details
                    var subLandObject = KMAUISubLandStruct()
                    subLandObject.fillFromParse(item: subLand)
                    // Sub land images
                    for document in subLandObject.subLandImagesAllArray {
                        if document.name == fileName {
                            print("Document `\(fileName)` found:\n\(document)")
                            completion(citizenObject, "", document, subLandObject, true)
                            
                            return
                        }
                    }
                    
                    print("Document `\(fileName)` not found.")
                }
            }
            
            completion(KMAPerson(), errorValue, KMADocumentData(), KMAUISubLandStruct(), false)
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
        
        KMAUIUtilities.shared.startLoading(title: "Processing...")
        
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
                    KMAUIUtilities.shared.stopLoadingWith { (done) in
                        if let saveError = saveError {
                            print(saveError.localizedDescription)
                            KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error saving the lottery results.\n\n\(saveError.localizedDescription)") { (done) in }
                        } else {
                            print("Land Plan status changed to completed.")
                            landPlan.lotteryStatus = .finished
                        }
                        
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
            completion(searchObject)
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
    
    public func updateDocumentStatus(subLandId: String, documentId: String, status: String, completion: @escaping (_ done: Bool)->()) {
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
    
    public func updateNotifications(hasUpdatedAt: Bool, updatedAt: Date, completion: @escaping (_ updatedNotifications: [KMANotificationStruct])->()) {
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
            
            completion(updatedNotifications)
        }
    }
    
    public func setNotificationRead(notificationId: String) {
        let notificationObject = PFObject(withoutDataWithClassName: "KMANotification", objectId: notificationId)
        notificationObject["read"] = true
        notificationObject.saveInBackground { (success, error) in
            if let error = error {
                print("Error setting the notification \(notificationId) as read: \(error.localizedDescription)")
            } else if success {
                print("Notification \(notificationId) is set to read")
            }
        }
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
    
    public func notifyUser(subLand: KMAUISubLandStruct, type: String, status: String? = nil, documentName: String? = nil, citizenId: String? = nil) {
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
}

