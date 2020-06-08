//
//  KMAUIUploadFilesTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 16.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIUploadFilesTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var circleView: UIView!
    @IBOutlet public weak var cameraImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var infoLabel: UILabel!
    
    // MARK: - Variables
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }
    
    // MARK: - Variables
    public static let id = "KMAUIUploadFilesTableViewCell"

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // Circle view
        circleView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint.withAlphaComponent(0.7)
        circleView.layer.cornerRadius = 32
        circleView.clipsToBounds = true
        
        // Camera icon
        cameraImageView.image = KMAUIConstants.shared.cameraIcon.withRenderingMode(.alwaysTemplate)
        cameraImageView.tintColor = KMAUIConstants.shared.KMAUILightButtonColor
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(19)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(12)
        
        // No standard selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColorReverse
        }
    }
    
    public func setupCell() {
        titleLabel.text = rowData.rowName
        infoLabel.text = rowData.rowValue
        infoLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2)
        
        if rowData.rowName == "Set a location" {
            cameraImageView.image = KMAUIConstants.shared.pinIcon.withRenderingMode(.alwaysTemplate)
        } else {
            cameraImageView.image = KMAUIConstants.shared.cameraIcon.withRenderingMode(.alwaysTemplate)
        }
    }
}
