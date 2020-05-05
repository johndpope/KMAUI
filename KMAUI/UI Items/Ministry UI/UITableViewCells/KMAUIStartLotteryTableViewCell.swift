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
        let lotteryAlert = UIAlertController(title: "Start the Lottery", message: "Are you sure you'd like to start the lottery?\n\nThis will run a random algorithm to give the Sub Land items to the Citizens.", preferredStyle: .alert)
        lotteryAlert.view.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        
        lotteryAlert.addAction(UIAlertAction(title: "Start", style: .default, handler: { (action) in
            self.startLottery()
        }))
        
        lotteryAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in }))
        
        KMAUIUtilities.shared.displayAlert(viewController: lotteryAlert)
    }
    
    func startLottery() {
        if lottery.lotterySubLandArray.isEmpty {
            KMAUIUtilities.shared.globalAlert(title: "Warning", message: "This lottery has no Sub Land items to assign to Citizens.") { (done) in }
            return
        }
        
        if lottery.queueArray.isEmpty {
            KMAUIUtilities.shared.globalAlert(title: "Warning", message: "This lottery has no Citizens to assign the Sub Land items to.") { (done) in }
            return
        }
        
        // Update the queue list
        KMAUIParse.shared.getQueue(regionId: lottery.regionId) { (citizenQueue) in
            self.lottery.queueArray = citizenQueue
            self.lottery.queueDisplay = citizenQueue
            self.lottery.queueCount = citizenQueue.count
            self.lottery.setupResultArray()
            self.lottery.queueLoaded = true
            
            print("Getting the latest queue: \(self.lottery.queueArray.count)")
            
            KMAUIParse.shared.startLottery(landPlan: lottery) { (landPlanUpdated) in
                // Get the lottery results data
                KMAUIParse.shared.getLotteryResults(landPlan: self.lottery) { (planUpdated) in
                    self.lottery = planUpdated
                    self.lottery.lotteryStatus = landPlanUpdated.lotteryStatus
                    self.lottery.resultLoaded = true
                    self.callback?(self.lottery)
                }
            }
        }        
    }
}
