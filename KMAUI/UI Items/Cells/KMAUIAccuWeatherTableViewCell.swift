//
//  KMAUIAccuWeatherTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 13.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIAccuWeatherTableViewCell: UITableViewCell {
    @IBOutlet public weak var weatherIcon: UIImageView!
    @IBOutlet public weak var weatherTitleLabel: KMAUITitleLabel!
    @IBOutlet public weak var weatherTextLabel: KMAUIInfoLabel!
    @IBOutlet public weak var activityView: UIActivityIndicatorView!
    
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
