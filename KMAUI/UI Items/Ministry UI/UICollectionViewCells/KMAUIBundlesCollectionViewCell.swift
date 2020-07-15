//
//  KMAUIBundlesCollectionViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 14.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIBundlesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var logoBgView: UIView!
    @IBOutlet public weak var logoImageView: UIImageView!
    @IBOutlet public weak var logoImageViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public  weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIBundlesCollectionViewCell"
    public var isCellSelected = false
    public var bundle = KMAUI9x9Bundle() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 8
        
        // Logo image view
        logoBgView.layer.cornerRadius = 8
        logoBgView.clipsToBounds = true
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Info label
        infoLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
    }
    
    public func setupCell() {
        // Title label
        titleLabel.text = bundle.name
        
        // Info label
        var infoText = bundle.description
        
        if !bundle.comment.isEmpty {
            if infoText.isEmpty {
                infoText = bundle.comment
            } else {
                infoText += "\n" + bundle.comment
            }
        }
        
        infoLabel.text = infoText
        
        // Logo image view
        if bundle.icon != "string", bundle.icon != "fa-adjust", !bundle.icon.isEmpty, let faImage = UIImage.fontAwesomeIcon(code: bundle.icon, style: .regular, textColor: KMAUIConstants.shared.KMAUIBlueDarkColorBarTint, size: CGSize(width: 30, height: 30)) {
            logoImageView.image = faImage.withRenderingMode(.alwaysTemplate)
            logoImageViewWidth.constant = 30
            logoImageView.contentMode = .scaleAspectFit
        } else {
            logoImageView.image = KMAUIConstants.shared.headerSubLandIcon.withRenderingMode(.alwaysTemplate)
            logoImageViewWidth.constant = 40
            logoImageView.contentMode = .scaleAspectFit
        }

        // Setup colors
        if isCellSelected {
            // Background view color
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
            // Logo image view
            logoBgView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            logoImageView.tintColor = UIColor.white
            // Labels text color
            titleLabel.textColor = UIColor.white
            infoLabel.textColor = UIColor.white
        } else {
            // Background view color
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            // Logo image view
            logoBgView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint.withAlphaComponent(0.12)
            logoImageView.tintColor = KMAUIConstants.shared.KMAUIBlueDarkColorBarTint
            // Labels text color
            titleLabel.textColor = KMAUIConstants.shared.KMAUITextColor
            infoLabel.textColor = KMAUIConstants.shared.KMAUITextColor
        }
    }
}
