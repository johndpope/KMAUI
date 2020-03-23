//
//  KMAUILotteryResultTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 23.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotteryResultTableViewCell: UITableViewCell {
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var queueIndexLabel: UILabel!
    @IBOutlet public weak var lotteryIdLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var subLandIdLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var addressLabel: KMAUIRegularTextLabel!
    // MARK: - Variables
    public static let id = "KMAUILotteryResultTableViewCell"
    
    // MARK: - Variables
    public var citizenIndex = 0
    public var citizen = KMAPerson()
    public var subLand = KMAUISubLandStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the profileImageView
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor.withAlphaComponent(0.5)
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        profileImageView.clipsToBounds = true
        
        // Right arrow image view
        KMAUIUtilities.shared.setupArrow(imageView: rightArrowImageView)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Citizen index
        queueIndexLabel.text = "\(citizenIndex)"
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
        // Sub land id
        subLandIdLabel.text = "Sub Land \(subLand.subLandId)"
        // Address
        addressLabel.text = "Region name"
    }
}
