//
//  KMAUIPropertyDataTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

class KMAUIPropertyDataTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var houseSwitch: UISwitch!
    @IBOutlet weak var apartmentTextField: UITextField!
    @IBOutlet weak var apartmentTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var apartmentTextFieldTop: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: - Variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCell() {
        
    }
    
    // MARK: - IBActions
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
    }
    
    @IBAction func houseSwitchValueChanged(_ sender: Any) {
    }
}
