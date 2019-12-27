//
//  KMAUIDashboadNoDataTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDashboadNoDataTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var infoLabel: KMAUITextLabel!
    @IBOutlet public weak var actionButton: KMAUIButtonFilled!
    @IBOutlet public weak var actionButtonHeight: NSLayoutConstraint!
    @IBOutlet public weak var actionButtonBottom: NSLayoutConstraint!
    @IBOutlet public weak var activityView: UIActivityIndicatorView!
    @IBOutlet public weak var activityViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var activityViewLeft: NSLayoutConstraint!
    
    // MARK: - Variables
    public var info = ""
    public var action = ""
    public var actionCallback: ((Bool) -> Void)?
    public var type = ""
    public var isLoaded = false
    
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
        if type == "venue" {
            if isLoaded {
                info = "Unfortunately we don't have any cafes & restaurants recommendations for your home area."
                action = ""
            } else {
                info = "We're preparing the cafes & restaurants list for your home address..."
                action = ""
            }
        } else if type == "property" {
            if isLoaded {
                info = "Unfortunately we don't have a property list to show for your home address location.\n\nThe home address should be inside the United Kingdom in order to see the data from Zoopla."
                action = "Update home address"
            } else {
                info = "We're preparing the property list for your home address..."
                action = ""
            }
        }
        
        infoLabel.text = info
        actionButton.setTitle(action, for: .normal)
        
        if action.isEmpty {
            actionButton.alpha = 0
            actionButtonHeight.constant = 0
            actionButtonBottom.constant = 0
        } else {
            actionButton.alpha = 1
            actionButtonHeight.constant = 44
            actionButtonBottom.constant = 8
        }
        
        if isLoaded {
            activityView.alpha = 0
            activityViewWidth.constant = 0
            activityViewLeft.constant = 0
        } else {
            activityView.alpha = 1
            activityView.startAnimating()
            activityViewWidth.constant = 44
            activityViewLeft.constant = 8
        }
    }
    
    @IBAction public func actionButtonPressed(_ sender: Any) {
        actionCallback?(true)
    }
}
