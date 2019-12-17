//
//  KMAUIZooplaPropertyCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZooplaPropertyCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var propertyImageView: UIImageView!
    @IBOutlet public weak var propertyInfoLabel: KMAUIInfoLabel!
    
    // MARK: - Variables
    public var propertyObject = KMAZooplaProperty()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for image view
        propertyImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        propertyImageView.clipsToBounds = true
        propertyImageView.tintColor = KMAUIConstants.shared.KMALineGray
        propertyImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        propertyImageView.layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
        propertyImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)
    }
    
    /**
     Setup the data for cell
     */
    
    public func setupCell() {
        var propertyDescription = ""
                    
                    // bedrooms
                    if propertyObject.numBedrooms > 0 {
                        propertyDescription = "\(propertyObject.numBedrooms) bedroom"
                    }
                    
                    // type
                    if !propertyObject.type.isEmpty {
                        if propertyDescription.isEmpty {
                            propertyDescription = propertyObject.type
                        } else {
                            propertyDescription += " " + propertyObject.type.lowercased()
                        }
                    }
                    
                    // status
                    if !propertyObject.status.isEmpty {
                        if propertyDescription.isEmpty {
                            if propertyObject.status == "rent" {
                                propertyDescription = "To rent, £\(propertyObject.rentMonth.withCommas()) pcm"
                            } else if propertyObject.status == "sale" {
                                propertyDescription = "For sale, £\(propertyObject.salePrice.withCommas())"
                            }
                        } else {
                            if propertyObject.status == "rent" {
                                propertyDescription += " to rent, £\(propertyObject.rentMonth.withCommas()) pcm"
                            } else if propertyObject.status == "sale" {
                                propertyDescription += " for sale, £\(propertyObject.salePrice.withCommas())"
                            }
                        }
                    }
                    
        if propertyDescription.isEmpty {
            propertyInfoLabel.text = "Property"
        } else {
            propertyInfoLabel.text = propertyDescription
        }
    }
}
