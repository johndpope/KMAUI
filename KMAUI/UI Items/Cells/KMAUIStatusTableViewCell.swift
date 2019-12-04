//
//  KMAUIStatusTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIStatusTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var statusLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!

    // MARK: - Variables
    public var isChecked = false
    public var value = ""

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        statusLabel.text = value
        
        if isChecked {
            statusImageView.image = KMAUIConstants.shared.checkboxFilledIcon
        } else {
            statusImageView.image = KMAUIConstants.shared.checkboxIcon
        }
    }
}
