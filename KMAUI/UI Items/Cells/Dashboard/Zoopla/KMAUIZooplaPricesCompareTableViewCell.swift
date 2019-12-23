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
    @IBOutlet public weak var priceLabel: KMAUITitleLabel!
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
        if rentValue > 0, averageRentValue > 0 {
            let value = getPercent(value1: rentValue, value2: averageRentValue)
            
            if value > 0 {
                priceLabel.text = "\(getPercent(value1: rentValue, value2: averageRentValue))% more expensive then an average rental price in the area."
                priceImageView.image = KMAUIConstants.shared.highPrice.withRenderingMode(.alwaysTemplate)
            } else {
                priceLabel.text = "\(abs(getPercent(value1: averageRentValue, value2: rentValue)))% cheaper then an average rental price in the area."
                priceImageView.image = KMAUIConstants.shared.lowPrice.withRenderingMode(.alwaysTemplate)
            }
            
//            if rentValue > averageRentValue {
//                priceLabel.text = "\(getPercent(value1: rentValue, value2: averageRentValue))% more expensive then an average rental price in the area."
//                priceImageView.image = KMAUIConstants.shared.highPrice.withRenderingMode(.alwaysTemplate)
//            } else {
//                priceLabel.text = "\(getPercent(value1: averageRentValue, value2: rentValue))% cheaper then an average rental price in the area."
//                priceImageView.image = KMAUIConstants.shared.lowPrice.withRenderingMode(.alwaysTemplate)
//            }
            
            priceImageView.alpha = 1
        } else if saleValue > 0, averageSaleValue > 0 {
            let value = getPercent(value1: saleValue, value2: averageSaleValue)
            
            if value > 0 {
                priceLabel.text = "\(getPercent(value1: saleValue, value2: averageSaleValue))% more expensive then an average sale price in the area."
                priceImageView.image = KMAUIConstants.shared.highPrice.withRenderingMode(.alwaysTemplate)
            } else {
                priceLabel.text = "\(abs(getPercent(value1: averageSaleValue, value2: saleValue)))% cheaper then an average sale price in the area."
                priceImageView.image = KMAUIConstants.shared.lowPrice.withRenderingMode(.alwaysTemplate)
            }
            
//            if saleValue > averageSaleValue {
//                priceLabel.text = "\(getPercent(value1: saleValue, value2: averageSaleValue))% more expensive then an average sale price in the area."
//                priceImageView.image = KMAUIConstants.shared.highPrice.withRenderingMode(.alwaysTemplate)
//            } else {
//                priceLabel.text = "\(getPercent(value1: averageSaleValue, value2: saleValue))% cheaper then an average sale price in the area."
//                priceImageView.image = KMAUIConstants.shared.lowPrice.withRenderingMode(.alwaysTemplate)
//            }
            
            priceImageView.alpha = 1
        } else {
            priceLabel.text = "No price data available."
            priceImageView.alpha = 0
        }
    }
    
    public func getPercent(value1: Int, value2: Int) -> Double {
        
        let percent = Double(Int(Double(Int((Double(value1 - value2) / Double(value2)) * 10000)))) / 100
        
//        let percent = Double(Int(Double(Int(((Double(value1) / Double(value2)) - 1) * 10000)))) / 100
        
        return percent
    }
}
