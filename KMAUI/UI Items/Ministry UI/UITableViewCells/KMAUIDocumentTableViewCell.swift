//
//  KMAUIDocumentTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 27.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDocumentTableViewCell: UITableViewCell {
    // MARK: - Variables
    public static let id = "KMAUIDocumentTableViewCell"
    public var file = KMADocumentData() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        
    }
}
