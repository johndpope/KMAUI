//
//  KMAUIPropertyTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIPropertyTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var typeLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var ownershipLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var circleViewOne: UIView!
    @IBOutlet public weak var residentsLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var circleViewTwo: UIView!
    @IBOutlet public weak var addressLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIPropertyTableViewCell"
    public var property = KMACitizenProperty() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Type label
        typeLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Ownership label
        ownershipLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Circle views
        circleViewOne.layer.cornerRadius = 2.5
        circleViewOne.clipsToBounds = true
        circleViewTwo.layer.cornerRadius = 2.5
        circleViewTwo.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Property type
        if property.apartment > 0 {
            typeLabel.text = "Apartment"
        } else {
            typeLabel.text = "Private house"
        }
        
        // Ownership form
        ownershipLabel.text = property.ownershipForm
        
        // Residents count
        if property.residentsCount == 1 {
            residentsLabel.text = "1 resident"
        } else {
            residentsLabel.text = "\(property.residentsCount) residents"
        }
        
        // Address
        if property.formattedAddress.isEmpty {
            addressLabel.text = "No address"
        } else {
            addressLabel.text = property.formattedAddress
            let addressArray = property.formattedAddress.components(separatedBy: ",")
            
            if !addressArray.isEmpty {
                addressLabel.text = addressArray[0] + ", " + property.city
            }
        }
    }
}
