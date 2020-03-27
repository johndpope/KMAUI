//
//  KMAUISearchTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISearchTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var searchTextField: UITextField!
    @IBOutlet public weak var searchIconImageView: UIImageView!
    
    // MARK: - Variables
    public var textFieldChangedCallback: ((String) -> Void)?
    public var value = ""
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Text field delegate and changes detection
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldValueChanged(textField:)), for: .editingChanged)
        
        // Adjust the search text field
        searchTextField.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // Create a padding view for padding on left
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        
        searchTextField.placeholder = "Enter topic, keyword, etc"

        // Search icon color
        searchIconImageView.image = KMAUIConstants.shared.searchIcon.withRenderingMode(.alwaysTemplate)
        searchIconImageView.tintColor = KMAUIConstants.shared.KMATextColor
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        searchTextField.text = value
    }
    
    // MARK: - IBActions
    
    /**
     Text field value changed.
    */
    
    @objc func textFieldValueChanged(textField: UITextField) {
        if let textLoaded = searchTextField.text {
            value = textLoaded
            textFieldChangedCallback?(value)
        }
    }
}

// MARK: - UITextField delegate

extension KMAUISearchTableViewCell: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        
        return true
    }
}
