//
//  KMAUIFileTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFileTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var itemImageView: UIImageView!
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemTypeLabel: KMAUIInfoLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIFileTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        
    }
}
