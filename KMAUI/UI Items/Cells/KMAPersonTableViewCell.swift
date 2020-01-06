//
//  KMAPersonTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 06.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

class KMAPersonTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: KMAUITitleLabel!
    @IBOutlet weak var usernameLabel: KMAUITextLabel!
    @IBOutlet weak var rightArrowImageView: UIImageView!

    // MARK: - Cell methods

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Right arrow image view
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
