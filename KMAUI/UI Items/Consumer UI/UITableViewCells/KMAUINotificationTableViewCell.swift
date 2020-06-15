//
//  KMAUINotificationTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 23.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUINotificationTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUINotificationTableViewCell"
    public var isFirst = false
    public var notification = KMANotificationStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 6
        
        // Status view
        statusView.layer.cornerRadius = 4
        statusView.clipsToBounds = true
        statusView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
        
        // Date label
        dateLabel.textColor = KMAUIConstants.shared.KMAUIGreyTextColor
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // No standard selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        // Extra space for shadow for the first cell
        if isFirst {
            bgViewTop.constant = 8
        } else {
            bgViewTop.constant = 0
        }
        
        titleLabel.text = notification.title
        infoLabel.text = notification.message
        
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
        
        dateLabel.text = KMAUIUtilities.shared.formatReadableDate(date: notification.createdAt)
        
        titleLabel.setLineSpacing(lineSpacing: 1.1, lineHeightMultiple: 1.1, alignment: .left)
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
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
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
}
