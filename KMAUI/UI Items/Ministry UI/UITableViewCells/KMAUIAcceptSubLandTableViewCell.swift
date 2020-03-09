//
//  KMAUIAcceptSubLandTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 09.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIAcceptSubLandTableViewCell: UITableViewCell {
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var declineButton: KMAUIButtonFilled!
    @IBOutlet public weak var acceptButtonPressed: KMAUIButtonFilled!
    // MARK: - Variables
    public static let id = "KMAUIAcceptSubLandTableViewCell"
    public var actionCallback: ((Bool) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Decline button to be red
        declineButton.backgroundColor = KMAUIConstants.shared.KMARedColor
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction public func declineButtonPressed(_ sender: Any) {
        actionCallback?(false)
    }
    
    @IBAction public func acceptButtonPressed(_ sender: Any) {
        actionCallback?(true)
    }
}
