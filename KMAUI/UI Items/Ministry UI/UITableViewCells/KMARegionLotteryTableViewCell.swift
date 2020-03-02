//
//  KMARegionLotteryTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 02.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMARegionLotteryTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var regionNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var subLandsCountLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var subLandsCountLabelHeight: NSLayoutConstraint!
    @IBOutlet public weak var queueButton: KMAUIButtonFilled!
    @IBOutlet public weak var queueButtonWidth: NSLayoutConstraint!
    @IBOutlet public weak var queueButtonLeft: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMARegionLotteryTableViewCell"
    public var canJoin = false
    public var region = KMAMapAreaStruct()
    public var joined = false {
           didSet {
               setupCell()
           }
       }
    public var queueCallback: ((Bool) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Cell background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        // Border for queueButton
        queueButton.layer.borderColor = KMAUIConstants.shared.KMABrightBlueColor.cgColor
        queueButton.layer.borderWidth = KMAUIConstants.shared.KMABorderWidthRegular
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Setup cell
    
    public func setupCell() {
        regionNameLabel.text = region.nameE
        
        if region.landPlans.isEmpty {
            subLandsCountLabel.text = "Queue: \(region.lotteryMembersCount)"
        } else {
            subLandsCountLabel.text = "Land Plans: \(region.landPlans.count), queue: \(region.lotteryMembersCount)"
        }
        
        if canJoin {
            queueButton.alpha = 1
            queueButtonWidth.constant = 120
            queueButtonLeft.constant = 16
        } else {
            queueButton.alpha = 0
            queueButtonWidth.constant = 0
            queueButtonLeft.constant = 0
        }
        
        if joined {
            queueButton.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            queueButton.setTitleColor(KMAUIConstants.shared.KMABrightBlueColor, for: .normal)
            queueButton.setTitle("Lottery joined", for: .normal)
        } else {
            queueButton.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
            queueButton.setTitleColor(UIColor.white, for: .normal)
            queueButton.setTitle("Join lottery", for: .normal)
        }
    }

    // MARK: - IBActions
    
    @IBAction public func joinQueueButtonPressed(_ sender: Any) {
        queueCallback?(true)
    }
}
