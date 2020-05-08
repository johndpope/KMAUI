//
//  KMAUISubLandIdTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 08.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import KMAUI

public class KMAUISubLandIdTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandIdTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
