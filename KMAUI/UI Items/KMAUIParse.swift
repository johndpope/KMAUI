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
    
    public func getMapAreas(level: Int, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        getMapAreas(skip: 0, items: [KMAMapAreaStruct](), level: level, parentObjectId: parentObjectId) { (items) in
            completion(items)
        }
    }
    
    /**
     Get the map area
     */
    
    func getMapAreas(skip: Int, items: [KMAMapAreaStruct], level: Int, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
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
                
                for country in countriesArray {
                    var item = KMAMapAreaStruct()
                    item.fillFrom(object: country)
                    
                    if item.isActive {
                        items.append(item)
                    }
                }
                
                if countriesArray.count == 100 {
                    self.getMapAreas(skip: skip + 100, items: items, level: level, parentObjectId: parentObjectId) { (itemsArray) in
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
                print("\nTotal items loaded: \(countriesArray.count)")
                
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
    
    /**
     Get Saudi Arabia regions
     */
    
    public func getSaudiArabiaRegions(responsibleDivisionId: String? = nil, completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
        // Saudi Arabia Parse object id
        let saudiArabiaId = "ocRDUNG9ZR"
        // Get the items
        KMAUIParse.shared.getMapAreas(level: 2, parentObjectId: saudiArabiaId) { (areaItems) in
            KMAUIParse.shared.getLandPlans(responsibleDivisionId: responsibleDivisionId, items: areaItems) { (items) in
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
    
    public func getLandPlans(responsibleDivisionId: String? = nil, items: [KMAMapAreaStruct], completion: @escaping (_ items: [KMAMapAreaStruct])->()) {
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
        query.order(byAscending: "planName")
        query.whereKey("region", containedIn: parseItems)
        if let objectId = responsibleDivisionId {
            query.whereKey("responsibleDivision", equalTo: PFObject(withoutDataWithClassName: "KMADepartment", objectId: objectId))
        }
        query.includeKey("responsibleDivision")
        query.includeKey("responsibleDivision.mapArea")
        
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
                        // landPlanId
                        if let landPlanIdValue = plan.objectId {
                            landPlanObject.landPlanId = landPlanIdValue
                        }
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
                        // lotterySubLandsCount
                        if let lotterySubLandsCount = plan["lotterySubLandsCount"] as? Int {
                            landPlanObject.lotterySubLandsCount = lotterySubLandsCount
                        }
                        // lotteryCompleted
                        if let lotteryCompletedValue = plan["lotteryCompleted"] as? Bool {
                            landPlanObject.lotteryCompleted = lotteryCompletedValue
                        }
                        // extraPricePerSqM
                        if let extraPricePerSqM = plan["extraPricePerSqM"] as? Double {
                            landPlanObject.squareMeterPrice = extraPricePerSqM
                        }
                        // landArea
                        if let landArea = plan["landArea"] as? String {
                            landPlanObject.geojson = landArea
                            
                            let dict = KMAUIUtilities.shared.jsonToDictionary(jsonText: landArea)

                            if let features = dict["features"] as? [[String: Any]], !features.isEmpty {
                                let border = features[0]
                                // coordinates
                                if let geometry = border["geometry"] as? [String: Any], let coordinates = geometry["coordinates"] as? [[Double]], coordinates.count == 5 {
                                    let topLeftCoordinate = coordinates[0]
                                    let topRightCoordinate = coordinates[1]
                                    let bottomLeftCoordinate = coordinates[3]
                                    
                                    let topLeft = CLLocation(latitude: topLeftCoordinate[0], longitude: topLeftCoordinate[1])
                                    let topRight = CLLocation(latitude: topRightCoordinate[0], longitude: topRightCoordinate[1])
                                    let bottomLeft = CLLocation(latitude: bottomLeftCoordinate[0], longitude: bottomLeftCoordinate[1])
                                    
                                    let width = Double(Int(topLeft.distance(from: topRight)))
                                    let height = Double(Int(topLeft.distance(from: bottomLeft)))
                                    
//                                        print("Width x height: \(width) m x \(height) m")
                                    landPlanObject.areaWidth = width
                                    landPlanObject.areaHeight = height
                                }
                                
                                // Sub Lands -> update to use the new `KMAUISubLandStruct`
                                landPlanObject.subLandArray = [KMAUISubLandStruct]()
                                
                                for item in features {
                                    var subLandItem = KMAUISubLandStruct()
                                    subLandItem.fillFromDict(item: item)
                                    
                                    if !subLandItem.subLandType.isEmpty { // no need to save roads and other items here / empty subLand items
                                        landPlanObject.subLandArray.append(subLandItem)
                                        
                                        if subLandItem.subLandType == "Residential Lottery" {
                                            landPlanObject.lotterySubLandArray.append(subLandItem)
                                        }
                                    }
                                }
                            }
                        }
                        // Counts / Percents for Sub Lands
                        landPlanObject.prepareRules()
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
                        // responsibleDivision
                        if let responsibleDivisionValue = plan["responsibleDivision"] as? PFObject {
                            var divisionObject = KMADepartmentStruct()
                            divisionObject.fillFromParse(departmentObject: responsibleDivisionValue)
                            landPlanObject.responsibleDivision = divisionObject
                        }
                        // region id
                        if let region = plan["region"] as? PFObject, let regionId = region.objectId {
                            // Region id
                            landPlanObject.regionId = regionId
//                                print("REGION ID: \(landPlanObject.regionId)")
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
                        if !personObject.receivedSubLand {
                            citizensArray.append(personObject)
                        }
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
        
        lotteryResultQuery.findObjectsInBackground { (results, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let results = results, !results.isEmpty {
                for result in results {
                    if let citizen = result["citizen"] as? PFObject, let citizenId = citizen.objectId, let subLand = result["subLand"] as? PFObject, let subLandId = subLand.objectId {
                        // Getting Sub Land indexes
                        for (index, subLandItem) in landPlan.lotterySubLandArray.enumerated() {
                            if subLandId == subLandItem.subLandId {
                                subLandIndexes.append(index)
                                break
                            }
                        }
                        
                        // Getting citizen indexes
                        for (index, queueItem) in landPlan.queueArray.enumerated() {
                            if citizenId == queueItem.objectId {
                                queueIndexes.append(index)
                                break
                            }
                        }
                    }
                }
                
                if subLandIndexes.count == queueIndexes.count, subLandIndexes.count > 0 {
                    pairsCount = subLandIndexes.count
                    landPlan.pairsCount = pairsCount
                    landPlan.subLandIndexes = subLandIndexes
                    landPlan.queueIndexes = queueIndexes
                    landPlan.resultLoaded = true
                }
            }
            
            completion(landPlan)
        }
    }
    
    /**
     Get received Sub Lands for user
     */
    
    public func getReceivedSubLands(citizenId: String, completion: @escaping (_ subLandArray: [KMAUISubLandStruct])->()) {
        let subLandsQuery = PFQuery(className: "KMALotteryResult")
        subLandsQuery.whereKey("citizen", equalTo: PFUser(withoutDataWithObjectId: citizenId))
        subLandsQuery.includeKey("subLand")
        subLandsQuery.includeKey("subLand.landPlan")
        
        subLandsQuery.findObjectsInBackground { (items, error) in
            var subLandArray = [KMAUISubLandStruct]()
            
            if let error = error {
                print(error.localizedDescription)
            } else if let items = items {
                for item in items {
                    var subLandObject = KMAUISubLandStruct()
                    
                    // Lottery result object id
                    if let lotteryResultId = item.objectId {
                        subLandObject.lotteryResultId = lotteryResultId
                    }
                    // Sub Land
                    if let subLandValue = item["subLand"] as? PFObject {
                        subLandObject.fillFromParse(item: subLandValue)
                    }
                    // Confirmed
                    if let confirmed = item["confirmed"] as? Bool {
                        subLandObject.confirmed = confirmed
                    }
                    // Status
                    if let status = item["status"] as? String {
                        subLandObject.status = status
                    }
                    // Paid
                    if let paid = item["paid"] as? Bool {
                        subLandObject.paid = paid
                    }
                    
                    subLandArray.append(subLandObject)
                }
            }
            
            completion(subLandArray)
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
    
    public func updatePropertyAndDocuments(citizenId: String, completion: @escaping (_ property: [KMACitizenProperty], _ documents: [KMAPropertyDocument])->()) {
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
                completion(property, documents)
            }
        }
    }
}

