//
//  KMAUIItemsInRowRuleTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 12.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIItemsInRowRuleTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var subLandLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemsInRowLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var subLandSizeLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIItemsInRowRuleTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Fonts for labels
        subLandLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        itemsInRowLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
