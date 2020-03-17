//
//  KMAUISubLandPercentTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 12.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISubLandPercentTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var bgViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var colorView: UIView!
    @IBOutlet public weak var colorViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var valueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var percentLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var percentLabelRight: NSLayoutConstraint!
    @IBOutlet public weak var circleView: UIView!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandPercentTableViewCell"
    public var sideOffsets = false // show the bgView if true
    public var isLast = false // make round corners if last
    public var rule = KMAUILotteryRule() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup circelView
        circleView.layer.cornerRadius = 2
        circleView.clipsToBounds = true
        
        // Setup colorView
        colorView.setRoundCorners(radius: 4)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Setup values
        nameLabel.text = rule.name
        valueLabel.text = rule.value
        // Setup the colorView
        if rule.name.contains("services") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandServicesColor
        } else if rule.name.contains("commercial") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandCommercialColor
        } else if rule.name.contains("sale") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandSaleColor
        } else if rule.name.contains("lottery") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandLotteryColor
        }
        // Setup side offsets
        if sideOffsets {
            colorViewLeft.constant = 40
            percentLabelRight.constant = 40
                contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            bgView.alpha = 1
            
            if isLast {
                bgViewHeight.constant = 68
                bgView.layer.cornerRadius = 8
                bgView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            } else {
                bgViewHeight.constant = 44
                bgView.layer.cornerRadius = 0
            }
            
            bgView.clipsToBounds = true
        } else {
            colorViewLeft.constant = 30
            percentLabelRight.constant = 30
            contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            bgView.alpha = 0
            bgViewHeight.constant = 44
            bgView.layer.cornerRadius = 0
            bgView.clipsToBounds = true
        }
    }
}
