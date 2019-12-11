//
//  KMAUIPropertyDataTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIPropertyDataTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var houseSwitch: UISwitch!
    @IBOutlet public weak var apartmentTextField: UITextField!
    @IBOutlet public weak var apartmentTextFieldHeight: NSLayoutConstraint!
    @IBOutlet public weak var apartmentTextFieldTop: NSLayoutConstraint!
    @IBOutlet public weak var confirmButton: UIButton!
    
    // MARK: - Variables
    var apartmentNumber = 0
    var isPrivateHouse = true
    public var dataUpdatedCallback: ((Bool, Int) -> Void)?
    public var confirmCallback: ((Bool) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Adjust the UI for the text field
        apartmentTextField.delegate = self
        apartmentTextField.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        apartmentTextField.layer.borderColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.2).cgColor
        apartmentTextField.layer.borderWidth = 1
        apartmentTextField.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // Create a padding view for padding on left
        apartmentTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: apartmentTextField.frame.height))
        apartmentTextField.leftViewMode = .always
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        houseSwitch.isOn = isPrivateHouse
        apartmentTextField.text = "\(apartmentNumber)"
        verifyVisibility()
    }
    
    /**
     Verify visibility
     */
    
    func verifyVisibility() {
        if isPrivateHouse {
            apartmentTextField.alpha = 0
            apartmentTextFieldTop.constant = 0
            apartmentTextFieldHeight.constant = 0
        } else {
            apartmentTextField.alpha = 1
            apartmentTextFieldTop.constant = 8
            apartmentTextFieldHeight.constant = 44
        }
    }
    
    // MARK: - IBActions
    
    /**
     Text field value changed.
     */
    
    @objc func textFieldValueChanged(textField: UITextField) {
        if let textLoaded = apartmentTextField.text {
            if let intValue = Int(textLoaded) {
                apartmentNumber = intValue
            } else {
                apartmentNumber = 0
            }
            
            dataUpdatedCallback?(isPrivateHouse, apartmentNumber)
        }
    }
    
    @IBAction public func confirmButtonPressed(_ sender: Any) {
        dataUpdatedCallback?(isPrivateHouse, apartmentNumber)
        // Plus update all the details
        confirmCallback?(true)
    }
    
    @IBAction public func houseSwitchValueChanged(_ sender: Any) {
        dataUpdatedCallback?(isPrivateHouse, apartmentNumber)
    }
}

// MARK: - UITextField delegate

extension KMAUIPropertyDataTableViewCell: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        apartmentTextField.resignFirstResponder()
        
        return true
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Only alphanumerics for username
        if !string.isEmpty {
            var allowedCharacters = CharacterSet()
            allowedCharacters.insert(charactersIn: "0123456789")
            let unwantedStr = string.trimmingCharacters(in: allowedCharacters)
            
            return unwantedStr.count == 0
        }
        
        return true
    }
}
