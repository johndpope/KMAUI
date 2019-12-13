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

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        nameLabel.text = venue.name
        detailLabel.text = "\(venue.distance)m, \(venue.category)"
        addressLabel.text = venue.address
    }
}
