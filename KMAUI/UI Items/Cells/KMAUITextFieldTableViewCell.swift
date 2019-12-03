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
        valueTextField.layer.borderColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.2).cgColor
        valueTextField.layer.borderWidth = 1
        valueTextField.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // Padding
        
        // Create a padding view for padding on left
        valueTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: valueTextField.frame.height))
        valueTextField.leftViewMode = .always

        // Create a padding view for padding on right
        valueTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: valueTextField.frame.height))
        valueTextField.rightViewMode = .always
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
