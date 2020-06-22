//
//  KMAUITrespassDescriptionActionTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 27.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUITrespassDescriptionActionTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var descriptionLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var approveButton: UIButton!
    @IBOutlet public weak var declineButton: UIButton!
    @IBOutlet weak var declineButtonBottom: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUITrespassDescriptionActionTableViewCell"
    public var actionCallback: ((Bool) -> Void)?
    public var trespassCase = KMAUITrespassCaseStruct() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background virew
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Description label
        descriptionLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Approve button
        approveButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        approveButton.setTitleColor(UIColor.white, for: .normal)
        approveButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        approveButton.layer.cornerRadius = 8
        approveButton.clipsToBounds = true
        
        // Decline button
        declineButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        declineButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal) // UIColor.black
        declineButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        declineButton.layer.cornerRadius = 8
        declineButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction public func approveButtonPressed(_ sender: Any) {
        approveButton.alpha = 0.75
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.approveButton.alpha = 1.0
        }
        
        actionCallback?(true)
    }
    
    @IBAction public func declineButtonPressed(_ sender: Any) {
        declineButton.alpha = 0.75
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.declineButton.alpha = 1.0
        }
        
        actionCallback?(false)
    }
    
    public func setupCell() {
        // Title
        titleLabel.text = "Trespass description"
        // Description
        descriptionLabel.text = trespassCase.initialComment
        descriptionLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        // Check status to hide the buttons
        if trespassCase.caseStatus == "Created" {
            // Show buttons
            declineButton.alpha = 1
            approveButton.alpha = 1
            declineButtonBottom.constant = 20
        } else {
            // Hide buttons
            declineButton.alpha = 0
            approveButton.alpha = 0
            declineButtonBottom.constant = -52
        }
    }
}
