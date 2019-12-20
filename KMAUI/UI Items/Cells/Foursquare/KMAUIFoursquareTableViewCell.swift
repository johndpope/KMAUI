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
    
    // MARK: - Variables
    public var venue = KMAFoursquareVenue()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the right arrow
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
    
    public func setupColors(highlight: Bool) {
        if highlight {
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
        addressLabel.text = venue.address
        
        photoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        photoImageView.clipsToBounds = true
        photoImageView.layer.borderWidth = 0
        
        // Placeholder image for icon
        if let placeholderImage = UIImage(named: "venuePlaceholderIcon")?.withRenderingMode(.alwaysTemplate) {
            photoImageView.image = placeholderImage
        }
        
        photoImageView.tintColor = KMAUIConstants.shared.KMALineGray
        photoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        photoImageView.layer.borderWidth = 1
        photoImageView.kf.indicatorType = .activity
        
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
    }
}
