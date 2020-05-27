//
//  KMAUIJudgeTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 22.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIJudgeTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var caseNumberLabel: UILabel!
    @IBOutlet public weak var dateLabel: UILabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUIJudgeTableViewCell"
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background view
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 7)
        bgView.layer.shadowRadius = 8
        
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Case number
        caseNumberLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Date
        dateLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)

        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        // Name label
        nameLabel.text = landCase.judge.fullName
        // Title label
        titleLabel.text = "Judge"
        // Case number label
        caseNumberLabel.text = "Cases –"
        // Date label
        dateLabel.text = "\(landCase.judge.casesCount)"
        // Judge image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = KMAUIConstants.shared.KMAUILightBorderColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = KMAUIConstants.shared.KMAUILightBorderColor.cgColor
        profileImageView.kf.indicatorType = .activity
        profileImageView.contentMode = .scaleAspectFill
        
        if !landCase.judge.profileImage.isEmpty, let url = URL(string: landCase.judge.profileImage) {
            profileImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.profileImageView.image = value.image
                    self.profileImageView.layer.borderWidth = 0
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
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
        if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        }
    }
}
