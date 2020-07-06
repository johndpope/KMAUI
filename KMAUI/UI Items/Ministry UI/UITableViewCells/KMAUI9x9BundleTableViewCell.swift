//
//  KMAUI9x9BundleTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 03.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUI9x9BundleTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var infoLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUI9x9BundleTableViewCell"
    public var isFirst = false
    public var bundle = KMAUI9x9Bundle() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Logo image view
        logoImageView.layer.cornerRadius = 22
        logoImageView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyProgressColor.withAlphaComponent(0.5).cgColor
        logoImageView.clipsToBounds = true
        logoImageView.image = KMAUIConstants.shared.headerSubLandIcon.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = KMAUIConstants.shared.KMAUIGreyProgressColor
        logoImageView.contentMode = .center
        
        // Right arrow imageView
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
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
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUITextColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    public func setupCell() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 16
        } else {
            bgViewTop.constant = 0
        }
        
        // Name
        nameLabel.text = bundle.name
        
        // Info
        var infoText = bundle.description
        
        if !bundle.comment.isEmpty {
            if infoText.isEmpty {
                infoText = bundle.comment
            } else {
                infoText += "\n" + bundle.comment
            }
        }
               
        infoLabel.text = infoText
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        if infoText.isEmpty {
            infoLabelTop.constant = 0
        } else {
            infoLabelTop.constant = 8
        }
    }
}
