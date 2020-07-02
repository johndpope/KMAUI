//
//  KMAUIDepartmentTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIDepartmentTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteryIdLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    
    // MARK: - Variables
    public static let id = "KMAUIDepartmentTableViewCell"
    public var department = KMADepartmentStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        // Set the profileImageView
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor.withAlphaComponent(0.5)
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        profileImageView.clipsToBounds = true
        
        // Right arrow image view
        rightArrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
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
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            rightArrowImageView.tintColor = UIColor.white
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    public func setupCell() {
        // Setup name
        nameLabel.text = department.departmentName
        // Setup handle
        lotteryIdLabel.text = department.departmentHandle
        // Setup placeholder image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        // Load profile image
        if let url = URL(string: department.departmentLogo) {
            profileImageView.kf.setImage(with: url)
        }
    }
}
