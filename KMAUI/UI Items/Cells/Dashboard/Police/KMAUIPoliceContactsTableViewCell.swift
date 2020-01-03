//
//  KMAUIPoliceContactsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import SafariServices

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
            KMAUIUtilities.shared.showItems(label: facebookLabel, constant1: facebookLabelHeight, constant2: facebookLabelTop, button: facebookButton)
        } else {
            KMAUIUtilities.shared.hideItems(label: facebookLabel, constant1: facebookLabelHeight, constant2: facebookLabelTop, button: facebookButton)
        }
        // Twitter
        if !neighbourhood.twitter.isEmpty {
            twitterButton.setTitle(neighbourhood.twitter, for: .normal)
            KMAUIUtilities.shared.showItems(label: twitterLabel, constant1: twitterLabelHeight, constant2: twitterLabelTop, button: twitterButton)
        } else {
            KMAUIUtilities.shared.hideItems(label: twitterLabel, constant1: twitterLabelHeight, constant2: twitterLabelTop, button: twitterButton)
        }
        // Website
        if !neighbourhood.website.isEmpty, let url = URL(string: neighbourhood.website), let host = url.host {
            websiteButton.setTitle(host, for: .normal)
            KMAUIUtilities.shared.showItems(label: websiteLabel, constant1: websiteLabelHeight, constant2: websiteLabelTop, button: websiteButton)
        } else {
            KMAUIUtilities.shared.hideItems(label: websiteLabel, constant1: websiteLabelHeight, constant2: websiteLabelTop, button: websiteButton)
        }
        // Email
        if !neighbourhood.email.isEmpty {
            emailButton.setTitle(neighbourhood.email, for: .normal)
            KMAUIUtilities.shared.showItems(label: emailLabel, constant1: emailLabelHeight, constant2: emailLabelTop, button: emailButton)
        } else {
            KMAUIUtilities.shared.hideItems(label: emailLabel, constant1: emailLabelHeight, constant2: emailLabelTop, button: emailButton)
        }
        // Phone
        if !neighbourhood.telephone.isEmpty {
            phoneButton.setTitle(neighbourhood.telephone, for: .normal)
            KMAUIUtilities.shared.showItems(label: phoneLabel, constant1: phoneLabelHeight, constant2: phoneLabelTop, button: phoneButton)
        } else {
            KMAUIUtilities.shared.hideItems(label: phoneLabel, constant1: phoneLabelHeight, constant2: phoneLabelTop, button: phoneButton)
        }
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
        if let url = URL(string: "tel://\(neighbourhood.telephone)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension KMAUIPoliceContactsTableViewCell: SFSafariViewControllerDelegate {
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
