//
//  KMAUIZooplaPropertyCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIDashboardCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var itemImageView: UIImageView!
    @IBOutlet public weak var priceLabel: KMAUITextLabel!
    @IBOutlet public weak var nameLabel: KMAUITextLabel!
    
    // MARK: - Variables
    public var property = KMAZooplaProperty()
    public var venue = KMAFoursquareVenue()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for image view
        itemImageView.tintColor = KMAUIConstants.shared.KMALineGray
        itemImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)

        layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
        clipsToBounds = true
    }
    
    public func setHighlight(mode: Bool) {
        if mode {
            backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            nameLabel.textColor = UIColor.white
            layer.borderColor = KMAUIConstants.shared.KMABrightBlueColor.cgColor
            layer.borderWidth = KMAUIConstants.shared.KMABorderWidthBold
        } else {
            backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            nameLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
            layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
        }
    }
    
    /**
     Setup the data for property
     */
    
    public func setupProperty() {
        itemImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)
        
        if let url = URL(string: property.image150x113) {
            itemImageView.kf.indicatorType = .activity
            itemImageView.kf.setImage(with: url)
        }
        
        let detailStrings = property.getPropertyDescription()
        nameLabel.text = detailStrings.0
        
        if detailStrings.1.isEmpty {
            priceLabel.alpha = 0
        } else {
            priceLabel.text = "  " + detailStrings.1 + " "
            priceLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            priceLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
            priceLabel.clipsToBounds = true
            priceLabel.alpha = 1
        }
    }
    
    /**
     Setup the data for
     */
    
    public func setupVenue() {
        itemImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)
        itemImageView.kf.indicatorType = .activity
        
        if !venue.prefix.isEmpty, !venue.suffix.isEmpty, let url = URL(string: venue.prefix + "150x113" + venue.suffix) {
            itemImageView.kf.setImage(with: url)
            itemImageView.contentMode = .scaleAspectFill
        } else if !venue.categoryPrefix.isEmpty, !venue.categorySuffix.isEmpty, let url = URL(string: venue.categoryPrefix + "44" + venue.categorySuffix) {
            itemImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.itemImageView.image = value.image.withRenderingMode(.alwaysTemplate)
                    self.itemImageView.contentMode = .center
                case .failure(let error):
                    print(error) // The error happens
                }
            }
        }

        nameLabel.text = venue.name

        if venue.distance < 1000 {
            priceLabel.text = " \(venue.distance)m "
        } else {
            priceLabel.text = ""
        }
        
        priceLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        priceLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        priceLabel.clipsToBounds = true
        priceLabel.alpha = 1
    }
}
