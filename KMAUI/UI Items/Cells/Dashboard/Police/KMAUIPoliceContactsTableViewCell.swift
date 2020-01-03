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
    
    // MARK: - Variables
    var neighbourhood = KMAPoliceNeighbourhood()
    
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
