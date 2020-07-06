//
//  KMAUIGooglePlacePolygoneTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 06.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import Kingfisher

public class KMAUIGooglePlacePolygoneTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var bgViewTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var placeImageView: KMAUIImagesPreviewView!
    @IBOutlet weak var placeImageViewLeft: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: KMAUIRegularTextLabel!
    @IBOutlet weak var topDivideLineView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var placeImageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ratingLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var ratingLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var ratingLabelLeft: NSLayoutConstraint!
    @IBOutlet weak var showOnMapButton: UIButton!
    
    // MARK: - Variables
    public static let id = "KMAUIGooglePlacePolygoneTableViewCell"
    public var mapCallback: ((Bool) -> Void)?
    public var isFirst = false
    public var polygone = KMAUIPolygoneDataStruct() {
        didSet {
            setupCell()
        }
    }
    public var rowViews = [UIView]()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Rating label
        ratingLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        ratingLabel.textColor = UIColor.white
        ratingLabel.layer.cornerRadius = 8
        ratingLabel.clipsToBounds = true
        
        // Location label
        locationLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Top divide line view
        topDivideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Place imageView
        placeImageView.layer.cornerRadius = 8
        placeImageView.clipsToBounds = true
        
        // Show on map button
        showOnMapButton.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
        showOnMapButton.titleLabel?.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        showOnMapButton.setTitleColor(UIColor.white, for: .normal)
        showOnMapButton.layer.cornerRadius = 8
        showOnMapButton.clipsToBounds = true
        
        // No selection required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Top offset
        if isFirst {
            bgViewTop.constant = 16
        } else {
            bgViewTop.constant = 0
        }

        // Place name
        titleLabel.text = polygone.googlePlaceName
        
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
        
        // Location
        let latitude = CGFloat(Int(polygone.googlePlaceLocation.latitude * 1000000)) / 1000000
        let longitude = CGFloat(Int(polygone.googlePlaceLocation.longitude * 1000000)) / 1000000
        locationLabel.text = "\(latitude), \(longitude)"
        
        // Icon
        if !polygone.googlePlaceIcon.isEmpty, let url = URL(string: polygone.googlePlaceIcon) {
            logoImageView.kf.setImage(with: url)
        }
        
        // Setup attachments
        var attachments = [KMADocumentData]()
        
        if !polygone.googlePlaceImage.isEmpty {
            var attachment = KMADocumentData()
            attachment.fileURL = polygone.googlePlaceImage
            attachment.previewURL = polygone.googlePlaceImage
            attachment.name = polygone.googlePlaceName.replacingOccurrences(of: " ", with: "") + ".jpg"
            attachment.objectId = polygone.googlePlaceId
            attachments.append(attachment)
        }
        
        placeImageView.attachments = attachments
        
        if attachments.isEmpty {
            placeImageView.singleImageView.contentMode = .scaleAspectFit
            placeImageViewLeft.constant = -200 + 4
        } else {
            placeImageView.alpha = 1
            placeImageViewLeft.constant = 20
        }
        
        placeImageView.isHidden = attachments.isEmpty
        
        // Setup stack view
        setupStackView()
    }
    
    func setupStackView() {
        // Clear existing subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Clear the row views
        rowViews = [UIView]()
        
        // Prepare rows
        var rows = [KMAUIRowData]()
        
        // Open now
        if !polygone.googlePlaceOpenNow.isEmpty {
            rows.append(KMAUIRowData(rowName: "Open now", rowValue: polygone.googlePlaceOpenNow))
        }

        // Categores
        if !polygone.googlePlaceTypes.isEmpty {
            rows.append(KMAUIRowData(rowName: "Categories", rowValue: polygone.googlePlaceTypesString))
        }
        
        // Working hours
        if !polygone.googlePlaceWorkingHours.isEmpty {
            rows.append(KMAUIRowData(rowName: "Working hours", rowValue: polygone.googlePlaceWorkingHours))
        }
        
        // Prepare the rows
        for (index, row) in rows.enumerated() {
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.center
            itemView.spacing = 8
            
            itemView.layoutMargins = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
            itemView.isLayoutMarginsRelativeArrangement = true

            // Row name label
            let rowNameLabel = KMAUIRegularTextLabel()
            rowNameLabel.textAlignment = .left
            rowNameLabel.text = row.rowName
            rowNameLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 252), for: .horizontal)
            itemView.addArrangedSubview(rowNameLabel)
            
            // Row value label
            let rowValueLabel = KMAUIBoldTextLabel()
            rowValueLabel.textAlignment = .right
            rowValueLabel.text = row.rowValue
            rowValueLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)
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
        
        // Setup the image height
        placeImageViewHeight.constant = 36 * CGFloat(rowViews.count)
    }
    
    @IBAction func showOnMapButtonPressed(_ sender: Any) {
        mapCallback?(true)
    }
}
