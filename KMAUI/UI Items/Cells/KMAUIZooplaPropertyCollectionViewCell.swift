//
//  KMAUIZooplaPropertyCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIZooplaPropertyCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var propertyImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Round corners for image view
        propertyImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        propertyImageView.clipsToBounds = true
    }
}
