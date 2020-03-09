//
//  KMAUIExtraPriceTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 09.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIExtraPriceTableViewCell: UITableViewCell {
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var confirmButton: UIButton!
    // MARK: - Variables
    public static let id = "KMAUIExtraPriceTableViewCell"
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
    
    @IBAction public func confirmButtonPressed(_ sender: Any) {
        actionCallback?(true)
    }
}
