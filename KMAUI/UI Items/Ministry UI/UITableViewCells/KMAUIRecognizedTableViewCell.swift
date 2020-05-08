//
//  KMAUIRecognizedTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 08.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import KMAUI

public class KMAUIRecognizedTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var valueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var lineView: UIView!
    
    // MARK: - Variables
    public static let id = "KMAUIRecognizedTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Line view
        lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // No selection required
        selectionStyle = .none
    }
}
