//
//  KMAPoliceDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAPoliceDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUITitleLabel!
    @IBOutlet public weak var forceLabel: UILabel!
    
    // MARK: - Variables
    public var neighbourhood = KMAPoliceNeighbourhood()
    public var logo = ""
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for logo
        logoImageView.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Library logo
        if !logo.isEmpty, let url = URL(string: logo) {
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: url)
        }
        
        // Name
        nameLabel.text = neighbourhood.name
        
        // Force
        forceLabel.text = "\(neighbourhood.forceId.capitalized.replacingOccurrences(of: "-", with: " ")) Police"
    }
}
