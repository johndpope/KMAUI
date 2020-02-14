//
//  KMAUIFileDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFileDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    
    // MARK: - Variables
    public static let id = "KMAUIUploadsHorizontalTableViewCell"
    public var uploadItem = KMAUIUploadItem() {
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
