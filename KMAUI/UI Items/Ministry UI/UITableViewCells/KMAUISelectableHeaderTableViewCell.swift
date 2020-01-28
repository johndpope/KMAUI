//
//  KMAUISelectableHeaderTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 28.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISelectableHeaderTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var stackView: UIStackView!
    
    // MARK: - Variables
    public static let id = "KMAUISelectableHeaderTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
