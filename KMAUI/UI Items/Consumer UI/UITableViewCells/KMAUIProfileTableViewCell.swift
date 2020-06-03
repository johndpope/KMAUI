//
//  KMAProfileTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 9/6/19.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

/// This cell represents the user info.

public class KMAUIProfileTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var usernameLabel: UILabel!
    @IBOutlet public weak var fullNameLabel: UILabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var rightArrowWidth: NSLayoutConstraint!
    @IBOutlet public weak var rightArrowRight: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUIProfileTableViewCell"
    public var citizenId = "" {
        didSet {
            setupCell()
        }
    }
    
    // MARK: - Cell methods
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 4
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // Setup profile image view
        profileImageView.tintColor = KMAUIConstants.shared.KMAUIGreyTextColor
        profileImageView.layer.cornerRadius = 27
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        // Setup usernameLabel
        usernameLabel.text = ""
        usernameLabel.textColor = KMAUIConstants.shared.KMABrightBlueColor
        usernameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        
        
        // Setup fullNameLabel
        fullNameLabel.text = ""
        fullNameLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        
        // Disable default selection animation
        selectionStyle = .none
        accessoryType = .none
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
            bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
            rightArrowImageView.tintColor = UIColor.white
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    public func setupCell() {
        // Setting the placeholder profileImageView
        if let profileIcon = UIImage(named: "profileImagePlaceholder")?.withRenderingMode(.alwaysTemplate) {
            profileImageView.image = profileIcon
        }
        
        // Get the citizen details
        if !citizenId.isEmpty {
            let citizenObject = KMACoreData.shared.getUserBy(objectId: citizenId)
            
            // Full name
            if let fullName = citizenObject.fullName {
                usernameLabel.text = "@" + fullName
            } else if let usernameValue = citizenObject.username {
                usernameLabel.text = usernameValue.formatUsername()
            }
            
            // Info details
            fullNameLabel.text = "Edit your account details"
            
            // Profile image
            if let profileImageString = citizenObject.profileImage, let url = URL(string: profileImageString) {
                profileImageView.kf.indicatorType = .activity
                profileImageView.kf.setImage(with: url)
            }
        }
        
    }
}
