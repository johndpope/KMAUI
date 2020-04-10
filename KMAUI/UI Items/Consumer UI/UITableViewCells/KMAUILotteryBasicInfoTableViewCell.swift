//
//  KMAUILotteryBasicInfoTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 10.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotteryBasicInfoTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var subLandsLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var subLandsCountLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUILotteryBasicInfoTableViewCell"
    public var lottery = KMAUILandPlanStruct() {
        didSet {
            setupCell()
        }
    }
    public var canHighlight = false

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 4
        
        // Status label
        statusLabel.layer.cornerRadius = 6
        statusLabel.clipsToBounds = true
        statusLabel.textColor = UIColor.white
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(24)
        
        // Sub lands label
        subLandsLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Sub lands count label
        subLandsCountLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // No standard selection requried
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
        if highlight, canHighlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
    
    public func setupCell() {
        // Lottery status
        if lottery.lotteryCompleted {
            statusLabel.text = "     completed     "
            statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else {
            statusLabel.text = "     in progress     "
            statusLabel.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        }
        
        // Lottery name
        titleLabel.text = lottery.landName
        
        // Sub lands count
        subLandsCountLabel.text = "\(lottery.subLandArray.count)"
    }
}
