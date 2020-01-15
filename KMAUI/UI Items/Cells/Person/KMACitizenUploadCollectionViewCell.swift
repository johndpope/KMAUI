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
    @IBOutlet public weak var line1: UIView!
    @IBOutlet public weak var line2: UIView!
    @IBOutlet public weak var previewImageView: UIImageView!
    
    // MARK: - Variables
    public var upload = KMACitizenUpload()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Processing status
        processingStatusLabel.textColor = UIColor.white
        processingStatusLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        processingStatusLabel.clipsToBounds = true
        
        // Rounded corners for department logo
        departmentImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        departmentImageView.clipsToBounds = true
        
        // Round corners for the preview image view
        previewImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        previewImageView.clipsToBounds = true
        
        // Background for the upload description
        uploadDescriptionLabel.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        uploadDescriptionLabel.textColor = UIColor.white
        uploadDescriptionLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        uploadDescriptionLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        uploadDescriptionLabel.clipsToBounds = true
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
        uploadDescriptionLabel.text = " " + upload.uploadDescription + " "
        uploadDescriptionLabel.numberOfLines = 2
        uploadDescriptionLabel.minimumScaleFactor = 0.7
        
        if upload.departmentHandle.isEmpty {
            hideDepartment()
        } else {
            showDepartment()
        }
        
        // Setup the preview image
        let uploadItems = KMAUIUtilities.shared.getItemsFrom(uploadBody: upload.uploadBody)
        previewImageView.kf.indicatorType = .activity
        previewImageView.backgroundColor = KMAUIConstants.shared.KMABgGray
        previewImageView.contentMode = .scaleAspectFill
        
        for uploadItem in uploadItems {
            if !uploadItem.previewURL.isEmpty, let url = URL(string: uploadItem.previewURL) {
                previewImageView.kf.setImage(with: url)
                
                break
            }
        }
    }
    
    public func hideDepartment() {
        departmentImageView.image = KMAUIConstants.shared.departmentPlaceholder
        departmentHandleLabel.text = "No assigned"
        departmentNameLabel.text = "Ministry will assign a department"
    }
    
    public func showDepartment() {
        // Department logo
        departmentImageView.contentMode = .scaleAspectFill
        departmentImageView.kf.indicatorType = .activity
        
        departmentImageView.image = KMAUIConstants.shared.departmentPlaceholder
        
        if !upload.departmentLogo.isEmpty, let url = URL(string: upload.departmentLogo) {
            departmentImageView.kf.setImage(with: url)
        }
        
        // Department handle
        departmentHandleLabel.text = upload.departmentHandle.formatUsername()
        
        // Department name
        departmentNameLabel.text = upload.departmentName
        // Minimum fornt size for the department name
        departmentNameLabel.numberOfLines = 2
        departmentNameLabel.minimumScaleFactor = 0.7
    }
}
