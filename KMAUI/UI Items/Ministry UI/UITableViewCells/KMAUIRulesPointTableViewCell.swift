//
//  KMAUIRulesPointTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRulesPointTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var nameLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var nameLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var valueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var valueLabelRight: NSLayoutConstraint!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public weak var lineViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var lineViewRight: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUIRulesPointTableViewCell"
    public var sideOffsets = true
    public var extraHeight = false
    public var subLandDetails = false
    public var rule = KMAUILotteryRule() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Setup point values
        nameLabel.text = rule.name
        valueLabel.text = rule.value
        valueLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        if subLandDetails {
            nameLabelHeight.constant = 44
            
            if extraHeight { // For the Sub land details for the Consumer app
                nameLabelHeight.constant = 54
            }
            
            nameLabelLeft.constant = 20
            valueLabelRight.constant = 20
            lineViewLeft.constant = 20
            lineViewRight.constant = 20
            contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        } else {
            // Setup side offsets
            if sideOffsets {
                nameLabelLeft.constant = 40
                valueLabelRight.constant = 40
                lineViewLeft.constant = 40
                lineViewRight.constant = 40
                contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
                bgView.alpha = 1
            } else {
                nameLabelLeft.constant = 30
                valueLabelRight.constant = 30
                lineViewLeft.constant = 30
                lineViewRight.constant = 30
                contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
                bgView.alpha = 0
            }
        }
    }
}
