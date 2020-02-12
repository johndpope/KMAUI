//
//  KMAUILoadingCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 11.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUILoadingCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet public weak var loadingActivityViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var loadingActivityViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var loadingLabel: KMAUIBoldTextLabel!

    // MARK: - Variables
    public static let id = "KMAUILoadingCollectionViewCell"
    public var dataLoaded = false {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        bgView.clipsToBounds = true
        
        loadingLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        loadingActivityView.startAnimating()
    }

    public func setupCell() {
        if dataLoaded {
            loadingLabel.text = "No data available..."
            loadingActivityView.stopAnimating()
            loadingActivityView.isHidden = true
            loadingActivityViewHeight.constant = 0
            loadingActivityViewBottom.constant = 0
        } else {
            loadingLabel.text = "Loading"
            loadingActivityView.startAnimating()
            loadingActivityView.isHidden = false
            loadingActivityViewHeight.constant = 37
            loadingActivityViewBottom.constant = 8
        }
    }
}
