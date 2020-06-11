//
//  KMAUIRowDetailTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 02.06.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRowDetailTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var bgViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIRowDetailTableViewCell"
    public var isFirst = false
    public var info = ""
    public var title = "" {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 4
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // No default selection
        selectionStyle = .none
    }

    public func setupCell() {
        if isFirst {
            bgViewTop.constant = 8
        } else {
            bgViewTop.constant = 0
        }
        
        titleLabel.text = title
        infoLabel.text = info
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
}
