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
    
    // MARK: - Variables
    public var welcomeText = ""
    public var homeSet = false
    
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
        welcomeTitleLabel.text = welcomeText
        
        if homeSet {
            welcomeTextLabel.text = NSLocalizedString("Details - Add address", comment: "") //"We're glad to provide you with up-to-date information about your home area.\nYou can review your home property, add water and electic bills, review some useful infomation from our partners."
        } else {
            welcomeTextLabel.text = NSLocalizedString("Details - Address data", comment: "") // "We're glad to provide you with up-to-date information about your home area.\nPlease add your home address to start receiving recommendations."
        }
    }
}
