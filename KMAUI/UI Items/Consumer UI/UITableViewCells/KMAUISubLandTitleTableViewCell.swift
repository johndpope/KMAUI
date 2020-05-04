//
//  KMAUISubLandTitleTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISubLandTitleTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandTitleTableViewCell"
    public var subLand = KMAUISubLandStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Label adjustments
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(28)
        titleLabel.textColor = UIColor.white
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        infoLabel.textColor = UIColor.white
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if subLand.subLandType.isEmpty {
            statusLabel.text = ""
            titleLabel.text = ""
            infoLabel.text = ""
        } else {
            statusLabel.text = subLand.status
            
            if KMAUIConstants.shared.nonLivingTypes.contains(subLand.subLandType) {
                titleLabel.text = subLand.subLandId
            } else {
                titleLabel.text = "Land ID \(subLand.subLandId)"
            }
            
            if subLand.regionName.isEmpty {
                infoLabel.text = ""
            } else {
                infoLabel.text = "\(subLand.regionName) Region"
            }
        }
    }
}
