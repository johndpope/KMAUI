//
//  KMAUIFieldObserverReportTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 22.06.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIFieldObserverReportTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var prepareReportButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIFieldObserverReportTableViewCell"
    public var actionCallback: ((Bool) -> Void)?
    
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
        titleLabel.text = "Field observer report"
        
        // Prepare a report button
        prepareReportButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        prepareReportButton.setTitleColor(UIColor.white, for: .normal)
        prepareReportButton.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        prepareReportButton.layer.cornerRadius = 8
        prepareReportButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction public func prepareReportButtonPressed(_ sender: Any) {
        actionCallback?(true)
    }
}
