//
//  KMAUIAccuWeatherTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 13.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIAccuWeatherTableViewCell: UITableViewCell {
    @IBOutlet public weak var weatherIcon: UIImageView!
    @IBOutlet public weak var weatherTitleLabel: KMAUITitleLabel!
    @IBOutlet public weak var weatherTextLabel: KMAUITextLabel!
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
    
    public func setLoading() {
        weatherTitleLabel.text = "Neighbourhood weather"
        weatherTextLabel.text = "Preparing details..."
        activityView.alpha = 1
        activityView.startAnimating()
        weatherIcon.alpha = 0
    }
    
    public func setWeather(weatherObject: KMAWeather) {
        weatherTitleLabel.text = weatherObject.title
        weatherTextLabel.text = weatherObject.text
        weatherIcon.alpha = 1
        activityView.alpha = 0
        
        if weatherObject.image == "Error" {
            weatherIcon.tintColor = KMAUIConstants.shared.KMALineGray
            weatherIcon.image = KMAUIConstants.shared.weatherError.withRenderingMode(.alwaysTemplate)
        } else if let url = URL(string: weatherObject.image) {
            weatherIcon.kf.indicatorType = .activity
            weatherIcon.kf.setImage(with: url)
        }
    }
}
