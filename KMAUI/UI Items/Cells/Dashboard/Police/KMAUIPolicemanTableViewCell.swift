//
//  KMAUIPolicemanTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 02.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIPolicemanTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var rankLabel: KMAUITextLabel!
    
    // MARK: - Variables
    public var policeman = KMAPoliceman()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Logo image
        logoImageView.image = KMAUIConstants.shared.policemanIcon.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        logoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        logoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        logoImageView.layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        nameLabel.text = policeman.name
        rankLabel.text = policeman.rank
    }
}
