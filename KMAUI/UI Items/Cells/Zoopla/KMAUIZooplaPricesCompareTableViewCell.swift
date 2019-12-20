//
//  KMAUIZooplaPricesCompareTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 20.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZooplaPricesCompareTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var priceLabel: KMAUITextLabel!
    @IBOutlet public weak var priceImageView: UIImageView!
    
    // MARK: - Variables
    public var rentValue = 0
    public var saleValue = 0
    public var averageRentValue = 0
    public var averageSaleValue = 0
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the price image view
        priceImageView.tintColor = KMAUIConstants.shared.KMATextColor
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if rentValue > 0 {
            if rentValue > averageRentValue {
                let percent = Double(Int(((Double(rentValue) / Double(averageRentValue)) - 1) * 1000)) / 100
                priceLabel.text = "\(percent)% more expensive then an average rental price in the area."
                priceImageView.image = KMAUIConstants.shared.highPrice.withRenderingMode(.alwaysTemplate)
            } else {
                let percent = Double(Int(((Double(averageRentValue) / Double(rentValue)) - 1) * 1000)) / 100
                priceLabel.text = "\(percent)% cheaper then an average rental price in the area."
                priceImageView.image = KMAUIConstants.shared.lowPrice.withRenderingMode(.alwaysTemplate)
            }
        } else if saleValue > 0 {
            if saleValue > averageSaleValue {
                let percent = Double(Int(((Double(saleValue) / Double(averageSaleValue)) - 1) * 1000)) / 100
                priceLabel.text = "\(percent)% more expensive then an average sale price in the area."
                priceImageView.image = KMAUIConstants.shared.highPrice.withRenderingMode(.alwaysTemplate)
            } else {
                let percent = Double(Int(((Double(averageSaleValue) / Double(saleValue)) - 1) * 1000)) / 100
                priceLabel.text = "\(percent)% cheaper then an average sale price in the area."
                priceImageView.image = KMAUIConstants.shared.lowPrice.withRenderingMode(.alwaysTemplate)
            }
        }
    }
}
