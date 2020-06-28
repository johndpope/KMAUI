//
//  KMAUISaveButtonTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 04.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISaveButtonTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var saveButton: UIButton!
    
    // MARK: - Variables
    public var buttonPressedCallback: ((String) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Rounded corners for button
        saveButton.layer.cornerRadius = 26
        saveButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions - test
    
    @IBAction public func saveButtonPressed(_ sender: Any) {
        buttonPressedCallback?("pressed")
    }
}
