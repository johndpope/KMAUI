//
//  KMAUICitizenTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUICitizenTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteryIdLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUICitizenTableViewCell"
    public var citizen = KMAPerson() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the profileImageView
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor
        profileImageView.layer.borderColor = KMAUIConstants.shared.KMATextGrayColor.cgColor
        profileImageView.layer.borderWidth = KMAUIConstants.shared.KMABorderWidthLight
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        
        // Right arrow image view
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
        
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight {
            backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        } else {
            backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
    
    public func setupCell() {
        // Setup full name
        nameLabel.text = citizen.fullName
        // Setup lottery id
        lotteryIdLabel.text = "Lottery ID – \(citizen.lotteryObjectId)"
        // Setup placeholder image
        profileImageView.image = KMAUIConstants.shared.profileTabIcon.withRenderingMode(.alwaysTemplate)
        // Load profile image
        if let url = URL(string: citizen.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
    }
}
