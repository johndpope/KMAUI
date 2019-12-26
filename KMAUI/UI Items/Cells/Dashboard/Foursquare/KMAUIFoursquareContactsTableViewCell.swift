//
//  KMAUIFoursquareContactsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 26.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFoursquareContactsTableViewCell: UITableViewCell {
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
    }
}
