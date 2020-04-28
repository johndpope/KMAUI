//
//  KMAUISubLandImagesTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 16.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import QuickLook
import Kingfisher

public class KMAUISubLandImagesTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var collectionView: UICollectionView!
    @IBOutlet public weak var singleImageView: UIImageView!
    @IBOutlet public weak var singleImageButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandImagesTableViewCell"
    public var newItem = false
    public var images = [KMADocumentData]() {
        didSet {
            setupCell()
        }
    }
    public lazy var previewItem = NSURL()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Single image view
        singleImageView.layer.cornerRadius = 8
        singleImageView.clipsToBounds = true
        singleImageView.backgroundColor =  KMAUIConstants.shared.KMAUILightButtonColor
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupCell() {
        if images.count == 1 {
            // Show single image view / hide collectionView
            singleImageView.alpha = 1
            singleImageButton.alpha = 1
            collectionView.alpha = 0
            // Get the image url
            let imageObject = images[0]
            let previewURL = imageObject.previewURL
            // Show the image
            if let documentURL = URL(string: previewURL) {
                singleImageView.kf.indicatorType = .activity
                singleImageView.kf.setImage(with: documentURL)
            }
        } else {
            // Hide single image view / show collectionView
            singleImageView.alpha = 0
            singleImageButton.alpha = 0
            collectionView.alpha = 1
            // Register collection view cells
            let bundle = Bundle(for: KMAUISubLandImageCollectionViewCell.self)
            collectionView.register(UINib(nibName: KMAUISubLandImageCollectionViewCell.id, bundle: bundle), forCellWithReuseIdentifier: KMAUISubLandImageCollectionViewCell.id)
            
            let cellSize = CGSize(width: 240, height: 172)
            
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = cellSize
            layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            layout.minimumInteritemSpacing = 0
            collectionView.setCollectionViewLayout(layout, animated: false)
            
            // Propery horizontal collection view
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            
            if newItem {
                // Scroll to start
                collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)
            }
        }
    }
    
    // MARK: - Open the preview
    
    @IBAction func singleImageButtonPressed(_ sender: Any) {
        previewImages(index: 0)
    }
    
    // MARK: - Image / Video preview
    
    public func previewImages(index: Int) {
        let document = images[index]
        
        KMAUIUtilities.shared.quicklookPreview(urlString: document.fileURL, fileName: document.name, uniqueId: document.objectId) { (previewItemValue) in
            self.previewItem = previewItemValue
            // Display file
            let previewController = QLPreviewController()
            previewController.dataSource = self
            KMAUIUtilities.shared.displayAlert(viewController: previewController)
        }
    }
}

// MARK: - UICollectionView data source and delegate methods

extension KMAUISubLandImagesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: KMAUISubLandImageCollectionViewCell.id, for: indexPath) as? KMAUISubLandImageCollectionViewCell {
            imageCell.document = images[indexPath.row]
            
            return imageCell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        previewImages(index: indexPath.row)
    }
}

// MARK: - QLPreviewController Datasource

extension KMAUISubLandImagesTableViewCell: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}
