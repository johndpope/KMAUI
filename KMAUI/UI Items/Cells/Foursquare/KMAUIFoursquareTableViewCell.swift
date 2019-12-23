//
//  KMAUIFoursquareTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 13.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIFoursquareTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var photoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var detailLabel: KMAUIInfoLabel!
    @IBOutlet public weak var addressLabel: UILabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var rightArrowImageViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var rightArrowImageViewRight: NSLayoutConstraint!
    // Details UI
    @IBOutlet public weak var ratingLabel: KMAUITextLabel!

    // MARK: - Variables
    public var venue = KMAFoursquareVenue()
    public var canHighlight = true

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the right arrow
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // Setup the ratingLabel
        ratingLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        ratingLabel.clipsToBounds = true
        
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
    
    public func setupColors(highlight: Bool) {
        if highlight, canHighlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            nameLabel.textColor = UIColor.white
            detailLabel.textColor = UIColor.white
            addressLabel.textColor = UIColor.white
            rightArrowImageView.tintColor = UIColor.white
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMABackColor
            nameLabel.textColor = KMAUIConstants.shared.KMATitleColor
            detailLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            addressLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        }
    }
    
    public func setupCell() {
        nameLabel.text = venue.name
        detailLabel.text = "\(venue.distance)m, \(venue.category)"

        photoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        photoImageView.clipsToBounds = true
        photoImageView.tintColor = KMAUIConstants.shared.KMALineGray
        photoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        photoImageView.layer.borderWidth = 1
        photoImageView.kf.indicatorType = .activity
        
        // Placeholder image for icon
        if let placeholderImage = UIImage(named: "venuePlaceholderIcon")?.withRenderingMode(.alwaysTemplate) {
            photoImageView.image = placeholderImage
        }
        
        if canHighlight {
            // List mode
            addressLabel.text = venue.address
            
            if !venue.prefix.isEmpty, !venue.suffix.isEmpty, let url = URL(string: venue.prefix + "44x44" + venue.suffix) {
                photoImageView.kf.setImage(with: url)
            } else if !venue.categoryPrefix.isEmpty, !venue.categorySuffix.isEmpty, let url = URL(string: venue.categoryPrefix + "44" + venue.categorySuffix) {
                photoImageView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        self.photoImageView.image = value.image.withRenderingMode(.alwaysTemplate)
                    case .failure(let error):
                        print(error) // The error happens
                    }
                }
            }
        } else {
            addressLabel.text = "" // No need to have an address displayed
            
            if !venue.categoryPrefix.isEmpty, !venue.categorySuffix.isEmpty, let url = URL(string: venue.categoryPrefix + "44" + venue.categorySuffix) {
                photoImageView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        self.photoImageView.image = value.image.withRenderingMode(.alwaysTemplate)
                    case .failure(let error):
                        print(error) // The error happens
                    }
                }
            }
            
            // Details screen
            rightArrowImageView.alpha = 0
//            rightArrowImageViewWidth.constant = 0
//            rightArrowImageViewRight.constant = 0
        }
    }
}
