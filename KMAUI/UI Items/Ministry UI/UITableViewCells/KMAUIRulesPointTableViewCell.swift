//
//  KMAUIRulesPointTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRulesPointTableViewCell: UITableViewCell {
    // MARK: - Variables
    public static let id = "KMAUIRulesPointTableViewCell"
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var valueLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public var name = ""
    public var value = "" {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        nameLabel.text = name
        valueLabel.text = value
    }
}
