//
//  KMAUINoLotteriesTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 09.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUINoLotteriesTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUINoLotteriesTableViewCell"
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        
        // logo image view
        logoImageView.backgroundColor = UIColor.clear
        logoImageView.image = KMAUIConstants.shared.noLotteriesIcon
        logoImageView.layer.cornerRadius = 55
        logoImageView.clipsToBounds = true
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        titleLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        infoLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    public func setupCell() {
        titleLabel.text = rowData.rowName
        infoLabel.text = rowData.rowValue
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
    }
}
