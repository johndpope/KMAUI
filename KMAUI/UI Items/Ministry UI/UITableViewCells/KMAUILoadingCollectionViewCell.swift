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
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var loadingActivityView: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: KMAUIBoldTextLabel!

    // MARK: - Variables
    public static let id = "KMAUILoadingCollectionViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        bgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        bgView.clipsToBounds = true
    }

}
