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
    // MARK: - IBOutlets
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var typeLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var typeImageView: UIImageView!
    @IBOutlet public weak var previewImageView: UIImageView!
    @IBOutlet public weak var lineView: UIView!
    // MARK: - Variables
    public static let id = "KMAUIDocumentTableViewCell"
    public var isLast = false
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
        previewImageView.kf.indicatorType = .activity
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight {
            backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            nameLabel.textColor = UIColor.red
        } else {
            backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            nameLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        }
    }
    
    public func setupCell() {
        if isLast {
            lineView.alpha = 0
        } else {
            lineView.alpha = 0.2
        }
        // Labels
        nameLabel.text = file.name
        typeLabel.text = file.type
        
        let components = file.name.components(separatedBy: ".")
        
        if components.count >= 2, let ext = components.last {
            nameLabel.text = file.name.replacingOccurrences(of: "." + ext, with: "")
            typeLabel.text = ext.uppercased()
        }
        // Type image view
        if documentType == "KMADocument" {
            typeImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint.withAlphaComponent(0.1)
            typeImageView.image = KMAUIConstants.shared.propertyDocument.withRenderingMode(.alwaysTemplate)
            typeImageView.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
            previewImageView.image = KMAUIConstants.shared.propertyDocument.withRenderingMode(.alwaysTemplate)
            previewImageView.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
        } else if documentType == "KMAUserUpload" {
            typeImageView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor.withAlphaComponent(0.1)
            typeImageView.image = KMAUIConstants.shared.uploadedDocument.withRenderingMode(.alwaysTemplate)
            typeImageView.tintColor = KMAUIConstants.shared.KMAUIGreenProgressColor
            previewImageView.image = KMAUIConstants.shared.uploadedDocument.withRenderingMode(.alwaysTemplate)
        }
        // Preview image view
        previewImageView.contentMode = .center
        previewImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        previewImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        if !file.previewURL.isEmpty, let url = URL(string: file.previewURL) {
            self.previewImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.previewImageView.image = value.image
                    
                    if self.documentType == "KMAUserUpload" { // Stay centered for documents as we don't have an actual preview image to display
                        self.previewImageView.contentMode = .scaleAspectFill
                    }
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
    }
}
