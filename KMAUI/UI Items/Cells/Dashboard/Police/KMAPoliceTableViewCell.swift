//
//  KMAPoliceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 28.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAPoliceTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var headerLabel: KMAUITitleLabel!
    @IBOutlet public weak var infoLabel: KMAUITextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    var policeObject = KMAUIPolice()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the right arrow
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
