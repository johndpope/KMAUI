//
//  KMAUILotterySubLandTypesTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 12.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILotterySubLandTypesTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    public static let id = "KMAUILotterySubLandTypesTableViewCell"

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
