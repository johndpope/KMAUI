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
        print("Facebook: `\(neighbourhood.facebook)`")
        print("Twitter: `\(neighbourhood.twitter)`")
        print("Website: `\(neighbourhood.website)`")
        print("Email: `\(neighbourhood.email)`")
        print("Phone: `\(neighbourhood.telephone)`")
        
        facebookButton.setTitle(neighbourhood.facebook, for: .normal)
        twitterButton.setTitle(neighbourhood.twitter, for: .normal)
        websiteButton.setTitle(neighbourhood.website, for: .normal)
        emailButton.setTitle(neighbourhood.email, for: .normal)
        phoneButton.setTitle(neighbourhood.telephone, for: .normal)
        
        // Facebook
//        if !neighbourhood.facebook.isEmpty {
//            facebookButton.setTitle(neighbourhood.facebook, for: .normal)
//            facebookButton.alpha = 1
//            facebookLabel.alpha = 1
//            facebookLabelTop.constant = 8
//            facebookLabelHeight.constant = 44
//        } else {
//            facebookButton.alpha = 0
//            facebookLabel.alpha = 0
//            facebookLabelTop.constant = 0
//            facebookLabelHeight.constant = 0
//        }
//        // Twitter
//        if !neighbourhood.twitter.isEmpty {
//            twitterButton.setTitle(neighbourhood.twitter, for: .normal)
//            twitterButton.alpha = 1
//            twitterLabel.alpha = 1
//            twitterLabelTop.constant = 8
//            twitterLabelHeight.constant = 44
//        } else {
//            twitterButton.alpha = 0
//            twitterLabel.alpha = 0
//            twitterLabelTop.constant = 0
//            twitterLabelHeight.constant = 0
//        }
//        // Website
//        if !neighbourhood.website.isEmpty {
//            websiteButton.setTitle(neighbourhood.website, for: .normal)
//            websiteButton.alpha = 1
//            websiteLabel.alpha = 1
//            websiteLabelTop.constant = 8
//            websiteLabelHeight.constant = 44
//        } else {
//            websiteButton.alpha = 0
//            websiteLabel.alpha = 0
//            websiteLabelTop.constant = 0
//            websiteLabelHeight.constant = 0
//        }
//        // Email
//        if !neighbourhood.email.isEmpty {
//            emailButton.setTitle(neighbourhood.email, for: .normal)
//            emailButton.alpha = 1
//            emailLabel.alpha = 1
//            emailLabelTop.constant = 8
//            emailLabelHeight.constant = 44
//        } else {
//            emailButton.alpha = 0
//            emailLabel.alpha = 0
//            emailLabelTop.constant = 0
//            emailLabelHeight.constant = 0
//        }
//        // Phone
//        if !neighbourhood.telephone.isEmpty {
//            phoneButton.setTitle(neighbourhood.telephone, for: .normal)
//            phoneButton.alpha = 1
//            phoneLabel.alpha = 1
//            phoneLabelTop.constant = 8
//            phoneLabelHeight.constant = 44
//        } else {
//            phoneButton.alpha = 0
//            phoneLabel.alpha = 0
//            phoneLabelTop.constant = 0
//            phoneLabelHeight.constant = 0
//        }
    }
    
    // MARK: - IBActions
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
    }
    
    @IBAction func twitterButtonPressed(_ sender: Any) {
    }
    
    @IBAction func websiteButtonPressed(_ sender: Any) {
    }
    
    @IBAction func emailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func phoneButtonPressed(_ sender: Any) {
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
