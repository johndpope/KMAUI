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
    @IBOutlet public weak var priceLabel: UILabel!
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
        let detailStrings = propertyObject.getPropertyDescription()
        propertyInfoLabel.text = detailStrings.0
        
        if detailStrings.1.isEmpty {
            priceLabel.alpha = 0
        } else {
            priceLabel.text = "  " + detailStrings.1 + " "
            priceLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            priceLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            priceLabel.clipsToBounds = true
            priceLabel.alpha = 1
        }
    }
}
