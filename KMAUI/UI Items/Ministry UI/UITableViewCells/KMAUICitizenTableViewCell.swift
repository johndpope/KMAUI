//
//  KMAUICitizenTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 18.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUICitizenTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lotteryIdLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUICitizenTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
