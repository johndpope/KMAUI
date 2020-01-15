//
//  KMACitizenPropertyCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMACitizenPropertyCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var propertyTypeImageView: UIImageView!
    @IBOutlet public weak var propertyTypeLabel: KMAUITextLabel!
    @IBOutlet public weak var propertyCreatedAtLabel: KMAUIInfoLabel!
    @IBOutlet public weak var propertyOwnershipFormLabel: KMAUIInfoLabel!
    
    // MARK: - Variables
    public var property = KMACitizenProperty()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Property type tint color
        propertyTypeImageView.tintColor = KMAUIConstants.shared.KMATextColor
    
        // Ownership form label
        propertyOwnershipFormLabel.textColor = UIColor.white
        propertyOwnershipFormLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        propertyOwnershipFormLabel.clipsToBounds = true
    }
    
    public func setupCell() {
        // Property type
        if property.apartment > 0 {
            propertyTypeImageView.image = KMAUIConstants.shared.apartmentIcon.withRenderingMode(.alwaysTemplate)
            propertyTypeLabel.text = "Apartment \(property.apartment)"
        } else {
            propertyTypeImageView.image = KMAUIConstants.shared.houseIcon.withRenderingMode(.alwaysTemplate)
            propertyTypeLabel.text = "Private house"
        }
        
        // Ownerhsip form
        propertyOwnershipFormLabel.text = "  " + property.ownershipForm + "  "
        if property.ownershipForm == "Owned" {
            propertyOwnershipFormLabel.backgroundColor = UIColor.systemBlue
        } else {
            propertyOwnershipFormLabel.backgroundColor = UIColor.systemPurple
        }
        
        // Created at
        propertyCreatedAtLabel.text = KMAUIUtilities.shared.formatStringShort(date: property.createdAt)
    }
    
}
