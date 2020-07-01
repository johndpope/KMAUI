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
    @IBOutlet public weak var ownerLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var ownerValueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var divideLine1: UIView!
    @IBOutlet public weak var violatorLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var violatorValueLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var divideLine2: UIView!
    @IBOutlet public weak var ownerView: UIView!
    @IBOutlet public weak var violatorView: UIView!
    
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
        
        // Divide lines
        divideLine1.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        divideLine2.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Citizen views
        ownerView.layer.cornerRadius = 8
        ownerView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        violatorView.layer.cornerRadius = 8
        violatorView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Citizen labels
        ownerLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        ownerValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        violatorLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        violatorValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
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
        ownerValueLabel.text = trespassCase.owner.fullName
        
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
    
    @IBAction public func violatorButtonPressed(_ sender: Any) {
        violatorView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
        citizenCallback?("violator")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.violatorView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        }
    }
}
