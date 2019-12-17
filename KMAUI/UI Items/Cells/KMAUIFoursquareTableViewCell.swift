//
//  KMAUIFoursquareTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 13.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFoursquareTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var photoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var detailLabel: KMAUIInfoLabel!
    @IBOutlet public weak var addressLabel: UILabel!
    
    // MARK: - Variables
    public var venue = KMAFoursquareVenue()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
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
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMABackColor
            nameLabel.textColor = KMAUIConstants.shared.KMATitleColor
            detailLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
            addressLabel.textColor = KMAUIConstants.shared.KMATextGrayColor
        }
    }
    
    public func setupCell() {
        nameLabel.text = venue.name
        detailLabel.text = "\(venue.distance)m, \(venue.category)"
        addressLabel.text = venue.address
        
        photoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        photoImageView.clipsToBounds = true
        photoImageView.layer.borderWidth = 0
    }
}
