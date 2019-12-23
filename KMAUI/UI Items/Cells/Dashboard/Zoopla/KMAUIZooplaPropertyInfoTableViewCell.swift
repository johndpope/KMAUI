//
//  KMAUIZooplaPropertyInfoTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIZooplaPropertyInfoTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var priceLabel: KMAUITitleLabel!
    @IBOutlet public weak var noteLabel: KMAUITextLabel!
    @IBOutlet public weak var nameLabel: KMAUITextLabel!
    @IBOutlet public weak var addressLabel: KMAUIInfoLabel!
    @IBOutlet public weak var bedIcon: UIImageView!
    @IBOutlet public weak var bedCountLabel: KMAUIInfoLabel!
    @IBOutlet public weak var bathIcon: UIImageView!
    @IBOutlet public weak var bathCountLabel: KMAUIInfoLabel!
    @IBOutlet public weak var receptIcon: UIImageView!
    @IBOutlet public weak var receptCountLabel: KMAUIInfoLabel!
    @IBOutlet public weak var floorIcon: UIImageView!
    @IBOutlet public weak var floorsCountLabel: KMAUIInfoLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var rightArrowImageViewWidth: NSLayoutConstraint!
    
    // MARK: - Variables
    public var zooplaProperty = KMAZooplaProperty()
    public var isList = false
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setting the color for images
        bedIcon.image = KMAUIConstants.shared.bedIcon.withRenderingMode(.alwaysTemplate)
        bedIcon.tintColor = KMAUIConstants.shared.KMALineGray
        bathIcon.image = KMAUIConstants.shared.bathIcon.withRenderingMode(.alwaysTemplate)
        bathIcon.tintColor = KMAUIConstants.shared.KMALineGray
        receptIcon.image = KMAUIConstants.shared.receptIcon.withRenderingMode(.alwaysTemplate)
        receptIcon.tintColor = KMAUIConstants.shared.KMALineGray
        floorIcon.image = KMAUIConstants.shared.floorsCountIcon.withRenderingMode(.alwaysTemplate)
        floorIcon.tintColor = KMAUIConstants.shared.KMALineGray
        
        // Setting the not label UI
        noteLabel.text = ""
        noteLabel.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
        noteLabel.textColor = UIColor.white
        noteLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        noteLabel.clipsToBounds = true
        
        // Setting the right arrow UI
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
        
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    func setupColors(highlight: Bool) {
        if highlight, isList {
            bgView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            priceLabel.textColor = UIColor.white
            noteLabel.textColor = KMAUIConstants.shared.KMABrightBlueColor
            noteLabel.backgroundColor = UIColor.white
            nameLabel.textColor = UIColor.white
            addressLabel.textColor = UIColor.white
            bedIcon.tintColor = UIColor.white
            bedCountLabel.textColor = UIColor.white
            bathIcon.tintColor = UIColor.white
            bathCountLabel.textColor = UIColor.white
            receptIcon.tintColor = UIColor.white
            receptCountLabel.textColor = UIColor.white
            floorIcon.tintColor = UIColor.white
            floorsCountLabel.textColor = UIColor.white
            rightArrowImageView.tintColor = UIColor.white
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMABackColor
            priceLabel.textColor = KMAUIConstants.shared.KMATitleColor
            noteLabel.textColor = UIColor.white
            noteLabel.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            nameLabel.textColor = KMAUIConstants.shared.KMATextColor
            addressLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            bedIcon.tintColor = KMAUIConstants.shared.KMATextGrayColor
            bedCountLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            bathIcon.tintColor = KMAUIConstants.shared.KMATextGrayColor
            bathCountLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            receptIcon.tintColor = KMAUIConstants.shared.KMATextGrayColor
            receptCountLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            floorIcon.tintColor = KMAUIConstants.shared.KMATextGrayColor
            floorsCountLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        }
    }
    
    /*
     Setup cell
     */
    
    public func setupCell() {
        // Get details data
        let info = zooplaProperty.getPropertyDescription()
        // price: sale / rent
        priceLabel.text = info.1
        // name
        nameLabel.text = info.0
        // bedrooms
        bedCountLabel.text = "\(zooplaProperty.numBedrooms)"
        // bathrooms
        bathCountLabel.text = "\(zooplaProperty.numBathrooms)"
        // receptions
        receptCountLabel.text = "\(zooplaProperty.numReceptions)"
        // floors
        floorsCountLabel.text = "\(zooplaProperty.numFloors)"
        // Notes badge
        if zooplaProperty.newHome {
            noteLabel.text = "  New build  "
        } else {
            let currentTime = Date().timeIntervalSince1970
            
            if zooplaProperty.lastPublishedDate > 0, (currentTime - zooplaProperty.lastPublishedDate) / 3600 < 24 {
                noteLabel.text = "  Just updated  "
            } else if zooplaProperty.firstPublishedDate > 0, (currentTime - zooplaProperty.firstPublishedDate) / 3600 < 24 {
                noteLabel.text = "  Just added  "
            } else {
                noteLabel.text = ""
            }
        }
        // Different UI for list and details
        if isList {
            // address
            addressLabel.text = zooplaProperty.address
            // Setup right arrow
            rightArrowImageView.alpha = 1
            rightArrowImageViewWidth.constant = 22
        } else {
            addressLabel.text = ""
            // Setup right arrow
            rightArrowImageView.alpha = 0
            rightArrowImageViewWidth.constant = 0
        }
    }
}
