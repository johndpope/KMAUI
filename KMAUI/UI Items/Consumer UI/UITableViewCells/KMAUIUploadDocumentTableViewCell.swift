//
//  KMAUIUploadDocumentTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIUploadDocumentTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    public static let id = "KMAUIUploadDocumentTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No standard selection required, we'll use the custom methods
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
