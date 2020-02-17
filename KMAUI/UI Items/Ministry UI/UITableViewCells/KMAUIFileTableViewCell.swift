//
//  KMAUIFileTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 17.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFileTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var itemImageView: UIImageView!
    @IBOutlet public weak var itemNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var itemTypeLabel: KMAUIInfoLabel!
    @IBOutlet public weak var selectionView: UIView!
    
    // MARK: - Variables
    public static let id = "KMAUIFileTableViewCell"
    public var item = KMAUIUploadItem() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Image view
        itemImageView.layer.cornerRadius = 22
        itemImageView.clipsToBounds = true
        itemImageView.kf.indicatorType = .activity
        
        // No selection required
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
            selectionView.alpha = 0.25
        } else {
            selectionView.alpha = 0.0
        }
    }
    
    public func setupCell() {
        // File name
        itemNameLabel.text = item.uploadName
        
        // File type
        if item.isVideo {
            itemTypeLabel.text = "Video"
        } else {
            itemTypeLabel.text = "Photo"
        }
        
        // File preview
        itemImageView.image = KMAUIConstants.shared.placeholderUploadImageNoir
        
        if let url = URL(string: item.previewImage) {
            itemImageView.kf.setImage(with: url)
        }
    }
}
