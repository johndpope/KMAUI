//
//  KMAUIRegionPerformanceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 21.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRegionPerformanceTableViewCell: UITableViewCell {

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
