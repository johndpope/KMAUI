//
//  KMAUIFoursquareAttributesTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 23.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import SwiftyJSON

public class KMAUIFoursquareAttributesTableViewCell: UITableViewCell {
    // MARK: - Variables
    @IBOutlet public weak var titleLabel: KMAUITitleLabel!
    @IBOutlet public weak var attributesLabel: KMAUITextLabel!
    
    // MARK: - Variables
    public var venue = KMAFoursquareVenue()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupAttributes() {
        let attributes = venue.getAttributes()
        let yesArray = attributes.0
        let noArray = attributes.1
        titleLabel.text = "Services"
        
        if yesArray.isEmpty, noArray.isEmpty {
            attributesLabel.text = "No data available"
        } else {
            var attributesString = ""
            
            for yesObject in yesArray {
                if attributesString.isEmpty {
                    attributesString = "✓ " + yesObject
                } else {
                    attributesString += "\n" + "✓ " + yesObject
                }
            }
            
            for noObject in noArray {
                if attributesString.isEmpty {
                    attributesString = "✗ " + noObject
                } else {
                    attributesString += "\n" + "✗ " + noObject
                }
            }
            
            attributesLabel.text = attributesString
        }
    }
    
    public func setupWorkingHours() {
        titleLabel.text = "Working hours"
        var workingHours = ""
        
        if !venue.hours.isEmpty,
            let dataFromString = venue.hours.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {

            if let timeframes = json["timeframes"]?.array {
                for timeframe in timeframes {
                    if let timeframe = timeframe.dictionary {
                        if let days = timeframe["days"]?.string, let open = timeframe["open"]?.array {
                            var schedule = ""
                            
                            for openObject in open {
                                if let openObject = openObject.dictionary, let renderedTime = openObject["renderedTime"]?.string {
                                    if schedule.isEmpty {
                                        schedule = renderedTime
                                    } else {
                                        schedule += ", " + renderedTime
                                    }
                                }
                            }
                            
                            let dayString = days + ": " + schedule
                            
                            if workingHours.isEmpty {
                                workingHours = dayString
                            } else {
                                workingHours += "\n" + dayString
                            }
                        }
                    }
                }
            }
        }
        
        if workingHours.isEmpty {
            attributesLabel.text = "No data available"
        } else {
            attributesLabel.text = workingHours
        }
    }
}
