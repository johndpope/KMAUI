//
//  KMAUILandCasesCourtDecisionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 28.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import QuickLook

public class KMAUILandCasesCourtDecisionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var caseLabel: UILabel!
    @IBOutlet public weak var caseLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var caseStatusLabel: UILabel!
    @IBOutlet public weak var judgeCommentLabel: UILabel!
    @IBOutlet public weak var documentImageView: UIImageView!
    @IBOutlet public weak var documentButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUILandCasesCourtDecisionTableViewCell"
    public var isDepartment = false
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupLandCase()
        }
    }
    public var trespassType = ""
    public var trespassCase = KMAUITrespassCaseStruct() {
        didSet {
            setupTrespassCase()
        }
    }
    public lazy var previewItem = NSURL()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // BgView color
        bgView.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        
        // Land case
        caseLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(19)
        
        // Case status label
        caseStatusLabel.layer.cornerRadius = 6
        caseStatusLabel.clipsToBounds = true
        caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        caseStatusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(12)
        caseStatusLabel.textColor = UIColor.white
        
        // Judge comment
        judgeCommentLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Document image view
        documentImageView.layer.cornerRadius = 8
        documentImageView.clipsToBounds = true
        documentImageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        documentImageView.layer.borderWidth = 1
        documentImageView.kf.indicatorType = .activity
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupLandCase() {
        if isDepartment {
            setupDepartment()
        } else {
            setupCase()
        }
    }
    
    public func setupTrespassCase() {
        if trespassType == "initialCheck" {
            setupTrespassInitialCheck()
        }
    }
    
    public func setupCase() {
        // Setup labels
        caseLabel.text = "\(landCase.courtStatus) case"
        caseStatusLabel.text = landCase.courtStatus.lowercased()
        judgeCommentLabel.text = landCase.judgeComment
        judgeCommentLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        // Setup background color for status label
        if landCase.courtStatus.lowercased() == "approved" {
            caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else {
            caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
        
        // Hide the document preview
        let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.judgeAttachment)
        if !files.isEmpty {
            documentImageView.alpha = 1
            caseLabelLeft.constant = 20 + 60 + 12
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
        } else {
            documentImageView.alpha = 0
            caseLabelLeft.constant = 20
        }
    }
    
    public func setupDepartment() {
        // Setup labels
        caseLabel.text = "\(landCase.departmentDecision) by Department"
        caseStatusLabel.text = landCase.departmentDecision.lowercased()
        judgeCommentLabel.text = landCase.departmentComment
        judgeCommentLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        // Setup background color for status label
        if landCase.departmentDecision.lowercased() == "approved" {
            caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else {
            caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
        
        // Hide the document preview
        documentImageView.alpha = 0
        caseLabelLeft.constant = 20
        
        let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.departmentAttachment)
        if !files.isEmpty {
            documentImageView.alpha = 1
            caseLabelLeft.constant = 20 + 60 + 12
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
        } else {
            documentImageView.alpha = 0
            caseLabelLeft.constant = 20
        }
    }
    
    public func setupTrespassInitialCheck() {
        // Setup labels
        caseLabel.text = "Initial check"
        judgeCommentLabel.text = trespassCase.initialCheckComment
        judgeCommentLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        // Setup background color for status label
        if trespassCase.caseStatus != "Declined" {
            caseStatusLabel.text = "approved"
            caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else {
            caseStatusLabel.text = "declined"
            caseStatusLabel.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        }
        
        // Hide the document preview
        let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: trespassCase.initialCheckAttachments)
        if !files.isEmpty {
            documentImageView.alpha = 1
            caseLabelLeft.constant = 20 + 60 + 12
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
        } else {
            documentImageView.alpha = 0
            caseLabelLeft.constant = 20
        }
    }
    
    @IBAction public func documentButtonPressed(_ sender: Any) {
        if trespassType == "initialCheck" {
            let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: trespassCase.initialCheckAttachments)
            if !files.isEmpty {
                let file = files[0]

                KMAUIUtilities.shared.quicklookPreview(urlString: file.fileURL, fileName: file.name, uniqueId: trespassCase.objectId) { (previewItemValue) in
                    self.previewItem = previewItemValue
                    // Display file
                    let previewController = QLPreviewController()
                    previewController.dataSource = self
                    KMAUIUtilities.shared.displayAlert(viewController: previewController)
                }
            }
        } else if isDepartment {
            let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.departmentAttachment)
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
        } else {
            let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.judgeAttachment)
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
}

// MARK: - QLPreviewController Datasource

extension KMAUILandCasesCourtDecisionTableViewCell: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}
