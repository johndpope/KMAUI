//
//  KMAUIQueueCitizenTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 30.04.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIQueueCitizenTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var isActiveImageView: UIImageView!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIQueueCitizenTableViewCell"
    public var isFirst = false
    public var isActive = false
    public var citizen = KMAPerson() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // Bg color
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        // Profile image view
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor.withAlphaComponent(0.5)
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        profileImageView.clipsToBounds = true
        
        // isActive imageView
        isActiveImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        isActiveImageView.layer.cornerRadius = 4
        isActiveImageView.clipsToBounds = true
        isActiveImageView.contentMode = .center
        
        // Default state - disabled
        isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // No standard selection required
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
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            isActiveImageView.tintColor = UIColor.white
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            // If active - no need to unhighlight
            checkActive()
        }
    }
    
    public func checkActive() {
        if isActive {
            isActiveImageView.tintColor = UIColor.white
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        } else {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    public func setupCell() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 8
        } else {
            bgViewTop.constant = 0
        }
        
        // If is active
        checkActive()
        
        // Name
        titleLabel.text = citizen.fullName
        
        // National ID / objectId
        infoLabel.text = "National ID: \(citizen.objectId.uppercased())"
        
        // Profile image view
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        // Load profile image
        if let url = URL(string: citizen.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
    }
}
