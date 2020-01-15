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
    @IBOutlet public weak var documentImageView: UIImageView!
    @IBOutlet public weak var documentNameLabel: UILabel!
    
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
        
        // Document image view
        documentImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        documentImageView.clipsToBounds = true
        documentImageView.kf.indicatorType = .activity
        documentImageView.backgroundColor = KMAUIConstants.shared.KMABgGray
        documentImageView.contentMode = .scaleAspectFill
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
        
        // Document
        for document in property.documents {
            if !document.name.isEmpty {
                documentNameLabel.text = document.name
                
                let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: document.files)
                
                for file in files {
                    if !file.previewURL.isEmpty {
                        break
                    }
                    
                    if !file.previewURL.isEmpty, let url = URL(string: file.previewURL) {
                        documentImageView.kf.setImage(with: url)
                        
                        break
                    }
                }
                
                break
            }
            
        }
    }
    
}
