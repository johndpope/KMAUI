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
    @IBOutlet public weak var colorView: UIView!
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var valueLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandPercentTableViewCell"
    public var rule = KMAUILotteryRule() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
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
        nameLabel.text = rule.name
        valueLabel.text = rule.value
        
        if rule.name.contains("services") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandServicesColor
        } else if rule.name.contains("commercial") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandCommercialColor
        } else if rule.name.contains("sale") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandSaleColor
        } else if rule.name.contains("lottery") {
            colorView.backgroundColor = KMAUIConstants.shared.KMAUISubLandLotteryColor
        }
    }
}
