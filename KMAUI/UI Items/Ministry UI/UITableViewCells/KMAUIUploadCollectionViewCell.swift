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
    @IBOutlet public weak var previewImageView: UIImageView!
    @IBOutlet public weak var newLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var placeLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var playButton: UIButton!
    // MARK: - Variables
    public static let id = "KMAUIUploadCollectionViewCell"
    public var playCallback: ((Bool) -> Void)?
    public var isPlaying = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background view corner raidus
        bgView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        bgView.clipsToBounds = true
        
        // New label background color and corner radius
        newLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        newLabel.textColor = KMAUIConstants.shared.KMAUIViewBgColor
        newLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        newLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        newLabel.clipsToBounds = true
        newLabel.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        
        // The placeholder data for items
        profileImageView.backgroundColor = KMAUIConstants.shared.KMALineGray.withAlphaComponent(0.75)
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        placeLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: Date(), numOnly: true)
    }
    
    public func setupCell() {
        nameLabel.text = "Russel Stephens"
        placeLabel.text = "Life in Riyadh, Saudi Arabia"
        previewImageView.image = KMAUIConstants.shared.placeholderUploadImage
        profileImageView.image = KMAUIConstants.shared.placeholderProfileImage
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        isPlaying = !isPlaying
        playCallback?(isPlaying)
    }
}
