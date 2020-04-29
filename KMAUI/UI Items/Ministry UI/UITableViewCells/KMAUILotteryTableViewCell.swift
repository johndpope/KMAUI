//
//  KMAUILotteryTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUILotteryTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var bgViewRight: NSLayoutConstraint!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var bgViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var isActiveImageView: UIImageView!
    @IBOutlet public weak var lotteryNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteryNameLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var subLandsLabel: UILabel!
    @IBOutlet public weak var subLandsLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var subLandsCountLabel: UILabel!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var statusViewWidth: NSLayoutConstraint! // default: 7
    @IBOutlet public weak var statusViewRight: NSLayoutConstraint! // default: 6
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var statusLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var statusLabelBottom: NSLayoutConstraint!
    @IBOutlet public weak var profileImageView: UIImageView!
    
    // MARK: - Variables
    public var type = "lottery"
    public var citizen = KMAPerson()
    public var subLand = KMAUISubLandStruct()
    public var lottery = KMAUILandPlanStruct()
    public var isFirst = false
    public var highlightActive = false
    public var noBg = false
    public var isActive = false {
        didSet {
            setupCell()
        }
    }

    // MARK: - Variables
    public static let id = "KMAUILotteryTableViewCell"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // bgView shadow
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 4
        
        // Fonts
        lotteryNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        subLandsLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        subLandsCountLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // isActive imageView
        isActiveImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        isActiveImageView.layer.cornerRadius = 4
        isActiveImageView.clipsToBounds = true
        
        // Default state - disabled
        isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
        // Status view
        statusView.layer.cornerRadius = 3.5
        statusView.clipsToBounds = true
        
        // Set the profileImageView
        profileImageView.tintColor = KMAUIConstants.shared.KMATextGrayColor.withAlphaComponent(0.5)
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.kf.indicatorType = .activity
        profileImageView.clipsToBounds = true
        
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
        if noBg {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = UIColor.clear
            
            if highlight {
                bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            } else {
                bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            }
        } else if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            
            if highlightActive {
                isActiveImageView.tintColor = UIColor.white
                isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
            }
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            
            if highlightActive {
                isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
                isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
            }
        }
    }
    
    public func setupCell() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 8
        } else {
            bgViewTop.constant = 0
        }
        
        // Is active status
        if isActive {
            isActiveImageView.tintColor = UIColor.white
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        } else {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
        
        if type == "lottery" {
            setupLottery()
        } else if type == "subLand" {
            setupSubLand()
        } else if type == "citizen" {
            setupCitizen()
        }
    }
    
    public func setupLottery() {
        // Basic details
        lotteryNameLabel.text = lottery.landName
        subLandsLabel.text = "Sub Lands"
        subLandsCountLabel.text = "\(lottery.totalCount)"
        
        // Lottery status
        statusLabel.text = lottery.lotteryStatus.rawValue
        statusView.backgroundColor = KMAUIUtilities.shared.lotteryColor(status: lottery.lotteryStatus)
        
        statusView.alpha = 1
        statusViewWidth.constant = 7
        statusViewRight.constant = 6
        
        statusLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        statusLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        statusLabel.backgroundColor = UIColor.clear
        statusLabel.layer.borderWidth = 0
        
        lotteryNameLabelLeft.constant = 16
        subLandsLabelLeft.constant = 16
        
        profileImageView.alpha = 0
    }
    
    public func setupSubLand() {
        statusLabel.text = "     " + subLand.subLandType + "     "
        lotteryNameLabel.text = "Land ID \(subLand.subLandId)"
        subLandsLabel.text = "Land Plan \(subLand.landPlanName)"
        subLandsCountLabel.text = ""
        
        statusView.alpha = 0
        statusViewWidth.constant = 0
        statusViewRight.constant = 0
        
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        statusLabel.textColor = KMAUIUtilities.shared.getTextColor(subLandType: subLand.subLandType)
        statusLabel.backgroundColor = KMAUIUtilities.shared.getColor(subLandType: subLand.subLandType)
        statusLabel.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        statusLabel.layer.borderWidth = 1
        statusLabel.layer.cornerRadius = 23 / 2
        statusLabel.clipsToBounds = true
        
        lotteryNameLabelLeft.constant = 16
        subLandsLabelLeft.constant = 16
        
        profileImageView.alpha = 0
        
        if noBg {
            backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            bgView.layer.shadowRadius = 0
            bgViewLeft.constant = 0
            bgViewRight.constant = 0
            bgViewTop.constant = 0
            bgViewBottom.constant = 0
            bgView.layer.cornerRadius = 0
            statusLabelHeight.constant = 0
            statusLabelBottom.constant = 0
        }
    }
    
    public func setupCitizen() {
        statusLabel.text = "Verified user"
        lotteryNameLabel.text = citizen.fullName
        subLandsLabel.text = "National ID: \(citizen.objectId.uppercased())"
        subLandsCountLabel.text = ""
        
        statusView.alpha = 0
        statusViewWidth.constant = 0
        statusViewRight.constant = 0
        
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        statusLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        statusLabel.backgroundColor = UIColor.clear
        statusLabel.layer.borderWidth = 0
        
        lotteryNameLabelLeft.constant = 72
        subLandsLabelLeft.constant = 72
        
        profileImageView.alpha = 1
        // Setup placeholder image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        // Load profile image
        if let url = URL(string: citizen.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
    }
}

