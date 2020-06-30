//
//  KMAUIImagesPreviewView.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 29.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import QuickLook

public class KMAUIImagesPreviewView: UIView {

    // MARK: - IBOutlets
    @IBOutlet public var contentView: UIView!
    // Buttons
    @IBOutlet public weak var singleImageButton: UIButton!
    @IBOutlet public weak var twoOneImageButton: UIButton!
    @IBOutlet public weak var twoTwoImageButton: UIButton!
    @IBOutlet public weak var threeOneImageButton: UIButton!
    @IBOutlet public weak var threeTwoImageButton: UIButton!
    @IBOutlet public weak var threeThreeImageButton: UIButton!
    @IBOutlet public weak var threeThreeBgView: UIView!
    @IBOutlet public weak var threeThreeBgImageButton: UIButton!
    // Images
    @IBOutlet public weak var singleImageView: UIImageView!
    @IBOutlet public weak var twoOneImageView: UIImageView!
    @IBOutlet public weak var twoTwoImageView: UIImageView!
    @IBOutlet public weak var threeOneImageView: UIImageView!
    @IBOutlet public weak var threeTwoImageView: UIImageView!
    @IBOutlet public weak var threeThreeImageView: UIImageView!
    
    // MARK: - Variables
    public var subLand = KMAUISubLandStruct() {
        didSet {
            setupSubLand()
        }
    }
    public var attachments = [KMADocumentData]() {
        didSet {
            setupAttachments()
        }
    }
    public var imagesArray = [KMADocumentData]()
    public var viewAttachmentsAction: ((Bool) -> Void)?
    public lazy var previewItem = NSURL()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUIImagesPreviewView.self)
        bundle.loadNibNamed("KMAUIImagesPreviewView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // Borders for images
        borderFor(imageView: singleImageView)
        borderFor(imageView: twoOneImageView)
        borderFor(imageView: twoTwoImageView)
        borderFor(imageView: threeOneImageView)
        borderFor(imageView: threeTwoImageView)
        borderFor(imageView: threeThreeImageView)
    }
    
    func borderFor(imageView: UIImageView) {
        imageView.layer.borderColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2).cgColor
        imageView.layer.borderWidth = 1
    }
    
    // MARK: - Setup view
    
    /**
     Setup attachments
     */
    
    public func setupAttachments() {
        imagesArray = attachments
        setupImages()
    }
    
    /**
     Setup sub land attachments
     */
    
    public func setupSubLand() {
        imagesArray = subLand.subLandImagesArray
        setupImages()
    }
    
    /**
     Setup images
     */
    
    public func setupImages() {
        // Hide all buttons
        singleImageButton.alpha = 0
        twoOneImageButton.alpha = 0
        twoTwoImageButton.alpha = 0
        threeOneImageButton.alpha = 0
        threeTwoImageButton.alpha = 0
        threeThreeImageButton.alpha = 0
        threeThreeBgView.alpha = 0
        threeThreeBgImageButton.alpha = 0
        // Hide all images
        singleImageView.alpha = 0
        twoOneImageView.alpha = 0
        twoTwoImageView.alpha = 0
        threeOneImageView.alpha = 0
        threeTwoImageView.alpha = 0
        threeThreeImageView.alpha = 0
        // Review attachments
        threeThreeBgImageButton.layer.cornerRadius = 8
        threeThreeBgImageButton.clipsToBounds = true
        threeThreeBgImageButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(22)
        threeThreeBgImageButton.setTitleColor(KMAUIConstants.shared.KMAUIViewBgColorReverse, for: .normal)
        threeThreeBgView.layer.cornerRadius = 8
        threeThreeBgView.clipsToBounds = true
        threeThreeBgView.backgroundColor = KMAUIConstants.shared.KMAUITextColor
        // Bottom action buttons
        if !imagesArray.isEmpty {
            // Show the correct image for each view
            if imagesArray.count == 1 {
                // One large image
                showImage(button: singleImageButton, imageView: singleImageView, index: 0)
            } else if imagesArray.count == 2 {
                // Two same size images
                showImage(button: twoOneImageButton, imageView: twoOneImageView, index: 0)
                showImage(button: twoTwoImageButton, imageView: twoTwoImageView, index: 1)
            } else {
                // Three images or more
                showImage(button: threeOneImageButton, imageView: threeOneImageView, index: 0)
                showImage(button: threeTwoImageButton, imageView: threeTwoImageView, index: 1)
                showImage(button: threeThreeImageButton, imageView: threeThreeImageView, index: 2)
                
                if imagesArray.count > 3 {
                    threeThreeBgImageButton.alpha = 1.0
                    threeThreeBgView.alpha = 0.5
                    threeThreeBgImageButton.setTitle("+\(imagesArray.count - 3)", for: .normal)
                }
            }
        } else {
            print("No attachments found.")
            singleImageView.alpha = 1
            singleImageView.contentMode = .center
            singleImageView.image = KMAUIConstants.shared.lotteryPlaceholder
        }
    }
    
    /**
     Download and show image
     */
    
    public func showImage(button: UIButton, imageView: UIImageView, index: Int) {
        let document = imagesArray[index]
        button.alpha = 1
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        imageView.alpha = 1
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.contentMode = .scaleAspectFill
        
        // Show the image
        if let previewURL = URL(string: document.previewURL) {
            imageView.kf.setImage(with: previewURL)
        }
    }
    
    // MARK: - IBActions
        
    @IBAction func singleImageButtonPressed(_ sender: Any) {
        previewImages(index: 0)
    }
    
    @IBAction func twoOneImageButtonPressed(_ sender: Any) {
        previewImages(index: 0)
    }
    
    @IBAction func twoTwoImageButtonPressed(_ sender: Any) {
        previewImages(index: 1)
    }
    
    @IBAction func threeOneImageButtonPressed(_ sender: Any) {
        previewImages(index: 0)
    }
    
    @IBAction func threeTwoImageButtonPressed(_ sender: Any) {
        previewImages(index: 1)
    }
    
    @IBAction func threeThreeImageButtonPressed(_ sender: Any) {
        previewImages(index: 2)
    }
    
    @IBAction public func viewAttachmentsButtonPressed(_ sender: Any) {
        viewAttachmentsAction?(true)
    }
    
    // MARK: - Documents preview
    
    public func previewImages(index: Int) {
        let document = imagesArray[index]
        
        KMAUIUtilities.shared.quicklookPreview(urlString: document.fileURL, fileName: document.name, uniqueId: document.objectId) { (previewItemValue) in
            self.previewItem = previewItemValue
            // Display file
            let previewController = QLPreviewController()
            previewController.dataSource = self
            KMAUIUtilities.shared.displayAlert(viewController: previewController)
        }
    }
}

// MARK: - QLPreviewController Datasource

extension KMAUIImagesPreviewView: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}

