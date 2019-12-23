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
    
    public func setupCell() {
//        if !venue.attributes.isEmpty, let dataFromString = venue.attributes.data(using: .utf8, allowLossyConversion: false),
//            let json = try? JSON(data: dataFromString).dictionary, let groups = json["groups"]?.array {
//            print("\nAttributes:")
//
//            for group in groups {
//                if let group = group.dictionary, let groupName = group["name"]?.string, let items = group["items"]?.array, !items.isEmpty {
//                    print("\nName: \(groupName):")
//
//                    for item in items {
//                        if let item = item.dictionary, let displayName = item["displayName"]?.string, let displayValue = item["displayValue"]?.string {
//                            if displayName != displayValue {
//                                print("\(displayName) - \(displayValue)")
//                            } else {
//                                print(displayName)
//                            }
//
//                        }
//                    }
//
        //                    // Special items: Menus, Drinks, Dining Options - sepaparate cells
        //                }
        //            }
        //        }
        
        if !venue.attributes.isEmpty, let dataFromString = venue.attributes.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary, let groups = json["groups"]?.array {
            var yesArray = [String]()
            var noArray = [String]()
            
            for group in groups {
                if let group = group.dictionary, let items = group["items"]?.array, !items.isEmpty {
                    for item in items {
                        if let item = item.dictionary, let displayName = item["displayName"]?.string, let displayValue = item["displayValue"]?.string {
                            if displayValue.starts(with: "Yes") {
                                yesArray.append(displayName)
                            } else if displayValue.starts(with: "No") {
                                noArray.append(displayName)
                            }
                        }
                    }
                }
            }
            
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
    }
}
