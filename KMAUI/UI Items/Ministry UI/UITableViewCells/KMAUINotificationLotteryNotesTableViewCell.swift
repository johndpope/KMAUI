//
//  KMAUINotificationLotteryNotesTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 12.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUINotificationLotteryNotesTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var shareButton: UIButton!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var arrowImageView: UIImageView!
    @IBOutlet public weak var citizenView: UIView!
    @IBOutlet public weak var citizenNameLabel: UILabel!
    @IBOutlet public weak var citizenIdLabel: UILabel!
    @IBOutlet public weak var citizenButton: UIButton!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var actionButton: UIButton!
    @IBOutlet public weak var statusLabel: UILabel!
    @IBOutlet public weak var notesView: UIView!
    @IBOutlet public weak var notesLabel: UILabel!
    @IBOutlet public weak var notesTextView: UITextView!
    @IBOutlet public weak var notesViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var notesViewTop: NSLayoutConstraint!
    
    // MARK: - Variables
    public var userType = ""
    public var citizenDepartment = KMADepartmentStruct()
    public var landPlan = KMAUILandPlanStruct() {
        didSet {
            setupCell()
        }
    }
    // Callbacks
    public var shareCallback: ((Bool) -> Void)?
    public var landPlanCallback: ((Bool) -> Void)?
    public var actionCallback: ((String) -> Void)?
    
    // MARK: - Variables
    public static let id = "KMAUINotificationLotteryNotesTableViewCell"
    
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
        actionButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        actionButton.setTitleColor(UIColor.white, for: .normal)
        actionButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        actionButton.layer.cornerRadius = 8
        actionButton.clipsToBounds = true
        actionButton.setTitle("", for: .normal)
        
        // Status label
        statusLabel.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        statusLabel.text = "Rejected or Approved"
        statusLabel.layer.cornerRadius = 8
        statusLabel.clipsToBounds = true
        statusLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // Notes view
        notesView.layer.cornerRadius = 8
        notesView.clipsToBounds = true
        notesView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
        
        // Notes label
        notesLabel.text = "Notes"
        notesLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        notesLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // Notes text view
        notesTextView.text = KMAUIConstants.shared.noNotesText
        notesTextView.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        notesTextView.backgroundColor = UIColor.clear
        notesTextView.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // Hide buttons
        actionButton.alpha = 0
        statusLabel.alpha = 0
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if landPlan.isDeleted {
            // Deleted mode
            setupDeletedMode()
        } else {
            // Notes mode
            setupNotesView()
        }
    }
    
    public func setupDeletedMode() {
        // Title label
        titleLabel.text = "Lottery deleted"
        
        // Lottery name
        citizenNameLabel.text = landPlan.landName
        
        // Lottery region
        citizenIdLabel.text = landPlan.regionName + " region"
        
        // Diagram image
        profileImageView.layer.cornerRadius = 8
        profileImageView.tintColor = UIColor.white
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        profileImageView.image = KMAUIConstants.shared.headerLotteryIcon.withRenderingMode(.alwaysTemplate)
        
        // Info label
        infoLabel.text = "This lottery \(landPlan.landName) is deleted."
        
        actionButton.alpha = 0
        statusLabel.alpha = 0
        
        notesView.alpha = 0
        notesView.backgroundColor = UIColor.red
        notesTextView.text = ""
        
        notesViewTop.constant = -44
        notesViewBottom.constant = -32
        
        divideLineView.alpha = 0
        arrowImageView.alpha = 0
    }
    
    public func setupNotesView() {
        // Title label
        titleLabel.text = "Lottery \(landPlan.lotteryStatus.rawValue.lowercased())"
        
        // Lottery name
        citizenNameLabel.text = landPlan.landName
        
        // Lottery region
        citizenIdLabel.text = landPlan.regionName + " region"
        
        // Diagram image
        profileImageView.layer.cornerRadius = 8
        profileImageView.tintColor = UIColor.white
        profileImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
        profileImageView.image = KMAUIConstants.shared.headerLotteryIcon.withRenderingMode(.alwaysTemplate)
        
        // Info label
        infoLabel.attributedText = KMAUIUtilities.shared.highlightUnderline(words: [landPlan.landName], in: "Please, check all the information on this lottery \(landPlan.landName) and review the current status.", fontSize: infoLabel.font.pointSize)
        
        // Notes
        if let comment = landPlan.comment.comment, !comment.isEmpty {
            notesTextView.text = comment
            notesTextView.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        } else {
            notesTextView.text = KMAUIConstants.shared.noNotesText
        }
        
        notesTextView.alpha = 1
        notesViewTop.constant = 44
        notesViewBottom.constant = 16
        divideLineView.alpha = 1
        arrowImageView.alpha = 1
        
        // No action performed
        if userType == "ministry" {
            actionButton.alpha = 0
            statusLabel.text = landPlan.lotteryStatus.rawValue
            statusLabel.textColor = KMAUIUtilities.shared.lotteryColor(status: landPlan.lotteryStatus)
            statusLabel.alpha = 1
        } else if userType == "department" {
            actionButton.alpha = 1
            statusLabel.alpha = 0
            
            if landPlan.lotteryStatus == .approvedToStart {
                actionButton.setTitle("Start the Lottery", for: .normal)
            } else if landPlan.lotteryStatus == .rejected {
                actionButton.setTitle("Transfer to \"on approvement\"", for: .normal)
            }
        }
    }
    
    @objc public func tapLabel(gesture: UITapGestureRecognizer) {
        let start = 60
        let openRange = NSRange(location: start, length: landPlan.landName.count + 6)
        let tapLocation = gesture.location(in: infoLabel)
        let index = infoLabel.indexOfAttributedTextCharacterAtPoint(point: tapLocation)
        
        if KMAUIUtilities.shared.checkRange(openRange, contain: index) == true {
            landPlanCallback?(true)
        }
    }
    
    // MARK: - IBActions
    
    @IBAction public func citizenButtonPressed(_ sender: Any) {
        if !landPlan.isDeleted {
            landPlanCallback?(true)
            citizenView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
            // Change the selection color back
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.citizenView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
            }
        }
    }
    
    @IBAction public func shareButtonPressed(_ sender: Any) {
        shareCallback?(true)
    }
    
    @IBAction public func actionButtonPressed(_ sender: Any) {
        if userType == "department" {
            if landPlan.lotteryStatus == .approvedToStart {
                KMAUIParse.shared.startLottery(lottery: landPlan) { (updatedLandPlan) in
                    self.landPlan.lotteryStatus = .finished
                    self.setupCell()
                    self.actionCallback?("reload")
                    // Notify the Ministry about the new lottery finished
                    KMAUIParse.shared.notifyMinistry(citizenDepartment: self.citizenDepartment, landPlanId: self.landPlan.landPlanId, landPlanName: self.landPlan.landName, regionId: self.landPlan.regionId, regionName: self.landPlan.regionName, lotteryStatus: "Finished")
                }
            } else if landPlan.lotteryStatus == .rejected {
                KMAUIUtilities.shared.startLoading(title: "Updating...")
                
                KMAUIParse.shared.changeLotteryStatus(to: .onApprovement, for: self.landPlan.landPlanId) { (success, error) in
                    // Stop loading and update the UI
                    KMAUIUtilities.shared.stopLoadingWith { (_) in
                        self.landPlan.lotteryStatus = .onApprovement
                        self.setupCell()
                        self.actionCallback?("reload")
                    }
                    // Notify the Ministry about the new lottery created and submitted in the `On approvement` status                    
                    KMAUIParse.shared.notifyMinistry(citizenDepartment: self.citizenDepartment, landPlanId: self.landPlan.landPlanId, landPlanName: self.landPlan.landName, regionId: self.landPlan.regionId, regionName: self.landPlan.regionName, lotteryStatus: "On approvement")
                }
            }
        }
    }
}
