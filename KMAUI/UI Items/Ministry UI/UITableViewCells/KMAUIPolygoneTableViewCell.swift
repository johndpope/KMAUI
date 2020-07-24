//
//  KMAUIGooglePlacePolygoneTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 06.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import QuickLook
import Kingfisher
import SafariServices

public class KMAUIPolygoneTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet weak var placeImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var placeImageViewLeft: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var locationLabel: KMAUIRegularTextLabel!
    @IBOutlet weak var locationLabelTop: NSLayoutConstraint!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var ratingLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var ratingLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var ratingLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var imagesView: KMAUIImagesPreviewView!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var rightArrowImageViewRight: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUIPolygoneTableViewCell"
    public var mapCallback: ((Bool) -> Void)?
    public var isFirst = false
    public var polygone = KMAUIPolygoneDataStruct() {
        didSet {
            setupPolygone()
        }
    }
    public var dataset = KMAUIParkLocation() {
        didSet {
            setupDataset()
        }
    }
    public var rowViews = [UIView]()
    public lazy var previewItem = NSURL()
    public var uniqueId = ""
    public var name = ""
    public var attachmentCallback: ((Bool) -> Void)?
    public var isClickable = false

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Rating label
        ratingLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
        ratingLabel.textColor = UIColor.white
        ratingLabel.layer.cornerRadius = 8
        ratingLabel.clipsToBounds = true
        
        // Location label
        locationLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
        // Images view
        imagesView.layer.cornerRadius = 8
        imagesView.clipsToBounds = true
        imagesView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
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
        if highlight, isClickable {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
            rightArrowImageView.tintColor = UIColor.white
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    func setupClickable() {
        // Check if clickable
        if isClickable {
            rightArrowImageViewRight.constant = 20
            rightArrowImageView.alpha = 1
        } else {
            rightArrowImageViewRight.constant = -12
            rightArrowImageView.alpha = 0
        }
    }
    
    public func setupPolygone() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 32
        } else {
            bgViewTop.constant = 0
        }
        
        // Setup clickable
        setupClickable()

        // Check type
        if polygone.polygoneType == "custom" {
            // Location label top offset
            locationLabelTop.constant = -4
            // Setup the custom polygone details
            setupCustomPolygone()
        } else if polygone.polygoneType == "googlePlace" {
            // Location label top offset
            locationLabelTop.constant = 6
            // Setup the Google Places details
            setupGooglePlacePolygone()
        }
    }

    func setupCustomPolygone() {
        // Title
        titleLabel.text = polygone.title
        name = polygone.title
        name = polygone.id
        
        // Id
        locationLabel.text = ""
        
        // Prepare rows
        var rows = [KMAUIRowData]()
        
        // Value
        if !polygone.value.isEmpty, polygone.type != "image" {
            rows.append(KMAUIRowData(rowName: "Value", rowValue: polygone.value))
        }
        
        if !polygone.valueArray.isEmpty {
            rows.append(KMAUIRowData(rowName: "Values", rowValue: ""))
            for item in polygone.valueArray {
                rows.append(KMAUIRowData(rowName: item.title, rowValue: item.value))
            }
        }
            
        // Type
        if !polygone.type.isEmpty {
            if polygone.type != "image", polygone.value.starts(with: "http") {
                rows.append(KMAUIRowData(rowName: "Type", rowValue: "Website"))
            } else {
                rows.append(KMAUIRowData(rowName: "Type", rowValue: polygone.type.capitalized))
            }
        }
        
        // Comment
        if !polygone.comment.isEmpty {
            rows.append(KMAUIRowData(rowName: "Comment", rowValue: polygone.comment))
        } else {
            rows.append(KMAUIRowData(rowName: "Comment", rowValue: "No comments"))
        }
        
        // Setup attachments
        if polygone.type == "image" {
            setupAttachments(urls: [polygone.value], name: polygone.title, id: polygone.title)
        } else {
            setupAttachments(urls: [""], name: "", id: "")
        }
        
        // Setup stack view
        setupStackView(rows: rows)
        
        // Hide rating
        ratingLabel.text = ""
        ratingLabelLeft.constant = 0
        ratingLabelWidth.constant = 0
    }
    
    func setupGooglePlacePolygone() {
        // Place name
        titleLabel.text = polygone.googlePlaceName
        name = polygone.googlePlaceName
        name = polygone.googlePlaceId

        // Rating
        if polygone.googlePlaceRating == 0 {
            ratingLabel.text = ""
            ratingLabelLeft.constant = 0
            ratingLabelWidth.constant = 0
        } else {
            ratingLabel.text = "\(polygone.googlePlaceRating)"
            ratingLabelLeft.constant = 12
            ratingLabelWidth.constant = 44
            
            if polygone.googlePlaceRating >= 4.5 {
                ratingLabel.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
            } else if polygone.googlePlaceRating >= 3 {
                ratingLabel.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
            } else {
                ratingLabel.backgroundColor = KMAUIConstants.shared.KMARedColor
            }
        }
        
        // Place address
        if !polygone.googlePlaceAddress.isEmpty {
            // Location label top offset
            locationLabel.text = polygone.googlePlaceAddress
        } else { // Location
            let latitude = CGFloat(Int(polygone.googlePlaceLocation.latitude * 1000000)) / 1000000
            let longitude = CGFloat(Int(polygone.googlePlaceLocation.longitude * 1000000)) / 1000000
            locationLabel.text = "\(latitude), \(longitude)"
        }
        
        // Setup attachments
        setupAttachments(urls: polygone.googlePlaceImages, name: polygone.googlePlaceName, id: polygone.googlePlaceId)
        
        // Prepare rows
        var rows = [KMAUIRowData]()
        
        // Business status
        if !polygone.googlePlaceBusinessStatus.isEmpty {
            rows.append(KMAUIRowData(rowName: "Business status", rowValue: polygone.googlePlaceBusinessStatus.lowercased().capitalized))
        }
        
        // Categores
        if !polygone.googlePlaceTypes.isEmpty {
            rows.append(KMAUIRowData(rowName: "Category", rowValue: polygone.googlePlaceTypesString))
        }
        
        // Open now
        if !polygone.googlePlaceOpenNow.isEmpty {
            rows.append(KMAUIRowData(rowName: "Open now", rowValue: polygone.googlePlaceOpenNow))
        }
        
        // Opening hours
        var hoursString = ""
        
        for daySchedule in polygone.googlePlaceOpeningHours {
            if !daySchedule.isEmpty {
                if hoursString.isEmpty {
                    hoursString = daySchedule
                } else {
                    hoursString += "\n" + daySchedule
                }
            }
        }
        
        if !hoursString.isEmpty {
            rows.append(KMAUIRowData(rowName: "Opening hours", rowValue: hoursString))
        }
        
        // Setup stack view
        setupStackView(rows: rows)
    }
    
    func setupAttachments(urls: [String], name: String, id: String) {
        var imageWidth: CGFloat = 240
        
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isPortrait {
            imageWidth = 160
        }
        
        placeImageViewWidth.constant = imageWidth
        // Setup the attachments array
        var attachments = [KMADocumentData]()
        
        if !polygone.googlePlaceImagesArray.isEmpty {
            attachments = polygone.googlePlaceImagesArray
        } else {
            let uniqueId = String(UUID().uuidString.suffix(8))
            
            for (index, url) in urls.enumerated() {
                if !url.isEmpty {
                    var attachment = KMADocumentData()
                    attachment.name = "Image \(index + 1).jpg"
                    attachment.objectId = uniqueId
                    // Setup urls
                    if url.starts(with: "http") {
                        attachment.previewURL = url
                        attachment.fileURL = url
                    } else if !url.isEmpty {
                        attachment.previewURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(url)&key=\(KMAUIConstants.shared.googlePlacesAPIKey)"
                        attachment.fileURL = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=\(url)&key=\(KMAUIConstants.shared.googlePlacesAPIKey)"
                    }
                    attachment.fileExtension = "JPG"
                    // Add an attachments
                    attachments.append(attachment)
                }
            }
        }
        
        // Setup images
        imagesView.attachments = attachments
        
        // Callback for attachment actions
        imagesView.viewAttachmentsAction = { action in
            self.attachmentCallback?(true)
        }
        
        // KMADocumentData
        if !attachments.isEmpty {
            placeImageViewLeft.constant = 20
            imagesView.alpha = 1
        } else {
            placeImageViewLeft.constant = -imageWidth
            imagesView.alpha = 0
        }
    }
    
    func setupDataset() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 32
        } else {
            bgViewTop.constant = 0
        }
        
        // Setup clickable
        setupClickable()
        
        // Title - Municipality name
        titleLabel.text = dataset.municipalityName
        
        // Location label top offset
        locationLabelTop.constant = 6
        
        // Hide rating label
        ratingLabel.text = ""
        ratingLabelLeft.constant = 0
        ratingLabelWidth.constant = 0
        
        // Location label top offset
        locationLabel.text = dataset.neighborName
        
        // Hide image view
        setupAttachments(urls: [""], name: "", id: "")
        
        // Prepare rows
        var rows = [KMAUIRowData]()
        
        // ID
        if dataset.id > 0 {
            rows.append(KMAUIRowData(rowName: "ID", rowValue: "\(dataset.id)"))
        }
        
        // Parcel name
        if !dataset.parcelName.isEmpty {
            rows.append(KMAUIRowData(rowName: "Parcel name", rowValue: dataset.parcelName))
        }

        // Parcel id
        if dataset.parcelId > 0 {
            rows.append(KMAUIRowData(rowName: "Parcel ID", rowValue: "\(dataset.parcelId)"))
        }
        
        // Parcel number
        if !dataset.parcelNumber.isEmpty {
            rows.append(KMAUIRowData(rowName: "Parcel number", rowValue: dataset.parcelNumber))
        }
        
        // Plan number
        if !dataset.planNumber.isEmpty {
            rows.append(KMAUIRowData(rowName: "Plan number", rowValue: dataset.planNumber))
        }
        
        // Checkin count
        if dataset.checkinCount > 0 {
            rows.append(KMAUIRowData(rowName: "Checkin count", rowValue: "\(dataset.checkinCount)"))
        }
        
        // Setup stack view
        setupStackView(rows: rows)
    }
    
    func setupStackView(rows: [KMAUIRowData]) {
        // Clear existing subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Clear the row views
        rowViews = [UIView]()
        
        // Prepare the rows
        for (index, row) in rows.enumerated() {
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fillProportionally
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 8
            
            itemView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
            itemView.isLayoutMarginsRelativeArrangement = true

            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = row.rowName
            rowNameLabel.numberOfLines = 0
            
            if row.rowName == "Values", row.rowValue.isEmpty {
                rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
            }
            
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 253), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.textAlignment = .right
            rowValueLabel.text = row.rowValue
            rowValueLabel.numberOfLines = 0
            rowValueLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .right)
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
            rowValueLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 21.0).isActive = true
            itemView.addArrangedSubview(rowValueLabel)
            
            let rowView = UIView()
            rowView.backgroundColor = UIColor.clear
                            
            itemView.backgroundColor = UIColor.clear
            rowView.addSubview(itemView)
            rowView.tag = index + 300
            rowView.layer.cornerRadius = KMAUIConstants.shared.KMACornerRadius
            rowView.clipsToBounds = true
            KMAUIUtilities.shared.setConstaints(parentView: rowView, childView: itemView, left: 0, right: 0, top: 0, bottom: 0)
            
            stackView.addArrangedSubview(rowView)
            rowView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
            
            if index < rows.count - 1 {
                // Line view
                let lineView = UIView()
                lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
                lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
                stackView.addArrangedSubview(lineView)
                lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
            }
            
            rowViews.append(rowView)
        }
    }
    
    @IBAction func showOnMapButtonPressed(_ sender: Any) {
        if polygone.type != "image", polygone.value.starts(with: "http") {
            if let url = URL(string: polygone.value) {
                KMAUIConstants.shared.popupOpened = true
                let safariVC = SFSafariViewController(url: url)
                KMAUIUtilities.shared.displayAlert(viewController: safariVC)
            }
        } else {
            mapCallback?(true)
        }
    }
}

// MARK: - QLPreviewController Datasource

extension KMAUIPolygoneTableViewCell: QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return previewItem as QLPreviewItem
    }
}

