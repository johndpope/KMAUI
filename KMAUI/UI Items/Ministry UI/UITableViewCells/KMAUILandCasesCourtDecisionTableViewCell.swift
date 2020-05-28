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
    @IBOutlet public weak var caseStatusLabel: UILabel!
    @IBOutlet public weak var judgeCommentLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUILandCasesCourtDecisionTableViewCell"
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
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
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
    }
}
