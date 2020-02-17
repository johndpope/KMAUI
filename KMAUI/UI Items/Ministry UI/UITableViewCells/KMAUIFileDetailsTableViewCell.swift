//
//  KMAUIFileDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Lightbox

public class KMAUIFileDetailsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: KMAUIInfoLabel!
    @IBOutlet public weak var usernameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIInfoLabel!
    @IBOutlet public weak var fileImageView: UIImageView!
    @IBOutlet public weak var playButton: UIButton!
    @IBOutlet public weak var containerViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var containerViewTop: NSLayoutConstraint!
    @IBOutlet public weak var containerView: UIView!
    @IBOutlet public weak var filenameLabel: KMAUIBoldTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIFileDetailsTableViewCell"
    public var uploadItem = KMAUIUploadItem() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Container view
        containerView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        containerView.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
//        print("\nSetup cell with item:\n\(uploadItem)\n")
        
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
                    self.profileImageView.layer.cornerRadius = 22
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
        
        // Citizen name
        nameLabel.text = uploadItem.citizenName
        
        // Username
        usernameLabel.text = uploadItem.citizenUsername.formatUsername()
        
        // Upload name
        filenameLabel.text = uploadItem.uploadName
        
        // Upload date
        dateLabel.text = KMAUIUtilities.shared.dateTime(date: uploadItem.uploadDate) //KMAUIUtilities.shared.formatStringShort(date: uploadItem.uploadDate, numOnly: true)
        
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
        
        if uploadItem.isVideo {
            playButton.setImage(KMAUIConstants.shared.playIcon, for: .normal)
        } else {
            playButton.setImage(UIImage(), for: .normal)
        }
        
        if UIDevice.current.orientation.isLandscape {
//            print("LANDSCAPE")
            containerViewLeft.constant = 216
            containerViewTop.constant = 12
        } else {
//            print("PORTRAIT")
            containerViewLeft.constant = 12
            containerViewTop.constant = 68
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func playButtonPressed(_ sender: Any) {
        // Open preview or image
        previewImages()
    }
    
    // MARK: - Image / Video preview
    
    public func previewImages() {
        var images = [LightboxImage]()
        
        if uploadItem.isVideo {
            if let imageURL = URL(string: uploadItem.previewImage), let videoURL = URL(string: uploadItem.uploadImage) {
                images.append(LightboxImage(imageURL: imageURL, text: uploadItem.uploadName, videoURL: videoURL))
            }
        } else {
            if let imageURL = URL(string: uploadItem.uploadImage) {
                images.append(LightboxImage(imageURL: imageURL, text: uploadItem.uploadName))
            }
        }
        
        if !images.isEmpty {
            // Add images for the preview and setup UI
            let lightboxController = LightboxController(images: images, startIndex: 0)
            lightboxController.modalPresentationStyle = .fullScreen
            lightboxController.dynamicBackground = true
            // Present your controller.
            KMAUIConstants.shared.lightboxVisible = true
            KMAUIUtilities.shared.displayAlert(viewController: lightboxController)
        }
    }
}
