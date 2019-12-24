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
        
        // Round corners for image views
        authorImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        authorImageView.clipsToBounds = true
        authorImageView.contentMode = .scaleAspectFill
        tipImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        tipImageView.clipsToBounds = true
        tipImageView.contentMode = .scaleAspectFill
        
        // No selection requried
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        let tipData = venue.getTip()
        
        // Tip image
        if !tipData.0.isEmpty, let url = URL(string: tipData.0) {
            tipImageView.kf.indicatorType = .activity
            tipImageView.kf.setImage(with: url)
            tipImageViewHeight.constant = (KMAUIConstants.shared.KMAScreenWidth - 64) * 2 / 3
        } else {
            tipImageViewHeight.constant = 0
        }
        
        // Created at
        createdAtLabel.text = tipData.1
        
        // Author
        authorLabel.text = tipData.2
        
        // Author image
        if !tipData.3.isEmpty, let url = URL(string: tipData.3) {
            authorImageView.kf.indicatorType = .activity
            authorImageView.kf.setImage(with: url)
        }
        
        // Tip
        tipLabel.text = tipData.4
    }
}


