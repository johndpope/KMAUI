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
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var propertyTypeImageView: UIImageView!
    @IBOutlet public weak var propertyTypeLabel: KMAUITextLabel!
    @IBOutlet public weak var propertyCreatedAtLabel: KMAUIInfoLabel!
    @IBOutlet public weak var propertyOwnershipFormLabel: KMAUIInfoLabel!
    @IBOutlet public weak var documentImageView: UIImageView!
    @IBOutlet public weak var documentNameBgView: UIView!
    @IBOutlet public weak var documentNameLabel: KMAUITextLabel!
    @IBOutlet public weak var addressLabel: KMAUITextLabel!
    @IBOutlet public weak var addressLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var residentsLabel: KMAUIInfoLabel!
    @IBOutlet public weak var residentNamesLabel: KMAUITextLabel!
    @IBOutlet public weak var residentNamesTopLabel: NSLayoutConstraint!
    
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
        documentImageView.layer.borderWidth = KMAUIConstants.shared.KMABorderWidthRegular
        documentImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.2).cgColor
        documentImageView.clipsToBounds = true
        documentImageView.kf.indicatorType = .activity
        documentImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        documentImageView.contentMode = .scaleAspectFill
        
        // Background for the document name
        documentNameBgView.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        documentNameLabel.textColor = UIColor.white
        documentNameBgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        documentNameBgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        documentNameBgView.clipsToBounds = true
    }
    
    public func setHighlight(mode: Bool) {
        if mode {
            bgView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            propertyTypeImageView.tintColor = UIColor.white
            propertyTypeLabel.textColor = UIColor.white
            propertyCreatedAtLabel.textColor = UIColor.white
            addressLabel.textColor = UIColor.white
            residentsLabel.textColor = UIColor.white
            residentNamesLabel.textColor = UIColor.white
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            propertyTypeImageView.tintColor = KMAUIConstants.shared.KMATextColor
            propertyTypeLabel.textColor = KMAUIConstants.shared.KMATextColor
            propertyCreatedAtLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            addressLabel.textColor = KMAUIConstants.shared.KMATextColor
            residentsLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            residentNamesLabel.textColor = KMAUIConstants.shared.KMATextColor
        }
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
        
        // Formatted address
        addressLabel.text = property.formattedAddress
        
        if property.formattedAddress.isEmpty {
            addressLabelTop.constant = 0
        } else {
            addressLabelTop.constant = 8
        }
        
        // Residents
        var residentsText = ""
        
        for resident in property.residents {
            if let name = resident["name"] as? String, !name.isEmpty {
                if residentsText.isEmpty {
                    residentsText = name
                } else {
                    residentsText += ", " + name
                }
            }
        }
        
        residentNamesLabel.text = residentsText
        
        if residentsText.isEmpty {
            residentsLabel.text = ""
            residentNamesTopLabel.constant = 0
        } else {
            residentsLabel.text = "Residents:"
            residentNamesTopLabel.constant = 8
        }
        
        // Document
        for document in property.documents {
            if !document.name.isEmpty {
                documentNameLabel.text = document.name
                
                let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: document.files)
                
                for file in files {
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
