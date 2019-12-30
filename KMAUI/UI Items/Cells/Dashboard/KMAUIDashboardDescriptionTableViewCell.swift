//
//  KMAUIZooplaPropertyDescriptionTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDashboardDescriptionTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var propertyTitleLabel: KMAUITitleLabel!
    @IBOutlet public weak var propertyDescriptionLabel: KMAUIInfoLabel!
    
    // MARK: - Variables
    public var type = ""
    public var textValue = ""
    
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
        propertyTitleLabel.text = type.capitalized
        
        if textValue.isEmpty {
            propertyDescriptionLabel.text = "No \(type) available."
        } else if type == "description" {
            propertyDescriptionLabel.text = textValue.htmlToString
        } else if type == "letting fees" {
            propertyDescriptionLabel.text = textValue.htmlToString
        }
    }
}
