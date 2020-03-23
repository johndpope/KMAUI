//
//  KMAUILotteryResultTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 23.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotteryResultTableViewCell: UITableViewCell {
    // MARK: - Variables
    public static let id = "KMAUILotteryResultTableViewCell"
    
    // MARK: - Variables
    var subLand = KMAUISubLandStruct()
    var citizen = KMAUIPerson()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
