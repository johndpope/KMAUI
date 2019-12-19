//
//  KMAUIZooplaPropertyInfoTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZooplaPropertyInfoTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var priceLabel: KMAUITitleLabel!
    @IBOutlet public weak var nameLabel: KMAUITextLabel!
    @IBOutlet public weak var addressLabel: KMAUIInfoLabel!
    @IBOutlet public weak var bedIcon: UIImageView!
    @IBOutlet public weak var bedCountLabel: KMAUIInfoLabel!
    @IBOutlet public weak var bathIcon: UIImageView!
    @IBOutlet public weak var bathCountLabel: KMAUIInfoLabel!
    @IBOutlet public weak var receptIcon: UIImageView!
    @IBOutlet public weak var receptCountLabel: KMAUIInfoLabel!
    
    // MARK: - Variables
    public var zooplaProperty = KMAZooplaProperty()
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setting the color for images
        bedIcon.image = KMAUIConstants.shared.bedIcon.withRenderingMode(.alwaysTemplate)
        bedIcon.tintColor = KMAUIConstants.shared.KMALineGray
        bathIcon.image = KMAUIConstants.shared.bathIcon.withRenderingMode(.alwaysTemplate)
        bathIcon.tintColor = KMAUIConstants.shared.KMALineGray
        receptIcon.image = KMAUIConstants.shared.receptIcon.withRenderingMode(.alwaysTemplate)
        bathIcon.tintColor = KMAUIConstants.shared.KMALineGray
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Get details data
        let info = zooplaProperty.getPropertyDescription()
        // price: sale / rent
        priceLabel.text = info.1
        // name
        nameLabel.text = info.0
        // address
        addressLabel.text = zooplaProperty.address
        // bedrooms
        bedCountLabel.text = "\(zooplaProperty.numBedrooms)"
        // bathrooms
        bathCountLabel.text = "\(zooplaProperty.numBathrooms)"
        // receptions
        receptCountLabel.text = "\(zooplaProperty.numReceptions)"
    }
}
