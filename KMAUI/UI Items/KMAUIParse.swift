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
    
    public func getMapAreas(level: Int, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
        getMapAreas(skip: 0, sw: sw, ne: ne, items: [KMAMapAreaStruct](), level: level, parentObjectId: parentObjectId) { (items) in
            completion(items)
        }
    }
    
    /**
     Get the map area
     */
    
    func getMapAreas(skip: Int, sw: CLLocationCoordinate2D? = nil, ne: CLLocationCoordinate2D? = nil,  items: [KMAMapAreaStruct], level: Int, parentObjectId: String, completion: @escaping (_ cities: [KMAMapAreaStruct])->()) {
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
        query.order(byAscending: "planName")
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
        lotteryResultQuery.includeKey("citizen")
        lotteryResultQuery.includeKey("citizen.homeAddress")
        lotteryResultQuery.includeKey("citizen.homeAddress.building")
        // Getting the region name
        lotteryResultQuery.includeKey("landPlan")
        lotteryResultQuery.includeKey("landPlan.region")
        
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
                                // Confirmed
                                if let confirmed = result["confirmed"] as? Bool {
                                    subLandCopy.confirmed = confirmed
                                }
                                // Status
                                if let status = result["status"] as? String {
                                    subLandCopy.status = status
                                }
                                // Paid
                                if let paid = result["paid"] as? Bool {
                                    subLandCopy.paid = paid
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
        
        for index in 0..<landPlan.pairsCount {
            let citizenIndex = landPlan.queueIndexes[index]
            let subLandIndex = landPlan.subLandIndexes[index]
            
            let citizen = landPlan.queueArray[citizenIndex]
            let subLand = landPlan.lotterySubLandArray[subLandIndex]
            
            let newLotteryResult = PFObject(className: "KMALotteryResult")
            newLotteryResult["citizen"] = PFUser(withoutDataWithObjectId: citizen.objectId)
            newLotteryResult["subLand"] = PFObject(withoutDataWithClassName: "KMASubLand", objectId: subLand.objectId)
            newLotteryResult["landPlan"] = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: landPlan.landPlanId)
            newLotteryResult["confirmed"] = false
            newLotteryResult["status"] = "pending"
            newLotteryResult["paid"] = false
            
            lotteryResults.append(newLotteryResult)
        }
        
        // Saving the lottery results array
        PFObject.saveAll(inBackground: lotteryResults) { (success, error) in
            if let error = error {
                KMAUIUtilities.shared.stopLoadingWith { (done) in
                    KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error saving the lottery results.\n\n\(error.localizedDescription)") { (done) in }
                }
            } else if success {
                print("Lottery results saved.")
                
                let landPlanObject = PFObject(withoutDataWithClassName: "KMALandPlan", objectId: landPlan.landPlanId)
                landPlanObject["lotteryCompleted"] = true
                
                landPlanObject.saveInBackground { (saveSuccess, saveError) in
                    KMAUIUtilities.shared.stopLoadingWith { (done) in
                        if let saveError = saveError {
                            print(saveError.localizedDescription)
                            KMAUIUtilities.shared.globalAlert(title: "Error", message: "Error saving the lottery results.\n\n\(saveError.localizedDescription)") { (done) in }
                        } else {
                            print("Land Plan status changed to completed.")
                            landPlan.lotteryCompleted = true
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
                print("Error loading people: \(error.localizedDescription)")
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
                print("Error loading people: \(error.localizedDescription)")
            } else if let people = people {
                print("People loaded: \(people.count)\n")
                
                
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
    
    public func universalSearch(searchObject: KMAUISearch) {
        
    }
    
    public func landPlanSearch(search: String, ids: [String]) {
        // search by: planName
        let query = PFQuery(className: "KMALandPlan")
        query.whereKey("planName", matchesRegex: String(format: "(?i)%@", search))
        query.whereKey("objectId", notContainedIn: ids)
        query.findObjectsInBackground { (landPlans, error) in
            if let error = error {
                print("Error loading Land plans: `\(error.localizedDescription)`.")
            } else if let landPlans = landPlans {
                for landPlan in landPlans {
                    var landPlanObject = KMAUILandPlanStruct()
                    landPlanObject.fillFromParse(plan: landPlan)
                }
            }
        }
    }
    
    public func subLandSearch(search: String, ids: [String]) {
        // search by: subLandId, subLandIndex, subLandType
    }
    
    public func citizenSearch(search: String, ids: [String]) {
        // search by: firstName, lastName, objectId
    }
}

