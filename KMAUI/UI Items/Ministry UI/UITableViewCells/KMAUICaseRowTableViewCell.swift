//
//  KMAUICaseRowTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 01.06.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUICaseRowTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var bgViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var caseLabel: UILabel!
    @IBOutlet public weak var attachLabel: UILabel!
    @IBOutlet public weak var landIdLabel: UILabel!
    @IBOutlet public weak var citizenLabel: UILabel!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var attachmentButton: UIButton!
    @IBOutlet public weak var arrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUICaseRowTableViewCell"
    public var cellType = "regular"
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Bg View
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 16
        
        // Case label
        caseLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Land id label
        landIdLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Citizen label
        citizenLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Attach label
        attachLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Divide line view
        divideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Arrow image view
        arrowImageView.contentMode = .center
        arrowImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // Attachments button
        attachmentButton.layer.cornerRadius = 6
        attachmentButton.clipsToBounds = true
        attachmentButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        attachmentButton.setImage(KMAUIConstants.shared.attachmentIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        attachmentButton.tintColor = KMAUIConstants.shared.KMAUITextColor
        attachmentButton.isUserInteractionEnabled = false
        
        // No standard selection
        selectionStyle = .none
    }
    
    public func setupCell() {
        // Show divide line
        divideLineView.alpha = 1
        
        // Regular fonts
        caseLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        landIdLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        citizenLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        attachLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        // Visible items
        attachmentButton.alpha = 1
        arrowImageView.alpha = 1
        attachLabel.alpha = 0
        
        if cellType == "first" {
            bgViewTop.constant = 16
            bgViewBottom.constant = 0
            bgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            bgView.layer.cornerRadius = 8
            // Titles
            caseLabel.text = "Case"
            landIdLabel.text = "Land ID"
            citizenLabel.text = "Citizen"
            attachLabel.text = "Attach"
            // Bold fonts
            caseLabel.font = KMAUIConstants.shared.KMAUIBoldFont
            landIdLabel.font = KMAUIConstants.shared.KMAUIBoldFont
            citizenLabel.font = KMAUIConstants.shared.KMAUIBoldFont
            attachLabel.font = KMAUIConstants.shared.KMAUIBoldFont
            // Update visible items
            attachmentButton.alpha = 0
            arrowImageView.alpha = 0
            attachLabel.alpha = 1
        } else if cellType == "last" {
            bgViewTop.constant = 0
            bgViewBottom.constant = 16
            bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            bgView.layer.cornerRadius = 8
            // Hide divide line
            divideLineView.alpha = 0
        } else {
            bgViewTop.constant = 0
            bgViewBottom.constant = 0
            bgView.layer.cornerRadius = 0
        }
        
        if !landCase.objectId.isEmpty {
            caseLabel.text = "#\(landCase.caseNumber)"
            landIdLabel.text = "ID \(landCase.subLand.subLandIndex)"
            citizenLabel.text = landCase.citizen.fullName
        }
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
        if highlight, cellType != "first" {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
    
    @IBAction public func attachmentButtonPressed(_ sender: Any) {
        print("Attachment button pressed.")
    }
}
