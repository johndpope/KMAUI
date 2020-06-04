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
    @IBOutlet public weak var displayView: UIView!
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var bgViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var bgImageView: UIImageView!
    @IBOutlet public weak var largeImageView: UIImageView!
    @IBOutlet public weak var smallImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoLabel: UILabel!
    @IBOutlet public weak var uploadButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIUploadDocumentTableViewCell"
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Display view
        displayView.layer.cornerRadius = 10
        displayView.clipsToBounds = true
        
        // Bg view
        bgView.backgroundColor = UIColor.clear
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // Bg image view
        bgImageView.image = KMAUIConstants.shared.uploadBackground
        bgImageView.contentMode = .scaleAspectFill
        
        // Large image
        largeImageView.layer.cornerRadius = 40
        largeImageView.layer.borderWidth = 2
        largeImageView.clipsToBounds = true
        
        // Small image
        smallImageView.layer.cornerRadius = 16
        smallImageView.clipsToBounds = true
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        if UIScreen.main.bounds.size.width == 320 {
            titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        }
        
        // Title label
        titleLabel.textColor = UIColor.white

        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        infoLabel.textColor = UIColor.white
        
        // Upload button
        uploadButton.layer.cornerRadius = 17
        uploadButton.clipsToBounds = true
        uploadButton.isUserInteractionEnabled = false
        
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
            displayView.alpha = 0.8
        } else {
            displayView.alpha = 1.0
        }
    }
    
    public func setupCell() {
        // Bg view bottom
        bgViewBottom.constant = 0
        uploadButton.alpha = 0
        // Department name
        var departmentName = "Department"
        // Get the real department name
        if !rowData.rowValue.isEmpty {
            departmentName = rowData.rowValue
        }
        // Setup title
        titleLabel.text = rowData.rowName
        // Setup data depedning on the title
        if rowData.rowName == "New land case" {
            infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["land location", "upload photos"], in: "Provide the information about the land location and upload photos to confirm the land ownership")
            bgViewBottom.constant = 34 + 21
            uploadButton.alpha = 1
            largeImageView.image = KMAUIConstants.shared.uploadDocumentImage
            largeImageView.layer.borderColor = UIColor.clear.cgColor
            smallImageView.image = KMAUIConstants.shared.uploadDocumentBadgeGray
            uploadButton.setTitle("Start a land case", for: .normal)
        } else if rowData.rowName == "Land case" {
            titleLabel.text = rowData.rowName + " " + rowData.rowValue.lowercased()
            
            if rowData.rowValue == "In progress" {
                uploadButton.setTitle("View progress", for: .normal)
                infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["additional information"], in: "The land case application was received by the court, you can still provide an additional information")
                smallImageView.image = KMAUIConstants.shared.pendingAttachmentIcon
            } else if rowData.rowValue == "Approved" {
                uploadButton.setTitle("View details", for: .normal)
                infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["approved"], in: "Your land case was approved by the court, you can review the full details")
                smallImageView.image = KMAUIConstants.shared.approvedAttachmentIcon
            } else if rowData.rowValue == "Declined" {
                uploadButton.setTitle("View details", for: .normal)
                infoLabel.attributedText = KMAUIUtilities.shared.highlight(words: ["declined"], in: "Your land case was declined by the court, you can review the full details")
                smallImageView.image = KMAUIConstants.shared.rejectedAttachmentIcon
            }
            bgViewBottom.constant = 34 + 21
            uploadButton.alpha = 1
            largeImageView.image = KMAUIConstants.shared.uploadDocumentImage
            largeImageView.layer.borderColor = UIColor.clear.cgColor
        } else if rowData.rowName == "Upload a document" {
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
        // Increase the spacing
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
    }
}
