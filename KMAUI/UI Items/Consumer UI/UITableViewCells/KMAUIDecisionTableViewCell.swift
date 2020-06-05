//
//  KMAUIDecisionTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 04.06.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import QuickLook
import Kingfisher

public class KMAUIDecisionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var commentLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public var type = ""
    public static let id = "KMAUIDecisionTableViewCell"
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupCell()
        }
    }
    
    override public  func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 4
        
        // Status label
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // Comment label
        commentLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        
        // Setup the right arrow
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
//        if highlight {
//            bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
//            rightArrowImageView.tintColor = UIColor.white
//            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
//        } else {
//            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
//            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
//            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
//        }
    }
    
    public func setupCell() {
        var status = ""
        var comment = ""
        
        if type == "court" {
            status = landCase.courtStatus
            comment = landCase.judgeComment
        } else if type == "department" {
            status = landCase.departmentDecision
            comment = landCase.departmentComment
        }
        
        if status.lowercased() == "approved" {
            statusLabel.text = "Approvement"
        } else {
            statusLabel.text = "Rejection"
        }
        
        commentLabel.text = comment
        commentLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
    }
}
