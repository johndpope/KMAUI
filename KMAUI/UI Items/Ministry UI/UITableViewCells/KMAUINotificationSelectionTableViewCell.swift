//
//  KMAUINotificationSelectionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 01.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUINotificationSelectionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var isActiveImageView: UIImageView!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUINotificationSelectionTableViewCell"
    public var isFirst = false
    public var notification = KMANotificationStruct()
    public var isActive = false {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // Status view
        statusView.layer.cornerRadius = 4
        statusView.clipsToBounds = true
        
        // isActive imageView
        isActiveImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        isActiveImageView.layer.cornerRadius = 4
        isActiveImageView.clipsToBounds = true
        
        // Default state - disabled
        isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        isActiveImageView.contentMode = .center
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Date label
        dateLabel.textColor = KMAUIConstants.shared.KMAUIGreyTextColor
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        // Extra space for shadow for the first cell
        if isFirst {
            bgViewTop.constant = 8
        } else {
            bgViewTop.constant = 0
        }
        
        // Setup details
        titleLabel.text = notification.title
        titleLabel.setLineSpacing(lineSpacing: 1.1, lineHeightMultiple: 1.1, alignment: .left)
        infoLabel.text = notification.message
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        dateLabel.text = KMAUIUtilities.shared.formatReadableDate(date: notification.createdAt)
        
        if notification.read {
            // Status view
            statusView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
            // Status label
            statusLabel.text = "Viewed"
        } else {
            // Status view
            statusView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            // Status label
            statusLabel.text = "Unread"
        }
     
        // Is active
        if isActive {
            isActiveImageView.tintColor = UIColor.white
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUITextColor
        } else {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    // MARK: - Cell selection
 
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
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
}
