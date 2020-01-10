//
//  KMAPersonDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 10.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAPersonDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var itemNameLabel: KMAUITextLabel!
    @IBOutlet public weak var itemValueLabel: KMAUITitleLabel!
    
    // MARK: - Variables
    public var type = ""
    public var person = KMAPerson()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Setup cell
     */
    
    public func setupCell() {
        
    }
}
