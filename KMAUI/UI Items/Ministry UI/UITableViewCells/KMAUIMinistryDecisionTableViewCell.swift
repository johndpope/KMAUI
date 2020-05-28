//
//  KMAUIMinistryDecisionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 26.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIMinistryDecisionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var logoImageViewRight: NSLayoutConstraint!
    @IBOutlet public weak var logoImageViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    @IBOutlet public weak var statusLabel: UILabel!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var attachmentButton: UIButton!
    @IBOutlet public weak var divideLineView: UIView!
    
    // MARK: - Variables
    public static let id = "KMAUIMinistryDecisionTableViewCell"
    public var attachmentCallback: ((Bool) -> Void)?
    public var decision = KMAUIMinistryDecisionStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Description label
        descriptionLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Status view
        statusView.layer.cornerRadius = 4
        statusView.backgroundColor = KMAUIConstants.shared.KMAUIGreyProgressColor
        statusView.clipsToBounds = true
        
        // Status label
        statusLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        
        // Attachments button
        attachmentButton.layer.cornerRadius = 6
        attachmentButton.clipsToBounds = true
        attachmentButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        attachmentButton.setImage(KMAUIConstants.shared.attachmentIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        attachmentButton.tintColor = KMAUIConstants.shared.KMAUITextColor //UIColor.black
        
        // Divide line
        divideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        let ministry = decision.ministry
        
        // Ministry / Department name
        nameLabel.text = ministry.departmentName
        
        // Ministry logo
        if ministry.type == "department" {
            logoImageViewRight.constant = 0
            logoImageViewWidth.constant = 0
            logoImageView.alpha = 0
            // Department title
            descriptionLabel.text = "department"
        } else if ministry.type == "ministry", !ministry.departmentLogo.isEmpty, let logoURL = URL(string: ministry.departmentLogo) {
            logoImageViewRight.constant = 12
            logoImageViewWidth.constant = 44
            logoImageView.alpha = 1
            logoImageView.kf.indicatorType = .activity
            logoImageView.kf.setImage(with: logoURL)
            // Ministry short description
            descriptionLabel.text = ministry.shortDescription
        }

        // Status view
        if decision.ministryStatus == "approved" {
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if decision.ministryStatus == "rejected" {
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
        
        // Status label
        statusLabel.text = decision.ministryStatus.capitalized
    }
    
    @IBAction public func attachmentButtonPressed(_ sender: Any) {
        attachmentCallback?(true)
    }
}
