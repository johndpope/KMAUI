//
//  KMAUISubLandImageCollectionViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 16.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUISubLandImageCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandImageCollectionViewCell"
    
    // MARK: - Variables
    public var document = KMADocumentData() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // BgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // ImageView
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
    }

    public func setupCell() {
        // Get the image url
        let previewURL = document.previewURL
        // Show the image
        if let documentURL = URL(string: previewURL) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: documentURL)
        }
    }
}
