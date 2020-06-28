//
//  KMAUICasePointTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 16.06.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUICasePointTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUICasePointTableViewCell"
    public var isFirst = false
    public var title = "" {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 4
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Right arrow imageView
        rightArrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        if isFirst {
            bgViewTop.constant = 20
        } else {
            bgViewTop.constant = 0
        }
        
        titleLabel.text = title
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
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUITextColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
}
