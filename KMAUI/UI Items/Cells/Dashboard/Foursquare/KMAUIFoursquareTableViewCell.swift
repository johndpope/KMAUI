//
//  KMAUIFoursquareTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 13.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

public class KMAUIFoursquareTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var photoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var detailLabel: KMAUITextLabel!
    @IBOutlet public weak var addressLabel: KMAUITextLabel!
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
        
        // Setup the image view
        photoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        photoImageView.clipsToBounds = true
        photoImageView.tintColor = KMAUIConstants.shared.KMALineGray
        photoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        photoImageView.layer.borderWidth = 1
        photoImageView.kf.indicatorType = .activity
        
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
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            nameLabel.textColor = KMAUIConstants.shared.KMATitleColor
            detailLabel.textColor = KMAUIConstants.shared.KMATextColor
            addressLabel.textColor = KMAUIConstants.shared.KMATextColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        }
    }
    
    public func setupCell() {
        // Placeholder image for icon
        if let placeholderImage = UIImage(named: "venuePlaceholderIcon")?.withRenderingMode(.alwaysTemplate) {
            photoImageView.image = placeholderImage
        }
        
        // name
        nameLabel.text = venue.name
        
        // details
        detailLabel.text =  venue.getDetails()
        
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
                        print(error.localizedDescription) // The error happens
                    }
                }
            }
            
            ratingLabel.text = ""
            ratingLabel.alpha = 0
        } else {
            addressLabel.text = "" // No need to have an address displayed
            
            if !venue.hours.isEmpty, let dataFromString = venue.hours.data(using: .utf8, allowLossyConversion: false),
                let json = try? JSON(data: dataFromString).dictionary {
                if let richStatus = json["richStatus"]?.dictionary, let text = richStatus["text"]?.string, !text.isEmpty {
                    addressLabel.text = text
                }
            }
            
            if !venue.categoryPrefix.isEmpty, !venue.categorySuffix.isEmpty, let url = URL(string: venue.categoryPrefix + "44" + venue.categorySuffix) {
                photoImageView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        self.photoImageView.image = value.image.withRenderingMode(.alwaysTemplate)
                    case .failure(let error):
                        print(error.localizedDescription) // The error happens
                    }
                }
            }
            
            // Details screen
            rightArrowImageView.alpha = 0
            
            if venue.rating > 0 {
                ratingLabel.text = "\(venue.rating)"
                ratingLabel.alpha = 1
                ratingLabel.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
                ratingLabel.textColor = UIColor.white
                
                if !venue.ratingColor.isEmpty {
                    ratingLabel.backgroundColor = KMAUIUtilities.shared.hexStringToUIColor(hex: "#\(venue.ratingColor)")
                }
            } else {
                ratingLabel.text = ""
                ratingLabel.alpha = 0
            }
        }
    }
}
