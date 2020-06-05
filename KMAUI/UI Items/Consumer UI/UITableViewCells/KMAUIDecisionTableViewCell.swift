//
//  KMAUIDecisionTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 04.06.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import QuickLook
import Kingfisher

public class KMAUIDecisionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var documentImageView: UIImageView!
    @IBOutlet public weak var documentImageLeft: NSLayoutConstraint!
    @IBOutlet public weak var documentButton: UIButton!
    @IBOutlet public weak var statusLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var statusValueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var commentLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public var type = ""
    public static let id = "KMAUIDecisionTableViewCell"
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupCell()
        }
    }
    public lazy var previewItem = NSURL()

    override public  func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 4
        
        // Document image view
        documentImageView.layer.cornerRadius = 8
        documentImageView.clipsToBounds = true
        documentImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        documentImageView.layer.borderWidth = 1
        documentImageView.kf.indicatorType = .activity
        
        if UIScreen.main.bounds.size.width == 320 {
            statusValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        }
        
        // Case status label
        statusValueLabel.layer.cornerRadius = 6
        statusValueLabel.clipsToBounds = true
        statusValueLabel.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        statusValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        statusValueLabel.textColor = UIColor.white
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        var files = [KMADocumentData]()
        var status = ""
        var comment = ""

        if type == "court" {
            statusLabel.text = "\(landCase.courtStatus) by court"
            status = landCase.courtStatus
            comment = landCase.judgeComment
            files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.judgeAttachment)
        } else if type == "department" {
            statusLabel.text = "Department's decision"
            status = landCase.departmentDecision
            comment = landCase.departmentComment
            files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.departmentAttachment)
        }
        
        if status.lowercased() == "approved" {
            statusValueLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else {
            statusValueLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
        
        statusValueLabel.text = status
        commentLabel.text = comment
        
        if files.isEmpty {
            documentImageView.alpha = 0
            documentButton.alpha = 0
            documentImageLeft.constant = 8 - 44
        } else {
            documentImageView.alpha = 1
            documentButton.alpha = 1
            documentImageLeft.constant = 16
            
            let file = files[0]
            
            // Preview image view alignment
            documentImageView.contentMode = .center
            documentImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            documentImageView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
            
            if file.type == "Document" {
                documentImageView.image = KMAUIConstants.shared.propertyDocument.withRenderingMode(.alwaysTemplate)
            } else {
                documentImageView.image = KMAUIConstants.shared.uploadedDocument.withRenderingMode(.alwaysTemplate)
            }
            // Preview image view - get the image for all types of files as we have the QuickLook previews implemented

            if !file.previewURL.isEmpty, let url = URL(string: file.previewURL) {
                self.documentImageView.kf.setImage(with: url) { result in
                    switch result {
                    case .success(let value):
                        self.documentImageView.image = value.image
                        self.documentImageView.contentMode = .scaleAspectFill
                    case .failure(let error):
                        print(error.localizedDescription) // The error happens
                    }
                }
            }
        }
    }
    
    // MARK: - Button pressed
    
    @IBAction public func documentButtonPressed(_ sender: Any) {
        var files = [KMADocumentData]()
        
        if type == "court" {
            files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.judgeAttachment)
        } else if type == "department" {
            files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.departmentAttachment)
        }
        
        if !files.isEmpty {
            let file = files[0]

            KMAUIUtilities.shared.quicklookPreview(urlString: file.fileURL, fileName: file.name, uniqueId: landCase.objectId) { (previewItemValue) in
                self.previewItem = previewItemValue
                // Display file
                let previewController = QLPreviewController()
                previewController.dataSource = self
                KMAUIUtilities.shared.displayAlert(viewController: previewController)
            }
        }
    }
}

// MARK: - QLPreviewController Datasource

extension KMAUIDecisionTableViewCell: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}
