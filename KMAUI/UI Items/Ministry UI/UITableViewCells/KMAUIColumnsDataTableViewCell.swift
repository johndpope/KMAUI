//
//  KMAUIColumnsDataTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 30.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIColumnsDataTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var headerStackView: UIStackView!
    @IBOutlet public weak var detailsStackView: UIStackView!
    
    
    // MARK: - Variables
    public static let id = "KMAUIIncomeChartTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
