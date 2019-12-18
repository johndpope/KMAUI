//
//  KMAUIDashboadNoDataTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDashboadNoDataTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var infoLabel: KMAUITextLabel!
    @IBOutlet public weak var actionButton: KMAUIButtonFilled!
    @IBOutlet public weak var actionButtonHeight: NSLayoutConstraint!
    @IBOutlet public weak var actionButtonBottom: NSLayoutConstraint!
    
    // MARK: - Variables
    public var info = ""
    public var action = ""
    public var actionCallback: ((Bool) -> Void)?
    
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
        infoLabel.text = info
        actionButton.setTitle(action, for: .normal)
        
        if action.isEmpty {
            actionButton.alpha = 0
            actionButtonHeight.constant = 0
            actionButtonBottom.constant = 0
        } else {
            actionButton.alpha = 1
            actionButtonHeight.constant = 44
            actionButtonBottom.constant = 8
        }
    }
    
    @IBAction public func actionButtonPressed(_ sender: Any) {
        actionCallback?(true)
    }
}
