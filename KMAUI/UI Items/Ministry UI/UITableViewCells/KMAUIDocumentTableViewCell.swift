//
//  KMAUIDocumentTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 27.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIDocumentTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var typeLabel: KMAUIRegularTextLabel!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var previewImageView: UIImageView!
    // MARK: - Variables
    public static let id = "KMAUIDocumentTableViewCell"
    public var documentType = ""
    public var file = KMADocumentData() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        typeLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        // Type image view
        typeImageView.layer.cornerRadius = 8
        typeImageView.clipsToBounds = true
        // Preview image view
        previewImageView.layer.cornerRadius = 8
        previewImageView.clipsToBounds = true
        previewImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        previewImageView.layer.borderWidth = 1
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Labels
        nameLabel.text = file.name
        typeLabel.text = file.type
        // Type image view
        if documentType == "KMADocument" {
            typeImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint.withAlphaComponent(0.1)
            typeImageView.image = KMAUIConstants.shared.propertyDocument.withRenderingMode(.alwaysTemplate)
            typeImageView.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        } else if documentType == "KMAUserUpload" {
            typeImageView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor.withAlphaComponent(0.1)
            typeImageView.image = KMAUIConstants.shared.uploadedDocument.withRenderingMode(.alwaysTemplate)
            typeImageView.tintColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        }
        // Preview image view
    }
}
