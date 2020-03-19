//
//  KMAUICitizenInfoTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUICitizenInfoTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var citizenView: UIView!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteryIdLabel: UILabel!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var queueLabel: UILabel!
    @IBOutlet weak var genderLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var birthdayLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var addressLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public var citizen = KMAPerson() {
        didSet {
            setupCell()
        }
    }
    
    // MARK: - Variables
    public static let id = "KMAUICitizenInfoTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 24
        
        // Profile image
        profileImageView.layer.cornerRadius = 33
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreenProgressColor.cgColor
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor.withAlphaComponent(0.5)
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        profileImageView.clipsToBounds = true
        
        // Full name labe
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        
        // Lottery id
        lotteryIdLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        
        // Queue label
        queueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        queueLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Setup full name
        nameLabel.text = citizen.fullName
        // Setup lottery id
        lotteryIdLabel.text = "Lottery ID – \(citizen.lotteryObjectId)"
        // Setup placeholder image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        // Load profile image
        if let url = URL(string: citizen.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
        // Queue
        queueLabel.text = "Verified user"
        // Gender
        genderLabel.text = citizen.gender
        // Birthday
        birthdayLabel.text = KMAUIUtilities.shared.formatStringShort(date: Date(timeIntervalSince1970: citizen.birthday))
        // Address
        if citizen.formattedAddress.isEmpty {
            addressLabel.text = "No address"
        } else {
            addressLabel.text = citizen.formattedAddress
        }
    }
}
