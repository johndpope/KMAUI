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
    @IBOutlet public weak var itemLabel: KMAUITitleLabel!
    @IBOutlet public weak var descriptionLabel: KMAUIInfoLabel!
    
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
        itemLabel.text = type.capitalized
        
        if textValue.isEmpty {
            descriptionLabel.text = "No \(type) available."
        } else if type == "description" {
            descriptionLabel.text = textValue.htmlToString
        } else if type == "letting fees" {
            descriptionLabel.text = textValue.htmlToString
        }
    }
}
