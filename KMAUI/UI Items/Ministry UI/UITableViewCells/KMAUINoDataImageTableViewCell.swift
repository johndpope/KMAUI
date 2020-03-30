//
//  KMAUINoDataImageTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 30.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUINoDataImageTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUINoDataImageTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
        
        // Placeholder view
        logoImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
