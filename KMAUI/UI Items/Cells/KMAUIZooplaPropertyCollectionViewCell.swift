//
//  KMAUIZooplaPropertyCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

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
        propertyImageView.tintColor = KMAUIConstants.shared.KMALineGray
        propertyImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)

        layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
        clipsToBounds = true
    }
    
    override public var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
                propertyInfoLabel.textColor = UIColor.white
                layer.borderColor = KMAUIConstants.shared.KMABrightBlueColor.cgColor
                layer.borderWidth = KMAUIConstants.shared.KMABorderWidthBold
                // Your customized animation or add a overlay view
            } else {
                // Your customized animation or remove overlay view
                backgroundColor = KMAUIConstants.shared.KMABgGray
                propertyInfoLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
                layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
                layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
            }
        }
    }
    
    override public var isSelected: Bool {
        didSet {
            if self.isHighlighted {
                backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
                propertyInfoLabel.textColor = UIColor.white
                layer.borderColor = KMAUIConstants.shared.KMABrightBlueColor.cgColor
                layer.borderWidth = KMAUIConstants.shared.KMABorderWidthBold
                // Your customized animation or add a overlay view
            } else {
                // Your customized animation or remove overlay view
                backgroundColor = KMAUIConstants.shared.KMABgGray
                propertyInfoLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
                layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
                layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
            }
        }
    }
    
    /**
     Setup the data for cell
     */
    
    public func setupCell() {
        propertyImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)
        
        if let url = URL(string: propertyObject.image150x113) {
            propertyImageView.kf.indicatorType = .activity
            propertyImageView.kf.setImage(with: url)
        }
        
        let detailStrings = propertyObject.getPropertyDescription()
        propertyInfoLabel.text = detailStrings.0
        
        if detailStrings.1.isEmpty {
            priceLabel.alpha = 0
        } else {
            priceLabel.text = "  " + detailStrings.1 + " "
            priceLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            priceLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
            priceLabel.clipsToBounds = true
            priceLabel.alpha = 1
        }
    }
}
