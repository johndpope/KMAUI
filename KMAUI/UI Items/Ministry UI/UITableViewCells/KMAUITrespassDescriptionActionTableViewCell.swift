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
    @IBOutlet public weak var declineButtonBottom: NSLayoutConstraint!
    @IBOutlet public weak var decisionLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUITrespassDescriptionActionTableViewCell"
    public var type = ""
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
        
        // Decision label
        decisionLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        decisionLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        decisionLabel.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        decisionLabel.layer.cornerRadius = 8
        decisionLabel.clipsToBounds = true
        
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
        if type == "initialCheck" {
            // Title
            titleLabel.text = "Trespass description"
            // Description
            descriptionLabel.text = trespassCase.initialComment
            // Check status to hide the buttons
            if trespassCase.caseStatus == "Created" {
                // Show buttons
                declineButton.alpha = 1
                declineButton.setTitle("Decline case", for: .normal)
                approveButton.alpha = 1
                approveButton.setTitle("Approve case", for: .normal)
                declineButtonBottom.constant = 20
            } else {
                // Hide buttons
                declineButton.alpha = 0
                approveButton.alpha = 0
                declineButtonBottom.constant = -52
            }
            // Hide decision label
            decisionLabel.alpha = 0
        } else if type == "ownerPenalty" {
            // Title
            titleLabel.text = "Final decision"
            // We need to have the bottom button / label
            declineButtonBottom.constant = 20
            // No decision yet
            if trespassCase.trespassDecision.isEmpty {
                // Description
                descriptionLabel.text = "Please review the Field observer report to prepare the final decision.\nAs the violator is the land owner we can either close the case without a penalty or to request the land owner to pay a penalty."
                // Show buttons
                declineButton.alpha = 1
                declineButton.setTitle("Close the case", for: .normal)
                approveButton.alpha = 1
                approveButton.setTitle("Penalty for owner", for: .normal)
                // Hide decision label
                decisionLabel.alpha = 0
            }
            // Has decision
            if !trespassCase.trespassDecision.isEmpty {
                // Hide buttons
                declineButton.alpha = 0
                approveButton.alpha = 0
                // Show decision label
                decisionLabel.alpha = 1
                // Decision
                if trespassCase.trespassDecision == "noPenalty" {
                    decisionLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
                    decisionLabel.text = "Trespass case closed without a penalty"
                    descriptionLabel.text = "After reviwing the Field observer report the decision to close the Trespass case without the penalty was made. The case is now Resolved."
                } else if trespassCase.trespassDecision == "penalty" {
                    // Penalty decision
                    descriptionLabel.text = "After reviewing the Field observer report the decision to charge the land owner with the penalty was made."
                    // Status
                    if trespassCase.caseStatus == "Resolved" {
                        decisionLabel.textColor = KMAUIConstants.shared.KMAUIGreenProgressColor
                        decisionLabel.text = "Penalty payment received"
                    } else if trespassCase.caseStatus == "Awaiting penalty payment" {
                        decisionLabel.textColor = KMAUIConstants.shared.KMAUIYellowProgressColor
                        decisionLabel.text = "Penalty request send to the Land owner"
                    }
                }
            }
        }
        // Update the description label line offset
        descriptionLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
    }
}
