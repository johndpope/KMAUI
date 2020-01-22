//
//  KMAUIPolice.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 27.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import CoreLocation

public class KMAUIPolice {
    
    // Access variable
    public static let shared = KMAUIPolice()
    
    // MARK: - Police.uk API
    
    /**
     Get the neighbourhood data for location
     */
    
    public func getNeighbourhood(location: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/locate-neighbourhood?q=\(location)"
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
                        completion(jsonString, "")
                    } else {
                        completion("", "Error")
                    }
                } catch {
                    completion("", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get the neighbourhood details
     */
    
    public func getNeighbourhoodDetails(neighbourhood: KMAPoliceNeighbourhood, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let force = "\(neighbourhood.forceId)/\(neighbourhood.forceTeamId)"
        let requestString = "https://data.police.uk/api/\(force)"

        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
                        completion(jsonString, "")
                    } else {
                        completion("", "Error")
                    }
                } catch {
                    completion("", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get the neighbourhood bounds
     */
    
    public func getNeighbourhoodBounds(neighbourhood: KMAPoliceNeighbourhood, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let force = "\(neighbourhood.forceId)/\(neighbourhood.forceTeamId)"
        let requestString = "https://data.police.uk/api/\(force)/boundary"

        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
                        completion(jsonString, "")
                    } else {
                        completion("", "Error")
                    }
                } catch {
                    completion("", error.localizedDescription)
                }
            }
        }
    }
    
    /**
     Get crime in bounds
     */
    
    public func getNeighbourhoodCrime(neighbourhood: KMAPoliceNeighbourhood, date: String, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let requestString = "https://data.police.uk/api/crimes-street/all-crime?poly=\(neighbourhood.polygonString)" // &date=\(date)
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
                        completion(jsonString, "")
                    } else {
                        completion("", "Error")
                    }
                } catch {
                    completion("", error.localizedDescription)
                }
            }
        }
    }

    /**
     Get the neighbourhood team
     */
    
    public func getNeighbourhoodTeam(neighbourhood: KMAPoliceNeighbourhood, completion: @escaping (_ jsonString: String, _ error: String)->()) {
        let force = "\(neighbourhood.forceId)/\(neighbourhood.forceTeamId)"
        let requestString = "https://data.police.uk/api/\(force)/people"
        
        AF.request(requestString).responseJSON { response in
            if let responseData = response.data {
                do {
                    let json = try JSON(data: responseData)
                    
                    if let jsonString = json.rawString(), !jsonString.isEmpty {
                        completion(jsonString, "")
                    } else {
                        completion("", "Error")
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                    completion("", error.localizedDescription)
                }
            }
        }
    }
}

