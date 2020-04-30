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
        
        // Bg image view
        bgImageView.image = KMAUIConstants.shared.uploadBackground
        bgImageView.contentMode = .scaleAspectFill
        
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
        
        if UIScreen.main.bounds.size.width == 320 {
            titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        }

        // Info label
        
        // No standard selection required
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
            bgView.alpha = 0.8
        } else {
            bgView.alpha = 1.0
        }
    }
    
    public func setupCell() {
        var departmentName = "Department"
        // Get the real department name
        if !rowData.rowValue.isEmpty {
            departmentName = rowData.rowValue
        }
        // Setup title
        titleLabel.text = rowData.rowName
        // Setup data depedning on the title
        if rowData.rowName == "Upload a document" {
            infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["image", "pdf"], in: "Load the image or pdf file if you already have the land that you received in the lottery")
            largeImageView.image = KMAUIConstants.shared.uploadDocumentImage
            largeImageView.layer.borderColor = UIColor.clear.cgColor
            smallImageView.image = KMAUIConstants.shared.uploadDocumentBadge
        } else if rowData.rowName == "Pending" {
            infoLabel.text = "Your document was received by the \(departmentName) and it will be processed soon"
            largeImageView.image = KMAUIConstants.shared.pendingDocumentImage
            largeImageView.layer.borderColor = KMAUIConstants.shared.KMAUIYellowProgressColor.cgColor
            smallImageView.image = KMAUIConstants.shared.pendingDocumentBadge
        } else if rowData.rowName == "Document approved" {
            infoLabel.text = "Your document was approved by the \(departmentName) and you've received the Sub land"
            largeImageView.image = KMAUIConstants.shared.pendingDocumentImage
            largeImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreenProgressColor.cgColor
            smallImageView.image = KMAUIConstants.shared.approvedDocumentBadge
        }
    }
}
