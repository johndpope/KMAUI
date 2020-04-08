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
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    // MARK: - Variables
    public static let id = "KMAUITitleDetailsViewTableViewCell"
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicatorFull.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(19)
        titleLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        infoLabel.textColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // Selection style
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        titleLabel.text = rowData.rowName
        infoLabel.text = rowData.rowValue
    }
}
