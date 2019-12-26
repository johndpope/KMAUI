//
//  KMAUIFoursquareContactsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 26.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFoursquareContactsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var facebookTitleLabel: KMAUITextLabel!
    @IBOutlet public weak var facebookTitleHeight: NSLayoutConstraint!
    @IBOutlet public weak var facebookTitleTop: NSLayoutConstraint!
    @IBOutlet public weak var facebookUsernameButton: UIButton!
    @IBOutlet public weak var instagramTitleLabel: KMAUITextLabel!
    @IBOutlet public weak var instagramTitleHeight: NSLayoutConstraint!
    @IBOutlet public weak var instagramTitleTop: NSLayoutConstraint!
    @IBOutlet public weak var instagramUsernameButton: UIButton!
    @IBOutlet public weak var twitterTitleLabel: KMAUITextLabel!
    @IBOutlet public weak var twitterTitleHeight: NSLayoutConstraint!
    @IBOutlet public weak var twitterTitleTop: NSLayoutConstraint!
    @IBOutlet public weak var twitterUsernameButton: UIButton!
    @IBOutlet public weak var phoneTitleLabel: KMAUITextLabel!
    @IBOutlet public weak var phoneTitleHeight: NSLayoutConstraint!
    @IBOutlet public weak var phoneTitleTop: NSLayoutConstraint!
    @IBOutlet public weak var phoneNumberButton: UIButton!

    // MARK: - Cell methods
    public var venue = KMAFoursquareVenue()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        let contactsData = venue.getContacts()
        
        // Facebook
        if !contactsData.0.isEmpty, !contactsData.1.isEmpty, !contactsData.2.isEmpty {
            showItems(label: facebookTitleLabel, constant1: facebookTitleHeight, constant2: facebookTitleTop, button: facebookUsernameButton)
            facebookUsernameButton.setTitle(contactsData.1.formatUsername(), for: .normal)
        } else {
            hideItems(label: facebookTitleLabel, constant1: facebookTitleHeight, constant2: facebookTitleTop, button: facebookUsernameButton)
        }
        
        // Instagram
        if !contactsData.3.isEmpty {
            showItems(label: instagramTitleLabel, constant1: instagramTitleHeight, constant2: instagramTitleTop, button: instagramUsernameButton)
            instagramUsernameButton.setTitle(contactsData.3.formatUsername(), for: .normal)
        } else {
            hideItems(label: instagramTitleLabel, constant1: instagramTitleHeight, constant2: instagramTitleTop, button: instagramUsernameButton)
        }
        
        // Twitter
        if !contactsData.4.isEmpty {
            showItems(label: twitterTitleLabel, constant1: twitterTitleHeight, constant2: twitterTitleTop, button: twitterUsernameButton)
            twitterUsernameButton.setTitle(contactsData.4.formatUsername(), for: .normal)
        } else {
            hideItems(label: twitterTitleLabel, constant1: twitterTitleHeight, constant2: twitterTitleTop, button: twitterUsernameButton)
        }
        
        // Phone
        if !contactsData.5.isEmpty, !contactsData.6.isEmpty {
            showItems(label: phoneTitleLabel, constant1: phoneTitleHeight, constant2: phoneTitleTop, button: phoneNumberButton)
            phoneNumberButton.setTitle(contactsData.6, for: .normal)
        } else {
            hideItems(label: phoneTitleLabel, constant1: phoneTitleHeight, constant2: phoneTitleTop, button: phoneNumberButton)
        }
    }
    
    public func showItems(label: UILabel, constant1: NSLayoutConstraint, constant2: NSLayoutConstraint, button: UIButton) {
        label.alpha = 1
        constant1.constant = 22
        constant2.constant = 8
        button.alpha = 1
    }
    
    public func hideItems(label: UILabel, constant1: NSLayoutConstraint, constant2: NSLayoutConstraint, button: UIButton) {
        label.alpha = 0
        constant1.constant = 0
        constant2.constant = 0
        button.alpha = 0
    }
}
