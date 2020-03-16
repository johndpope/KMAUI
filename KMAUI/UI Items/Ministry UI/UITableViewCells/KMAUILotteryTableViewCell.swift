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
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
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
        
        // Basic details
        lotteryNameLabel.text = lottery.landName
        subLandsLabel.text = "Sub Lands"
        subLandsCountLabel.text = "\(lottery.totalCount)"
        
        if lottery.lotteryCompleted {
            statusLabel.text = "Completed"
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        } else {
            statusLabel.text = "In progress"
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        }
        
        // Is active status
        if isActive {
            isActiveImageView.tintColor = UIColor.white
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor //KMAUIConstants.shared.KMATurquoiseColor
        } else {
            isActiveImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            isActiveImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
}
