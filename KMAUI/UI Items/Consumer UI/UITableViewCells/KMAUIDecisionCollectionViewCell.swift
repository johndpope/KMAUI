//
//  KMAUISubLandImageCollectionViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 16.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIDecisionCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUIDecisionCollectionViewCell"
    
    // MARK: - Variables
    public var decision = KMAUIMinistryDecisionStruct() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        
        // Status label
        statusLabel.layer.cornerRadius = 6
        statusLabel.clipsToBounds = true
        statusLabel.textColor = UIColor.white
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
    }

    public func setupCell() {
        // Not submitted yet
        statusLabel.text = decision.ministryStatus
        // in progress / approved / declined
        if decision.ministryStatus.lowercased() == "in progress" {
            statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        } else if decision.ministryStatus.lowercased() == "approved" {
            statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if decision.ministryStatus.lowercased() == "rejected" {
            statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
            statusLabel.text = "declined"
        }
        
        // Title
        titleLabel.text = decision.ministry.departmentName
        
        // Comment
        infoLabel.text = decision.comment
        
        // Add the spacing for the infoLabel
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
    }
}
