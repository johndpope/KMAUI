//
//  KMAUIUploadCollectionViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 03.02.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher

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
    public var uploadItem = KMAUIUploadItem() {
        didSet {
            setupCell()
        }
    }
    
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
        profileImageView.clipsToBounds = true
        
        placeLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        profileImageView.kf.indicatorType = .activity
        previewImageView.kf.indicatorType = .activity
    }
    
    public func demoSetupCell() {
        nameLabel.text = "Russel Stephens"
        placeLabel.text = "Life in Riyadh, Saudi Arabia"
        previewImageView.image = KMAUIConstants.shared.placeholderUploadImage
        profileImageView.image = KMAUIConstants.shared.placeholderProfileImage
        dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: Date(), numOnly: true)
    }
    
    public func setupCell() {
        // Citizen name
        nameLabel.text = uploadItem.citizenName
        
        // Citizen image
        profileImageView.image = KMAUIConstants.shared.profileIcon//.noir
        profileImageView.alpha = 0.25
        profileImageView.layer.cornerRadius = 0
        
        if !uploadItem.citizenImage.isEmpty, let url = URL(string: uploadItem.citizenImage) {
            profileImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.profileImageView.image = value.image
                    self.profileImageView.alpha = 1
                    self.profileImageView.layer.cornerRadius = 20
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
        
        // Upload name
        placeLabel.text = uploadItem.uploadName
        
        // Upload image
        previewImageView.image = KMAUIConstants.shared.placeholderUploadImage//.noir
        previewImageView.alpha = 0.25
        
        if !uploadItem.uploadImage.isEmpty, let url = URL(string: uploadItem.uploadImage) {
            previewImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.previewImageView.image = value.image
                    self.previewImageView.alpha = 1
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
        
        // Upload date
        dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: uploadItem.uploadDate, numOnly: true)
        
        // isNew
        newLabel.isHidden = !uploadItem.isNew
        
        // isVideo
        playButton.isHidden = true //!uploadItem.isVideo
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        isPlaying = !isPlaying
        playCallback?(isPlaying)
    }
}
