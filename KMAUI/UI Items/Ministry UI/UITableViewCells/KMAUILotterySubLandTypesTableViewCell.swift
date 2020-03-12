//
//  KMAUILotterySubLandTypesTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 12.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotterySubLandTypesTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var servicesView: UIView!
    @IBOutlet public weak var servicesLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var commercialView: UIView!
    @IBOutlet public weak var commercialLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var saleView: UIView!
    @IBOutlet public weak var saleLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var lotteryView: UIView!
    @IBOutlet public weak var lotteryLabel: KMAUIRegularTextLabel!

    // MARK: - Variables
    public static let id = "KMAUILotterySubLandTypesTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Corners for views
        servicesView.setRoundCorners(radius: 4)
        commercialView.setRoundCorners(radius: 4)
        saleView.setRoundCorners(radius: 4)
        lotteryView.setRoundCorners(radius: 4)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
