//
//  KMAUIFileDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 14.02.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import QuickLook

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
    @IBOutlet public weak var containerViewBottom: NSLayoutConstraint!
    @IBOutlet public weak var containerView: UIView!
    @IBOutlet public weak var uploadInfoView: UIView!
    @IBOutlet public weak var filenameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var filesTableView: UITableView!
    @IBOutlet public weak var userButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIFileDetailsTableViewCell"
    public var userCallback: ((Bool) -> Void)?
    public var uploadItem = KMAUIUploadItem() {
        didSet {
            setupCell()
        }
    }
    public lazy var previewItem = NSURL()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Corner radius for image
        fileImageView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        fileImageView.clipsToBounds = true
        
        // Corner radius for view
        uploadInfoView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        uploadInfoView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        uploadInfoView.clipsToBounds = true

        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Citizen image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
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
        dateLabel.text = KMAUIUtilities.shared.dateTime(date: uploadItem.uploadDate)
        
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
        
        // Other files
        filesTableView.dataSource = self
        filesTableView.delegate = self
        filesTableView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
        filesTableView.clipsToBounds = true
        
        filesTableView.register(UINib(nibName: KMAUINameTitleTableViewCell.id, bundle: Bundle(identifier: "org.cocoapods.KMAUI")), forCellReuseIdentifier: KMAUINameTitleTableViewCell.id)
        filesTableView.register(UINib(nibName: KMAUIFileTableViewCell.id, bundle: Bundle(identifier: "org.cocoapods.KMAUI")), forCellReuseIdentifier: KMAUIFileTableViewCell.id)
        
        if UIDevice.current.orientation.isLandscape {
            containerViewLeft.constant = 236
            containerViewTop.constant = 12
            // Show the files tableView
            filesTableView.alpha = 1
        } else {
            containerViewLeft.constant = 12
            containerViewTop.constant = 68
            // Hide the files tableView
            filesTableView.alpha = 0
        }
    }
    
    // MARK: - IBActions
    
    @IBAction public func playButtonPressed(_ sender: Any) {
        // Open preview or image
        previewImages(index: 0)
    }

    @IBAction func userButtonPressed(_ sender: Any) {
        userCallback?(true)
    }
    
    // MARK: - Image / Video preview
    
    public func previewImages(index: Int) {
        var fileURLs = [String]()
        var fileTitles = [String]()
        
        if let _ = URL(string: uploadItem.uploadImage) {
            fileURLs.append(uploadItem.uploadImage)
            fileTitles.append(uploadItem.uploadName)
        }
        
        for item in uploadItem.uploadFiles {
            if let _ = URL(string: item.uploadImage) {
                fileURLs.append(item.uploadImage)
                fileTitles.append(item.uploadName)
            }
        }
        
        if index < fileURLs.count {
            let url = fileURLs[index]
            let name = fileTitles[index]
                        
            KMAUIUtilities.shared.quicklookPreview(urlString: url, fileName: name, uniqueId: uploadItem.uploadId) { (previewItemValue) in
                self.previewItem = previewItemValue
                // Display file
                let previewController = QLPreviewController()
                previewController.dataSource = self
                // Present your controller.
                KMAUIConstants.shared.popupOpened = true
                KMAUIUtilities.shared.displayAlert(viewController: previewController)
            }
        }
    }
}

extension KMAUIFileDetailsTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + uploadItem.uploadFiles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0, let descriptionCell = tableView.dequeueReusableCell(withIdentifier: KMAUINameTitleTableViewCell.id) as? KMAUINameTitleTableViewCell {
            descriptionCell.isFirst = true
            descriptionCell.uploadDescription = uploadItem.uploadDescription
            
            return descriptionCell
        } else if let fileCell = tableView.dequeueReusableCell(withIdentifier: KMAUIFileTableViewCell.id) as? KMAUIFileTableViewCell {
            fileCell.item = uploadItem.uploadFiles[indexPath.row - 1]
            
            return fileCell
        }
        
        return KMAUIUtilities.shared.getEmptyCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            previewImages(index: indexPath.row)
            
            // Give a small delay before deselect
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

// MARK: - QLPreviewController Datasource

extension KMAUIFileDetailsTableViewCell: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}
