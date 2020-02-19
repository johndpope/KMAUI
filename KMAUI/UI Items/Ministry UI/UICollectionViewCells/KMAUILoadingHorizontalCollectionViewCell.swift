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
    @IBOutlet public weak var loadingActivityViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var loadingActivityViewRight: NSLayoutConstraint!
    @IBOutlet public weak var loadingLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUILoadingHorizontalCollectionViewCell"
    public var dataLoaded = false {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        loadingLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        loadingActivityView.startAnimating()
    }
    
    public func setupCell() {
        if dataLoaded {
            loadingLabel.text = "No data available..."
            loadingActivityView.stopAnimating()
            loadingActivityView.isHidden = true
            loadingActivityViewWidth.constant = 0
            loadingActivityViewRight.constant = 0
        } else {
            loadingLabel.text = "Loading..."
            loadingActivityView.startAnimating()
            loadingActivityView.isHidden = false
            loadingActivityViewWidth.constant = 37
            loadingActivityViewRight.constant = 8
        }
    }
}
