//
//  KMAUIZoopla.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZoopla {

    // Access variable
    public static let shared = KMAUIZoopla()
    
    /**
     Get the average formatted details from the KMAZooplaProperty array
     */
    
    public func getAverage(propertyArray: [KMAZooplaProperty]) -> (String, String) {
        var averageRent = "Not available"
        var averageSale = "Not available"
        
        // Sale data
        var saleProperty = [KMAZooplaProperty]()
        var saleBedrooms = 0
        var salePrice = 0
        // Rent data
        var rentProperty = [KMAZooplaProperty]()
        var rentBedrooms = 0
        var rentPrice = 0

        for property in propertyArray {
            if property.status == "rent" {
                rentProperty.append(property)
                rentBedrooms += property.numBedrooms
                rentPrice += property.rentMonth
            } else if property.status == "sale" {
                saleProperty.append(property)
                saleBedrooms += property.numBedrooms
                salePrice += property.salePrice
            }
        }
        
        // Rent analysis
        if !saleProperty.isEmpty {
            let averageRentValue = rentPrice/rentProperty.count
            averageRent = "£\(averageRentValue.withCommas()) pcm (\(rentProperty.count))"
        }

        // Sale analysis
        if !saleProperty.isEmpty {
            let averageSaleValue = salePrice/saleProperty.count
            averageSale = "£\(averageSaleValue.withCommas()) (\(saleProperty.count))"
        }

        return (averageRent, averageSale)
    }
}
