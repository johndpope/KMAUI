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
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var infoLabel: KMAUIBoldTextLabel!
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
    public var isFirst = false
    public var isLoaded = false {
        didSet {
            setupCell()
        }
    }
    public static let id = "KMAUIDashboadNoDataTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Font size for infoLabel
        infoLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if isFirst {
            bgViewTop.constant = 12
        } else {
            bgViewTop.constant = 0
        }
        
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
        } else if type == "police" {
            if isLoaded {
               info = "Unfortunately we don't have a police information to show for you home address location.\n\nThe home address should be inside the United Kingdom in order to see the data from Police.uk."
                action = "Update home address"
            } else {
                info = "We're preparing the police information for your home address..."
                action = ""
            }
        } else if type == "Uploads" {
            if isLoaded {
                info = "This citizen has no uploaded items yet."
                action = ""
            } else {
                info = "We're preparing the uploaded items list..."
                action = ""
            }
        } else if type == "Property" {
            if isLoaded {
                info = "This citizen has no property data to display."
                action = ""
            } else {
                info = "We're preparing the property data..."
                action = ""
            }
        } else if type == "items" {
            if isLoaded {
                info = "No items to display."
                action = ""
            } else {
                info = "We're preparing the items..."
                action = ""
            }
        } else if type == "regions" {
            info = "Please select the region to review the list of Land Plans for it."
            action = ""
        } else if type == "noLandPlans" {
            info = "No active Land Plans exist for region."
            action = ""
        } else if type == "noRegions" {
            if isLoaded {
                info = "No Saudi Arabia regions are available."
                action = ""
            } else {
                info = "We're preparing the regions list..."
                action = ""
            }
        } else if type == "lottery" {
            info = "No lotteries available for region."
            action = ""
        } else if type == "noCitizens" {
            if isLoaded {
                info = "The Land lottery queue has no citizens."
                action = ""
            } else {
                info = "Loading the citizen queue for the Land lottery..."
                action = ""
            }
        } else if type == "noDocuments" {
            if isLoaded {
                info = "This citizen has no documents yet."
                action = ""
            } else {
                info = "We're preparing the documents..."
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
