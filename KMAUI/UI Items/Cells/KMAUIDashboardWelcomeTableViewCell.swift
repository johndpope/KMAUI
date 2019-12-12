//
//  KMAUIDashboardWelcomeTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 12.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDashboardWelcomeTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var welcomeTitleLabel: KMAUITitleLabel!
    @IBOutlet public weak var welcomeTextLabel: KMAUITextLabel!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
