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
    @IBOutlet public weak var uploadImageViewHeight: NSLayoutConstraint!
    @IBOutlet public weak var imagesPreviewView: KMAUIImagesPreviewView!
    @IBOutlet public weak var uploadImageButton: UIButton!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var arrowImageView: UIImageView!
    @IBOutlet public weak var citizenView: UIView!
    @IBOutlet public weak var citizenViewTop: NSLayoutConstraint!
    @IBOutlet public weak var citizenNameLabel: UILabel!
    @IBOutlet public weak var citizenIdLabel: UILabel!
    @IBOutlet public weak var citizenButton: UIButton!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var rejectButton: UIButton!
    @IBOutlet public weak var approveButton: UIButton!
    @IBOutlet public weak var statusLabel: UILabel!
    @IBOutlet public weak var tableView: UITableView!
    
    // MARK: - Variables
    public var rows = [KMADocumentData]()
    public var type = ""
    public var lotteryResultStatus = ""
    public var lotteryResultId = ""
    public var subLand = KMAUISubLandStruct()
    public var citizen = KMAPerson()
    public var document = KMADocumentData() {
        didSet {
            setupCell()
        }
    }
    public lazy var previewItem = NSURL()
    // Callbacks
    public var shareCallback: ((Bool) -> Void)?
    public var citizenCallback: ((Bool) -> Void)?
    public var subLandCallback: ((Bool) -> Void)?
    public var viewAttachmentsAction: ((Bool) -> Void)?
    public var actionCallback: ((String) -> Void)?
    
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
        
        // Images preview view
        imagesPreviewView.layer.cornerRadius = 6
        imagesPreviewView.clipsToBounds = true
        
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
        
        // Open attachments callback
        imagesPreviewView.viewAttachmentsAction = { action in
            self.viewAttachmentsAction?(true)
        }
        
        // Register collection view cells
        let bundle = Bundle(for: KMAUIRecognizedTableViewCell.self)
        tableView.register(UINib(nibName: KMAUIRecognizedTableViewCell.id, bundle: bundle), forCellReuseIdentifier: KMAUIRecognizedTableViewCell.id)
        tableView.register(UINib(nibName: KMAUISubLandIdTableViewCell.id, bundle: bundle), forCellReuseIdentifier: KMAUISubLandIdTableViewCell.id)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        uploadImageView.alpha = 0
        imagesPreviewView.alpha = 0
        uploadImageButton.alpha = 0
        tableView.alpha = 0
        citizenViewTop.constant = 16
        
        // Info label
        if type == "documentUploaded" {
            // Title label
            titleLabel.text = "Land document uploaded by citizen"
            
            // Info label
            infoLabel.attributedText = KMAUIUtilities.shared.highlightUnderline(words: ["Sub land \(subLand.subLandId)"], in: "The ownership document for Sub land \(subLand.subLandId) was uploaded by \(citizen.fullName)", fontSize: infoLabel.font.pointSize)
            // Action button
            rejectButton.setTitle("Reject ownership", for: .normal)
            approveButton.setTitle("Approve ownership", for: .normal)
            
            print("Sub land recognized details: \(subLand.recognizedDetails)")
            var rowsFound = false
            
            if !subLand.recognizedDetails.isEmpty {
                let dataDict = KMAUIUtilities.shared.jsonToDictionary(jsonText: subLand.recognizedDetails)
                
                if let recognizedDict = dataDict["recognizedDetails"] as? [String: AnyObject] {
                    tableView.dataSource = self
                    tableView.delegate = self
                    tableView.reloadData()
                    // Setup the height
                    
                    rows = [KMADocumentData]()
                    
                    let orderedKeys = ["Area ID", "Area Name", "Citizen ID", "Citizen Name"]
                    
                    for key in orderedKeys {
                        var documentItem = KMADocumentData()
                        documentItem.type = key.replacingOccurrences(of: "_", with: " ").capitalized.replacingOccurrences(of: " Id", with: " ID")
                        
                        if let value = recognizedDict[key] as? String {
                            documentItem.name = value
                        } else {
                            documentItem.name = "Null"
                        }
                        
                        rows.append(documentItem)
                    }
                    
                    rowsFound = true
                    
                    uploadImageView.alpha = 1
                    uploadImageButton.alpha = 1
                    tableView.alpha = 1
                    
                    uploadImageViewHeight.constant = 54 * CGFloat(rows.count + 1)
                    
                    // Show the image
                    if let documentURL = URL(string: document.previewURL) {
                        uploadImageView.kf.indicatorType = .activity
                        uploadImageView.kf.setImage(with: documentURL)
                    }
                }
                
                if !rowsFound {
                    imagesPreviewView.alpha = 1
                    subLand.subLandImagesArray = [document]
                    imagesPreviewView.subLand = subLand
                }
            }
        } else if type == "subLandDocumentAdded" {
            // Title label
            titleLabel.text = "Upload by citizen"
            
            // Info label
            infoLabel.attributedText = KMAUIUtilities.shared.highlightUnderline(words: ["Sub land \(subLand.subLandId)"], in: "Attachment for Sub land \(subLand.subLandId) was uploaded by \(citizen.fullName)", fontSize: infoLabel.font.pointSize)
            
            // Action button
            rejectButton.setTitle("Reject attachment", for: .normal)
            approveButton.setTitle("Approve attachment", for: .normal)
            imagesPreviewView.alpha = 1
            subLand.subLandImagesArray = [document]
            imagesPreviewView.subLand = subLand
            uploadImageViewHeight.constant = 320
        } else if type == "lotteryResultUpdate" {
            // Title label
            
            titleLabel.text = "New Sub land status"
            // Info label
            infoLabel.attributedText = KMAUIUtilities.shared.highlightUnderline(words: ["Sub land \(subLand.subLandId)"], in: "The Sub land \(subLand.subLandId) status was changed to \(lotteryResultStatus) by \(citizen.fullName)", fontSize: infoLabel.font.pointSize)
            
            // Images preview view
            imagesPreviewView.alpha = 1
            imagesPreviewView.subLand = subLand
            uploadImageViewHeight.constant = 320
            
            if subLand.subLandImagesArray.isEmpty {
                uploadImageView.alpha = 0
                uploadImageButton.alpha = 0
                imagesPreviewView.alpha = 0
                uploadImageViewHeight.constant = 0
                citizenViewTop.constant = 0
            }
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
        
        // Status
        setupStatus()
    }
    
    @objc public func tapLabel(gesture: UITapGestureRecognizer) {
        var start = 18
        
        if type == "documentUploaded" {
            start = 30
        } else if type == "lotteryResultUpdate" {
            start = 4
        }
        
        let openRange = NSRange(location: start, length: "Sub land \(subLand.subLandId)".count + 2)
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
        var statusDetermined = false
        
        if type == "documentUploaded" {
            statusDetermined = lotteryResultStatus != "awaiting verification"
            
            if statusDetermined {
                if lotteryResultStatus == "declined" {
                    statusLabel.text = "Ownership rejected"
                    statusLabel.textColor = KMAUIConstants.shared.KMAUIRedProgressColor
                } else {
                    statusLabel.text = "Ownership approved"
                    statusLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
                }
            }
        } else if type == "subLandDocumentAdded" {
            statusDetermined = !document.status.isEmpty, document.status != "pending"
            
            if statusDetermined {
                statusLabel.text = "Attachment \(document.status)"
                
                if document.status == "approved" {
                    statusLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
                } else if document.status == "rejected" {
                    statusLabel.textColor = KMAUIConstants.shared.KMAUIRedProgressColor
                }
            }
        }
        
        if !statusDetermined {
            // No action performed
            rejectButton.alpha = 1
            approveButton.alpha = 1
            statusLabel.alpha = 0
        } else {
            // Action performed
            rejectButton.alpha = 0
            approveButton.alpha = 0
            statusLabel.alpha = 1
        }
        
        if type == "lotteryResultUpdate" {
            rejectButton.alpha = 0
            approveButton.alpha = 0
            statusLabel.alpha = 0
            divideLineView.alpha = 0
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
        actionCallback?("rejected")
    }
    
    @IBAction public func approveButtonPressed(_ sender: Any) {
        actionCallback?("approved")
    }
    
    public func rejectAction(comment: String? = nil) {
        KMAUIUtilities.shared.startLoading(title: "Rejecting...")
        change(status: "rejected", comment: comment)
    }
    
    public func approveAction(comment: String? = nil) {
        KMAUIUtilities.shared.startLoading(title: "Approving...")
        change(status: "approved", comment: comment)
    }
    
    func change(status: String, comment: String? = nil) {
        if type == "documentUploaded" {
            var newStatus = ""
            
            if status == "rejected" {
                print("New status is `declined`")
                newStatus = "declined"
            } else {
                if subLand.extraPrice > 0 {
                    print("New status is `awaiting payment`")
                    newStatus = "awaiting payment"
                } else {
                    print("New status is `confirmed`")
                    newStatus = "confirmed"
                }
            }
            
            KMAUIParse.shared.landOwnership(lotteryResultId: lotteryResultId, status: newStatus, comment: comment, subLand: subLand, document: document) { (success) in
                self.lotteryResultStatus = newStatus
                self.setupStatus()
                // Notify user about the changes
                KMAUIParse.shared.notifyUser(subLand: self.subLand, type: "ownership", status: status, documentName: self.document.name, citizenId: self.citizen.objectId, comment: comment)
            }
        } else if type == "subLandDocumentAdded" {
            KMAUIParse.shared.updateDocumentStatus(subLandId: subLand.objectId, documentId: document.objectId, status: status, comment: comment, subLand: subLand) { (done) in
                self.document.status = status
                self.setupStatus()
                // Send a push notification to user with document name and status
                KMAUIParse.shared.notifyUser(subLand: self.subLand, type: "uploaded", status: status, documentName: self.document.name, citizenId: self.citizen.objectId, comment: comment)
            }
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

// MARK: - UITableView data source and delegate methods

extension KMAUINotificationDocumentTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count + 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let subLandCell = tableView.dequeueReusableCell(withIdentifier: KMAUISubLandIdTableViewCell.id) as? KMAUISubLandIdTableViewCell {
                subLandCell.titleLabel.text = "Land ID \(subLand.subLandId)"
                subLandCell.infoLabel.text = "\(subLand.regionName) region"
                
                return subLandCell
            }
        } else if indexPath.row > 0 {
            // Data cells
            if let cell = tableView.dequeueReusableCell(withIdentifier: KMAUIRecognizedTableViewCell.id) as? KMAUIRecognizedTableViewCell {
                if rows.isEmpty {
                    cell.nameLabel.text = "No data recognized."
                    cell.valueLabel.text = ""
                } else {
                    let row = rows[indexPath.row - 1]
                    cell.nameLabel.text = row.type
                    cell.valueLabel.text = row.name
                    let backgroundView = UIView()
                    backgroundView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
                    cell.selectedBackgroundView = backgroundView
                }
                
                cell.accessoryType = .none
                
                return cell
            }
        }
        
        return KMAUIUtilities.shared.getEmptyCell()
    }
}
