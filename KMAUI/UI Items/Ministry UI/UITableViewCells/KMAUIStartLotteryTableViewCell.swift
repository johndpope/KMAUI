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
    public var isDepartment = false
    public var citizenDepartment = KMADepartmentStruct()
    public var lottery = KMAUILandPlanStruct() {
        didSet {
            setupCell()
        }
    }

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
        if isDepartment {
        if lottery.lotteryStatus == .approvedToStart {
            KMAUIParse.shared.startLottery(lottery: lottery) { (updatedLottery) in
                self.lottery = updatedLottery
                // Notify the Ministry about the new lottery created and submitted in the `On approvement` status
                KMAUIParse.shared.notifyMinistry(citizenDepartment: self.citizenDepartment, landPlanId: self.lottery.landPlanId, landPlanName: self.lottery.landName, regionId: self.lottery.regionId, regionName: self.lottery.regionName, lotteryStatus: "Finished")
                self.callback?(self.lottery)
            }
        } else if lottery.lotteryStatus == .rejected {
            KMAUIUtilities.shared.startLoading(title: "Updating...")
            
            KMAUIParse.shared.changeLotteryStatus(to: .onApprovement, for: lottery.landPlanId) { (success, error) in
                // Stop loading and update the UI
                KMAUIUtilities.shared.stopLoadingWith { (_) in
                    self.lottery.lotteryStatus = .onApprovement
                    self.setupCell()
                    self.callback?(self.lottery)
                }
                // Notify the Ministry about the new lottery created and submitted in the `On approvement` status
                KMAUIParse.shared.notifyMinistry(citizenDepartment: self.citizenDepartment, landPlanId: self.lottery.landPlanId, landPlanName: self.lottery.landName, regionId: self.lottery.regionId, regionName: self.lottery.regionName, lotteryStatus: "On approvement")
            }
        }
        } else {
            KMAUIUtilities.shared.globalAlert(title: "Warning", message: "Only a Department Admin can perform this action.") { (_) in }
        }
    }
    
    public func setupCell() {
        var dataSet = false
        if isDepartment {
            // Rejected lottery
            if lottery.lotteryStatus == .rejected {
                lotteryButton.setTitle("Transfer to \"on approvement\"", for: .normal)
                dataSet = true
            } else if lottery.lotteryStatus == .approvedToStart {
                lotteryButton.setTitle("Start the Lottery", for: .normal)
                dataSet = true
            }
        }
        
        if dataSet {
            lotteryButton.isUserInteractionEnabled = true
            lotteryButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
            lotteryButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            lotteryButton.isUserInteractionEnabled = false
            lotteryButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
            lotteryButton.setTitleColor(KMAUIUtilities.shared.lotteryColor(status: lottery.lotteryStatus), for: .normal)
            lotteryButton.setTitle(lottery.lotteryStatus.rawValue, for: .normal)
        }
    }
}
