//
//  KMAUIDocumentCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 20.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDocumentCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var documentImageView: UIImageView!
    @IBOutlet public weak var documentNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var optionsButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIDocumentCollectionViewCell"
    public var document = KMAPropertyDocument() {
        didSet {
            setupCell()
        }
    }
    public var optionsCallback: ((Bool) -> Void)?

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Bg view
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 12
        
        // Setup image
        documentImageView.layer.cornerRadius = 8
        clipsToBounds = true
        
        // Name label
        documentNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Date label
        dateLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
    }

    public func setupCell() {
        documentNameLabel.text = document.name
        
        if document.documentType == "KMADocument" {
            dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: document.issueDate)
            documentImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint.withAlphaComponent(0.1)
            documentImageView.image = KMAUIConstants.shared.propertyDocument.withRenderingMode(.alwaysTemplate)
            documentImageView.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        } else if document.documentType == "KMAUserUpload" {
            dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: document.documentExpiryDate)
            documentImageView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor.withAlphaComponent(0.1)
            documentImageView.image = KMAUIConstants.shared.uploadedDocument.withRenderingMode(.alwaysTemplate)
            documentImageView.tintColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        }

        infoLabel.text = document.descriptionText
    }
    
    @IBAction func optionsButtonPressed(_ sender: Any) {
        optionsCallback?(true)
    }
}
