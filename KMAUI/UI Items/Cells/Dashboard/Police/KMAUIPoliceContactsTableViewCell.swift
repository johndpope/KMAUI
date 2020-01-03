//
//  KMAUIPoliceContactsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIPoliceContactsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var facebookLabel: KMAUITextLabel!
    @IBOutlet public weak var facebookLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var facebookLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var facebookButton: UIButton!
    @IBOutlet public weak var twitterLabel: KMAUITextLabel!
    @IBOutlet public weak var twitterLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var twitterLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var twitterButton: UIButton!
    @IBOutlet public weak var websiteLabel: KMAUITextLabel!
    @IBOutlet public weak var websiteLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var websiteLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var websiteButton: UIButton!
    @IBOutlet public weak var emailLabel: KMAUITextLabel!
    @IBOutlet public weak var emailLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var emailLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var emailButton: UIButton!
    @IBOutlet public weak var phoneLabel: KMAUITextLabel!
    @IBOutlet public weak var phoneLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var phoneLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var phoneButton: UIButton!
    
    // MARK: - Variables
    public var neighbourhood = KMAPoliceNeighbourhood()
    
    // MARK: - Cell method

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
        // Facebook
        if !neighbourhood.facebook.isEmpty {
            facebookButton.setTitle(neighbourhood.facebook, for: .normal)
            facebookButton.alpha = 1
            facebookLabel.alpha = 1
            facebookLabelTop.constant = 8
            facebookLabelHeight.constant = 44
        } else {
            facebookButton.alpha = 0
            facebookLabel.alpha = 0
            facebookLabelTop.constant = 0
            facebookLabelHeight.constant = 0
        }
        // Twitter
        // Website
        // Email
        // Phone
    }
}

/*
 // twitter
 if let twitter = contactDetails["twitter"]?.string {
     self.twitter = twitter
 }
 // facebook
 if let facebook = contactDetails["facebook"]?.string {
     self.facebook = facebook
 }
 // website
 if let website = contactDetails["website"]?.string {
     self.website = website
 }
 // telephone
 if let telephone = contactDetails["telephone"]?.string {
     self.telephone = telephone
 }
 // email
 if let email = contactDetails["email"]?.string {
     self.email = email
 }
 */
