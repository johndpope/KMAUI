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
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        
    }
    
    // MARK: - IBActions
    
    @IBAction publicfunc confirmButtonPressed(_ sender: Any) {
    }
    
    @IBAction public func houseSwitchValueChanged(_ sender: Any) {
    }
}
