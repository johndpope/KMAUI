//
//  KMACitizenUploadCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMACitizenUploadCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var categoryImageView: UIImageView!
    @IBOutlet public weak var categoryLabel: KMAUITextLabel!
    @IBOutlet public weak var createdAtLabel: KMAUIInfoLabel!
    @IBOutlet public weak var processingStatusLabel: KMAUIInfoLabel!
    @IBOutlet public weak var uploadDescriptionLabel: KMAUITextLabel!
    @IBOutlet public weak var departmentImageView: UIImageView!
    @IBOutlet public weak var departmentHandleLabel: KMAUITitleLabel!
    @IBOutlet public weak var departmentNameLabel: KMAUITextLabel!
    
    // MARK: - Variables
    public var upload = KMACitizenUpload()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Processing status
        processingStatusLabel.textColor = UIColor.white
        processingStatusLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        processingStatusLabel.clipsToBounds = true
    }

    public func setupCell() {
        // Category image
        categoryImageView.kf.indicatorType = .activity
        
        if !upload.categoryLogo.isEmpty, let url = URL(string: upload.categoryLogo) {
            categoryImageView.kf.setImage(with: url)
        }
        
        // Category name
        categoryLabel.text = upload.categoryName
        
        // Created at
        createdAtLabel.text = KMAUIUtilities.shared.formatStringShort(date: upload.createdAt)
        
        // Processing status
        processingStatusLabel.text = "  " + upload.processingStatus + "  "
        processingStatusLabel.backgroundColor = KMAUIUtilities.shared.getColor(status: upload.processingStatus)
        
        // Upload description
        uploadDescriptionLabel.text = upload.uploadDescription
        
        // Department logo
        departmentImageView.kf.indicatorType = .activity
        
        if !upload.departmentLogo.isEmpty, let url = URL(string: upload.departmentLogo) {
            departmentImageView.kf.setImage(with: url)
        }
        
        // Department handle
        departmentHandleLabel.text = upload.departmentHandle.formatUsername()
        
        // Department name
        departmentNameLabel.text = upload.departmentName
    }
}
