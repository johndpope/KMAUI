//
//  KMAUIViewAttachmentsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 08.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIViewAttachmentsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var paperclipButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIViewAttachmentsTableViewCell"
    public var callback: ((Bool) -> Void)?
    public var rowData = KMAUIRowData() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(19)
        
        // Paperclip button
        paperclipButton.layer.cornerRadius = 6
        paperclipButton.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
        paperclipButton.setImage(KMAUIConstants.shared.paperclipIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        paperclipButton.imageView?.tintColor = KMAUIConstants.shared.KMAUITextColor
        paperclipButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        titleLabel.text = rowData.rowName
    }
    
    @IBAction public func paperclipButtonPressed(_ sender: Any) {
        callback?(true)
    }
}
