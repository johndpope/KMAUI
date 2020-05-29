//
//  KMAUILandCasesCourtDecisionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 28.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUILandCasesCourtDecisionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var caseLabel: UILabel!
    @IBOutlet weak var caseLabelLeft: NSLayoutConstraint!
    @IBOutlet public weak var caseStatusLabel: UILabel!
    @IBOutlet public weak var judgeCommentLabel: UILabel!
    @IBOutlet public weak var documentImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUILandCasesCourtDecisionTableViewCell"
    public var isDepartment = false
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupCell()
        }
    }

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
    
    public func setupCell() {
        if isDepartment {
            setupDepartment()
        } else {
            setupCase()
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
        documentImageView.alpha = 0
        caseLabelLeft.constant = 16
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
        caseLabelLeft.constant = 16
        
        let files = KMAUIUtilities.shared.getItemsFrom(uploadBody: landCase.departmentAttachment)
        if !files.isEmpty {
            documentImageView.alpha = 1
            caseLabelLeft.constant = 16 + 60 + 12
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
            caseLabelLeft.constant = 16
        }
    }
}
