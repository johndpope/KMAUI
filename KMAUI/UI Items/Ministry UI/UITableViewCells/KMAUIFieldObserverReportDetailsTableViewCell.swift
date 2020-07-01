//
//  KMAUIFieldObserverReportDetailsTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 24.06.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIFieldObserverReportDetailsTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var attachmentsView: KMAUIImagesPreviewView!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var infoViewTop: NSLayoutConstraint!
    @IBOutlet public weak var ownerLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var ownerValueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var divideLine1: UIView!
    @IBOutlet public weak var ownerView: UIView!
    
    // MARK: - Variables
    public static let id = "KMAUIFieldObserverReportDetailsTableViewCell"
    public var attachmentCallback: ((Bool) -> Void)?
    public var citizenCallback: ((String) -> Void)?
    public var trespassCase = KMAUITrespassCaseStruct() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background virew
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        titleLabel.text = "Field observer report"
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Attachments view
        attachmentsView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        attachmentsView.layer.cornerRadius = 8
        attachmentsView.clipsToBounds = true
        
        // Divide line
        divideLine1.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Citizen views
        ownerView.layer.cornerRadius = 8
        ownerView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Citizen labels
        ownerLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        ownerValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Info label label
        infoLabel.text = trespassCase.fieldObserverReport
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        // Setup attachments
        attachmentsView.attachments = trespassCase.fieldObserverUploadsItems
        
        // Callback for attachment actions
        attachmentsView.viewAttachmentsAction = { action in
            self.attachmentCallback?(true)
        }
        
        // Setup owner and violator
        if !trespassCase.owner.fullName.isEmpty {
            ownerValueLabel.text = trespassCase.owner.fullName
            ownerView.alpha = 1
            divideLine1.alpha = 1
            infoViewTop.constant = 12
        } else {
            ownerView.alpha = 0
            divideLine1.alpha = 0
            infoViewTop.constant = -45
        }
        
        // Layout subviews
        self.layoutSubviews()
    }
    
    /// MARK: - Actions
    
    @IBAction public func ownerButtonPressed(_ sender: Any) {
        ownerView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
        citizenCallback?("owner")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.ownerView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        }
    }
}
