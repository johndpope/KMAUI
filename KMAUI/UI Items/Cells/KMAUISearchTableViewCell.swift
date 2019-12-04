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
    
    // MARK: - Variables
    public var nextFieldCallback: ((String) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Adjust the search text field
        searchTextField.layer.borderColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.2).cgColor
        searchTextField.layer.borderWidth = 1
        searchTextField.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        // Create a padding view for padding on left
        searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: searchTextField.frame.height))
        searchTextField.leftViewMode = .always
        
        searchTextField.placeholder = "Enter topic, keyword, etc"
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

// MARK: - UITextField delegate

extension KMAUISearchTableViewCell: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nextFieldCallback?("done")
        
        return true
    }
}
