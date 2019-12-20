//
//  KMAUIZooplaPricesCompareTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 20.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZooplaPricesCompareTableViewCell: UITableViewCell {
    // MARK: - Variables
    public var rentValue = 0
    public var saleValue = 0
    public var averageRentValue = 0
    public var averageSaleValue = 0
    
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
        
    }
}
