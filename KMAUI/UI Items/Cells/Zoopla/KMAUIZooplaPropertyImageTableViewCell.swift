//
//  KMAUIZooplaPropertyImageTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.12.2019.
//  Copyright © 2019 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIZooplaPropertyImageTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var propertyImageView: UIImageView!
    @IBOutlet public weak var captionLabel: KMAUIInfoLabel!
    
    // MARK: - Variables
    public var imageString = ""
    public var captionString = ""
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Adjusting the UI for a caption label
        captionLabel.backgroundColor = KMAUIConstants.shared.KMATurquoiseColor
        captionLabel.textColor = UIColor.white
        captionLabel.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        captionLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner]
        captionLabel.clipsToBounds = true

        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Round corners for image view
        propertyImageView.tintColor = KMAUIConstants.shared.KMALineGray
        propertyImageView.image = KMAUIConstants.shared.propertyIcon.withRenderingMode(.alwaysTemplate)
        propertyImageView.contentMode = .center
        
        propertyImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        
        if let imageURL = URL(string: imageString) {
            propertyImageView.kf.setImage(with: imageURL) { result in
                switch result {
                case .success(let value):
                    self.propertyImageView.image = value.image
                    self.propertyImageView.contentMode = .scaleAspectFill
                case .failure(let error):
                    print(error) // The error happens
                }
            }
        }
        
        if !captionString.isEmpty {
            captionLabel.text = "  \(captionString)  "
        } else {
            captionLabel.text = ""
        }
    }
}
