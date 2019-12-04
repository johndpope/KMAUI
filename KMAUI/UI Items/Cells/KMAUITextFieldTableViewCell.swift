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
    @IBOutlet public weak var placeholderLabel: UILabel!
    @IBOutlet public weak var valueTextField: UITextField!
    
    // MARK: - Variables
    public var cellType = ""
    public var cellData = KMAUITextFieldCellData()
    public var textFieldChangedCallback: ((String) -> Void)?
    public var nextFieldCallback: ((String) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Adjust the UI for the text field
        valueTextField.delegate = self
        valueTextField.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        valueTextField.layer.borderColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.2).cgColor
        valueTextField.layer.borderWidth = 1
        valueTextField.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // Padding
        
        // Create a padding view for padding on left
        valueTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: valueTextField.frame.height))
        valueTextField.leftViewMode = .always

        // Create a padding view for padding on right
//        valueTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: valueTextField.frame.height))
//        valueTextField.rightViewMode = .always
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     Setup the cell UI.
     */
    
    public func setupCell() {
        // Setup the placeholder
        placeholderLabel.text = cellData.placeholderText
        valueTextField.placeholder = cellData.placeholderText
        valueTextField.text = cellData.value
    }
    
    // MARK: - IBActions
    
    /**
     Text field value changed.
    */
    
    @objc func textFieldValueChanged(textField: UITextField) {
        if let textLoaded = valueTextField.text {
            cellData.value = textLoaded
            textFieldChangedCallback?("changed")
        }
    }
}

// MARK: - UITextField delegate

extension KMAUITextFieldTableViewCell: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextFieldCallback?("done")
        
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only alphanumerics for username
        if cellType == "username", !string.isEmpty {
            var allowedCharacters = CharacterSet()
            allowedCharacters.insert(charactersIn: KMAUIConstants.shared.usernameAllowedCharacters)
            let unwantedStr = string.trimmingCharacters(in: allowedCharacters)
            
            return unwantedStr.count == 0
        }
        
        return true
    }
}
