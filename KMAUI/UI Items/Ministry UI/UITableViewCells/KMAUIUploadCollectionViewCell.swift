//
//  KMAUIUploadCollectionViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 03.02.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIUploadCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var newLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var placeLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIRegularTextLabel!
    // MARK: - Variables
    public static let id = "KMAUIUploadCollectionViewCell"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCell() {
        // Background view corner raidus
        bgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        bgView.clipsToBounds = true
        
        // New label background color and corner radius
        newLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        newLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        newLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        newLabel.clipsToBounds = true
        newLabel.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        newLabel.text = " new "
        
        // The placeholder data for items
        profileImageView.backgroundColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.75)
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        nameLabel.text = "Russel Stephens"
        placeLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        placeLabel.text = "Life in Riyadh, Saudi Arabia"
        dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: Date(), numOnly: true)
    }
}
