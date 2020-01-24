//
//  KMAUIDataBlockTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 24.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDataBlockTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemHandleLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var lastUpdatedLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var stackView: UIStackView!
    
    // MARK: - Variables
    var dataItem = KMAUIDataItem() {
        didSet {
            setupCell()
        }
    }
    
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
