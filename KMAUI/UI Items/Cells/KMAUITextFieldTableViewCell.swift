//
//  KMAUITextFieldTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUITextFieldTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Adjust the UI for the text field
        valueTextField.layer.borderColor = KMAUIConstants.shared.KMALineGray.cgColor
        valueTextField.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
