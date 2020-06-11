//
//  KMAUIDecisionPlaceholderTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 08.06.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDecisionPlaceholderTableViewCell: UITableViewCell {
    
    // MARK: - IBoutlets
    @IBOutlet public weak var bgView: UIView!
    @IBOutlet public weak var placeholderLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIDecisionPlaceholderTableViewCell"
    public var type = "" {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        
        // Placeholder label
        placeholderLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        if type == "court" {
            placeholderLabel.text = "There is no court decision in this case yet."
        } else if type == "department" {
            placeholderLabel.text = "There is no Department of Urban Planning decision in this case yet."
        } else if type == "departments" {
            placeholderLabel.text = "There are no department decisions in this case yet."
        } else if type == "ministries" {
            placeholderLabel.text = "There are no ministry decisions in this case yet."
        }
    }
}
