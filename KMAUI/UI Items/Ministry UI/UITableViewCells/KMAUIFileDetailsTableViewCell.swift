//
//  KMAUIFileDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIFileDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIInfoLabel!
    @IBOutlet public weak var fileImageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUIFileDetailsTableViewCell"
    public var uploadItem = KMAUIUploadItem() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        print("\nSetup cell with item:\n\(uploadItem)\n")
        
        // Citizen image
        profileImageView.image = KMAUIConstants.shared.profileIcon.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = KMAUIConstants.shared.KMALineGray
        profileImageView.alpha = 0.25
        profileImageView.layer.cornerRadius = 0
        
        if !uploadItem.citizenImage.isEmpty, let url = URL(string: uploadItem.citizenImage) {
            profileImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.profileImageView.image = value.image
                    self.profileImageView.alpha = 1
                    self.profileImageView.layer.cornerRadius = 20
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
        
        // Citizen name
        nameLabel.text = uploadItem.citizenName
        
        // Upload date
        dateLabel.text = KMAUIUtilities.shared.formatStringShort(date: uploadItem.uploadDate, numOnly: true)
        
        // Upload image
        fileImageView.image = KMAUIConstants.shared.placeholderUploadImageNoir
        fileImageView.alpha = 0.25
        
        var imageString = uploadItem.uploadImage
        
        if uploadItem.isVideo {
            imageString = uploadItem.previewImage
        }
        
        if !imageString.isEmpty, let url = URL(string: imageString) {
            fileImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.fileImageView.image = value.image
                    self.fileImageView.alpha = 1
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
    }
}
