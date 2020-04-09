//
//  KMAUIUploadDocumentTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIUploadDocumentTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var bgImageView: UIImageView!
    @IBOutlet public weak var largeImageView: UIImageView!
    @IBOutlet public weak var smallImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUIUploadDocumentTableViewCell"
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Bg view
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // Large image
        largeImageView.layer.cornerRadius = 41
        largeImageView.layer.borderWidth = 2
        largeImageView.clipsToBounds = true
        
        // Small image
        smallImageView.layer.cornerRadius = 16
        smallImageView.clipsToBounds = true
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        titleLabel.textColor = UIColor.white
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        
        // No standard selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Setup title
        titleLabel.text = rowData.rowName
        // Setup data depedning on the title
        if rowData.rowName == "Upload a document" {
            infoLabel.text = "Load the image or pdf file if you already have the land that you received in the lottery"
            largeImageView.image = KMAUIConstants.shared.uploadDocumentImage
            largeImageView.layer.borderColor = UIColor.clear.cgColor
            smallImageView.image = KMAUIConstants.shared.uploadDocumentBadge
        } else if rowData.rowName == "Pending" {
            infoLabel.text = "Your document was received by the Department and it will be processed soon"
            largeImageView.image = KMAUIConstants.shared.pendingDocumentImage
            largeImageView.layer.borderColor = KMAUIConstants.shared.KMAUIYellowProgressColor.cgColor
            smallImageView.image = KMAUIConstants.shared.pendingDocumentBadge
        } else if rowData.rowName == "Document approved" {
            infoLabel.text = "Your document was approved by the Department and you've received the Sub land"
            largeImageView.image = KMAUIConstants.shared.pendingDocumentImage
            largeImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreenProgressColor.cgColor
            smallImageView.image = KMAUIConstants.shared.approvedDocumentBadge
        }
    }
}
