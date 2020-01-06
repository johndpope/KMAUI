//
//  KMAPersonTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 06.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAPersonTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var fullNameLabel: KMAUITitleLabel!
    @IBOutlet public weak var usernameLabel: KMAUITextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!

    // MARK: - Cell methods

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Right arrow image view
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
