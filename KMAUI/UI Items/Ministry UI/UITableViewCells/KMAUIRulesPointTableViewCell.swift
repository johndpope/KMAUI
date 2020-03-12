//
//  KMAUIRulesPointTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRulesPointTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var valueLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIRulesPointTableViewCell"
    public var rule = KMAUILotteryRule() {
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
        nameLabel.text = rule.name
        valueLabel.text = rule.value
    }
}
