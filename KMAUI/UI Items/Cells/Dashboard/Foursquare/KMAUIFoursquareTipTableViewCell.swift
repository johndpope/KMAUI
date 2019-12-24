//
//  KMAUIFoursquareTipTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 24.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyJSON

public class KMAUIFoursquareTipTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var authorImageView: UIImageView!
    @IBOutlet public weak var authorLabel: KMAUITextLabel!
    @IBOutlet public weak var createdAtLabel: KMAUIInfoLabel!
    @IBOutlet public weak var tipLabel: KMAUITextLabel!
    @IBOutlet public weak var tipImageView: UIImageView!
    @IBOutlet public weak var tipImageViewHeight: NSLayoutConstraint!
    
    // MARK: - Cell methods
    public var venue = KMAFoursquareVenue()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for image view
        authorImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        authorImageView.clipsToBounds = true
        
        // No selection requried
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        tipLabel.text = ""
        authorLabel.text = ""
        createdAtLabel.text = ""
        tipImageViewHeight.constant = 0
        
        if !venue.tips.isEmpty,
            let dataFromString = venue.tips.data(using: .utf8, allowLossyConversion: false),
            let json = try? JSON(data: dataFromString).dictionary {
            
            if let groups = json["groups"]?.array {
                for group in groups {
                    if let group = group.dictionary, let items = group["items"]?.array {
                        for item in items {
                            if let item = item.dictionary {
                                // photo url
                                if let photourl = item["photourl"]?.string, let url = URL(string: photourl) {
                                    tipImageView.kf.indicatorType = .activity
                                    tipImageView.kf.setImage(with: url)
                                    tipImageViewHeight.constant = (KMAUIConstants.shared.KMAScreenWidth - 64) * 2 / 3
                                }
                                // created at
                                if let createdAt = item["createdAt"]?.int {
                                    createdAtLabel.text =  KMAUIUtilities.shared.formatStringShort(date: Date(timeIntervalSince1970: Double(createdAt)))
                                }
                                // user
                                if let user = item["user"]?.dictionary {
                                    // firstName
                                    if let firstName = user["firstName"]?.string {
                                        print("firstName: \(firstName)")
                                        authorLabel.text = firstName
                                        
                                        // lastName
                                        if let lastName = user["lastName"]?.string {
                                            authorLabel.text = firstName + " " + lastName
                                        }
                                    }
                                    
                                    //
                                    if let photo = user["photo"]?.dictionary {
                                        if let prefix = photo["prefix"]?.string, let suffix = photo["suffix"]?.string {
                                            if let url = URL(string: "\(prefix)44\(suffix)") {
                                                authorImageView.kf.indicatorType = .activity
                                                authorImageView.kf.setImage(with: url)
                                            }
                                        }
                                    }
                                }
                                // text
                                if let text = item["text"]?.string {
                                    tipLabel.text = text
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
