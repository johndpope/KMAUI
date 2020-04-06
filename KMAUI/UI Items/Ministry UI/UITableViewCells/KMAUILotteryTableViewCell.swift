//
//  KMAUILotteryTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotteryTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet public weak var isActiveImageView: UIImageView!
    @IBOutlet public weak var lotteryNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var subLandsLabel: UILabel!
    @IBOutlet public weak var subLandsCountLabel: UILabel!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var statusViewWidth: NSLayoutConstraint! // default: 7
    @IBOutlet public weak var statusViewRight: NSLayoutConstraint! // default: 6
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public var type = "lottery"
    public var citizen = KMAPerson()
    public var subLand = KMAUISubLandStruct()
    public var lottery = KMAUILandPlanStruct()
    public var isFirst = false
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
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
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
        
        if lottery.lotteryCompleted {
            statusLabel.text = "Completed"
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else {
            statusLabel.text = "In progress"
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        }
        
        statusView.alpha = 1
        statusViewWidth.constant = 7
        statusViewRight.constant = 6
        
        statusLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        statusLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        statusLabel.backgroundColor = UIColor.clear
    }
    
    public func setupSubLand() {
        statusLabel.text = "   " + subLand.subLandType + "   "
        lotteryNameLabel.text = "Land ID \(subLand.subLandId)"
        subLandsLabel.text = "\(subLand.regionName) Region"
        subLandsCountLabel.text = ""
        
        if subLand.regionName.isEmpty {
            subLandsLabel.text = "Region name"
        }
        
        statusView.alpha = 0
        statusViewWidth.constant = 0
        statusViewRight.constant = 0
        
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        statusLabel.textColor = KMAUIUtilities.shared.getTextColor(subLandType: subLand.subLandType)
        statusLabel.backgroundColor = KMAUIUtilities.shared.getColor(subLandType: subLand.subLandType)
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
    }
}
