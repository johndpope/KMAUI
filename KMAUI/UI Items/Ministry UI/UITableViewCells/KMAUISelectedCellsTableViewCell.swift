//
//  KMAUISelectedCellsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 30.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISelectedCellsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var valueLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIColumnsDataTableViewCell"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
