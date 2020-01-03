//
//  KMAUIPoliceContactsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 03.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

class KMAUIPoliceContactsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
