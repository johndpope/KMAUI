//
//  KMAUINotificationDocumentTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 06.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import QuickLook
import Kingfisher

public class KMAUINotificationDocumentTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var shareButton: UIButton!
    @IBOutlet public weak var uploadImageView: UIImageView!
    @IBOutlet public weak var uploadImageButton: UIButton!
    @IBOutlet public weak var citizenView: UIView!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var arrowImageView: UIImageView!
    @IBOutlet public weak var citizenNameLabel: UILabel!
    @IBOutlet public weak var citizenIdLabel: UILabel!
    @IBOutlet public weak var citizenButton: UIButton!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var rejectButton: UIButton!
    @IBOutlet public weak var approveButton: UIButton!
    @IBOutlet public weak var statusLabel: UILabel!
    
    // MARK: - Variables
    public var subLand = KMAUISubLandStruct()
    public var citizen = KMAPerson()
    public var document = KMADocumentData() {
        didSet {
            setupCell()
        }
    }
    public var shareCallback: ((Bool) -> Void)?
    public var citizenCallback: ((Bool) -> Void)?
    public var subLandCallback: ((Bool) -> Void)?
    public lazy var previewItem = NSURL()
    
    // MARK: - Variables
    public static let id = "KMAUINotificationDocumentTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        infoLabel.isUserInteractionEnabled = true
        infoLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        // Share button
        shareButton.layer.cornerRadius = 6
        shareButton.clipsToBounds = true
        shareButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        shareButton.imageView?.contentMode = .center
            shareButton.setImage(KMAUIConstants.shared.shareIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.tintColor = KMAUIConstants.shared.KMAUITextColor
        
        // Upload image view
        uploadImageView.layer.cornerRadius = 6
        uploadImageView.clipsToBounds = true
        uploadImageView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        uploadImageView.kf.indicatorType = .activity
        
        // Profile image view
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        profileImageView.kf.indicatorType = .activity
        
        // Citizen view
        citizenView.layer.cornerRadius = 6
        citizenView.clipsToBounds = true
        
        // Citizen name label
        citizenNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Citizen ID label
        citizenIdLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Arrow image view
        arrowImageView.image = KMAUIConstants.shared.disclosureArrow.withRenderingMode(.alwaysTemplate)
        arrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Divide line view
        divideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Reject button
        rejectButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        rejectButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
        rejectButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        rejectButton.layer.cornerRadius = 8
        rejectButton.clipsToBounds = true
        rejectButton.setTitle("", for: .normal)
        
        // Approve button
        approveButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        approveButton.setTitleColor(UIColor.white, for: .normal)
        approveButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        approveButton.layer.cornerRadius = 8
        approveButton.clipsToBounds = true
        approveButton.setTitle("", for: .normal)
        
        // Status label
        statusLabel.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        statusLabel.text = "Rejected or Approved"
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // Hide buttons
        rejectButton.alpha = 0
        approveButton.alpha = 0
        statusLabel.alpha = 0
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Title label
        titleLabel.text = "Upload by citizens"
        
        // Info label
        infoLabel.attributedText = KMAUIUtilities.shared.highlightUnderline(words: ["Sub land \(subLand.subLandId)"], in: "Attachment for Sub land \(subLand.subLandId) was uploaded by \(citizen.fullName)", fontSize: infoLabel.font.pointSize)
        
        // Upload image view
        if let documentURL = URL(string: document.previewURL) {
            uploadImageView.kf.setImage(with: documentURL)
        }
        
        // Citizen name label
        citizenNameLabel.text = citizen.fullName
        
        // Citizen ID label
        citizenIdLabel.text = "National ID: \(citizen.objectId)"
        
        // Citizen image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // Load profile image
        if let url = URL(string: citizen.profileImage) {
            profileImageView.kf.setImage(with: url)
        }
        
        // Action button
        rejectButton.setTitle("Reject attachment", for: .normal)
        approveButton.setTitle("Approve attachment", for: .normal)
        
        // Status
        setupStatus()
    }
    
    @objc public func tapLabel(gesture: UITapGestureRecognizer) {
        let openRange = NSRange(location: 18, length: "Sub land \(subLand.subLandId)".count + 2)
        let tapLocation = gesture.location(in: infoLabel)
        let index = infoLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)

        if KMAUIUtilities.shared.checkRange(openRange, contain: index) == true {
            subLandCallback?(true)
        }
    }
    
    /**
     Setup status
     */
    
    public func setupStatus() {
        if document.status.isEmpty {
            // No action performed
            rejectButton.alpha = 1
            approveButton.alpha = 1
            statusLabel.alpha = 0
        } else {
            // Action performed
            rejectButton.alpha = 0
            approveButton.alpha = 0
            statusLabel.alpha = 1
            statusLabel.text = "Attachment \(document.status)"
            
            if document.status == "approved" {
                statusLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
            } else if document.status == "rejected" {
                statusLabel.textColor = KMAUIConstants.shared.KMAUIRedProgressColor
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction public func citizenButtonPressed(_ sender: Any) {
        citizenCallback?(true)
        citizenView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
        // Change the selection color back
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.citizenView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        }
    }
    
    @IBAction public func shareButtonPressed(_ sender: Any) {
        shareCallback?(true)
    }
    
    @IBAction public func rejectButtonPressed(_ sender: Any) {
        KMAUIUtilities.shared.startLoading(title: "Rejecting...")
        change(status: "rejected")
    }
    
    @IBAction public func approveButtonPressed(_ sender: Any) {
        KMAUIUtilities.shared.startLoading(title: "Approving...")
        change(status: "approved")
    }
    
    func change(status: String) {
        KMAUIParse.shared.updateDocumentStatus(subLandId: subLand.objectId, documentId: document.objectId, status: "approved") { (done) in
            self.document.status = status
            self.setupStatus()
            // Send a push notification to user with document name and status
            KMAUIParse.shared.notifyUser(subLand: self.subLand, type: "uploaded", status: status, documentName: self.document.name, citizenId: self.citizen.objectId)
        }
    }
    
    @IBAction func uploadImageButtonPressed(_ sender: Any) {
        KMAUIUtilities.shared.quicklookPreview(urlString: document.fileURL, fileName: document.name, uniqueId: document.objectId) { (previewItemValue) in
            self.previewItem = previewItemValue
            // Display file
            let previewController = QLPreviewController()
            previewController.dataSource = self
            KMAUIUtilities.shared.displayAlert(viewController: previewController)
        }
    }
}

// MARK: - QLPreviewController Datasource

extension KMAUINotificationDocumentTableViewCell: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}
