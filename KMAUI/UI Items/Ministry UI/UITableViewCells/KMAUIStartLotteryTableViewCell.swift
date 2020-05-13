//
//  KMAUIStartLotteryTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 24.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIStartLotteryTableViewCell: UITableViewCell {
    @IBOutlet public weak var lotteryButton: UIButton!
    // MARK: - Variables
    public static let id = "KMAUIStartLotteryTableViewCell"
    public var callback: ((KMAUILandPlanStruct) -> Void)?
    public var lottery = KMAUILandPlanStruct()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Lottery button
        lotteryButton.layer.cornerRadius = 8
        lotteryButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction public func lotteryButtonPressed(_ sender: Any) {
        KMAUIParse.shared.startLottery(lottery: lottery) { (updatedLottery) in
            self.lottery = updatedLottery
            self.callback?(self.lottery)
        }
    }
}
