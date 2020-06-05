//
//  KMAUITitleDetailsViewTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUITitleDetailsViewTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var rightArrowImageViewRight: NSLayoutConstraint!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet public weak var infoButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUITitleDetailsViewTableViewCell"
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }
    public var callback: ((Bool) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicatorFull.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyTextColor
        
        // Title label
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .semibold) //KMAUIConstants.shared.KMAUIBoldFont.withSize(19)
        titleLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // Info label
        infoButton.titleLabel?.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        infoButton.setTitleColor(KMAUIConstants.shared.KMAUIGreyTextColor, for: .normal)
        
        // Selection style
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        titleLabel.text = rowData.rowName
        titleLabelTop.constant = 16
        infoButton.setTitle(rowData.rowValue, for: .normal)
        infoButton.isHidden = !rowData.visibility
        infoButton.isUserInteractionEnabled = true
        rightArrowImageView.isHidden = !rowData.visibility

        if rowData.visibility {
            rightArrowImageViewRight.constant = 16
        } else {
            rightArrowImageViewRight.constant = 0
        }
    }
    
    @IBAction public func infoButtonPressed(_ sender: Any) {
        callback?(true)
    }
}
