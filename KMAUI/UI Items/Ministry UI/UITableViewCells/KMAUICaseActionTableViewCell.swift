//
//  KMAUICaseActionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 27.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUICaseActionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var approveButton: UIButton!
    @IBOutlet public weak var declineButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUICaseActionTableViewCell"
    public var actionCallback: ((Bool) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Approve button
        approveButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        approveButton.setTitleColor(UIColor.white, for: .normal)
        approveButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        approveButton.layer.cornerRadius = 8
        approveButton.clipsToBounds = true
        
        // Decline button
        declineButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        declineButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal) // UIColor.black
        declineButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        declineButton.layer.cornerRadius = 8
        declineButton.clipsToBounds = true
        
        // Decline button
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction public func approveButtonPressed(_ sender: Any) {
        actionCallback?(true)
    }
    
    @IBAction public func declineButtonPressed(_ sender: Any) {
        actionCallback?(false)
    }
}
