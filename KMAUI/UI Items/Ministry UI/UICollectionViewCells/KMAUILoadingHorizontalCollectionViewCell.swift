//
//  KMAUILoadingHorizontalCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILoadingHorizontalCollectionViewCell: UICollectionViewCell {
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet public weak var loadingLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUILoadingHorizontalCollectionViewCell"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // bgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        // bgView.clipsToBounds = true
        
        loadingLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        loadingActivityView.startAnimating()
    }

}
