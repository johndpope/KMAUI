//
//  KMAUICitizenLandCaseTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 25.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import QuickLook
import Kingfisher

public class KMAUICitizenLandCaseTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var citizenHightlightView: UIView!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var rightArrowImageView: UIImageView!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var citizenHighlightButton: UIButton!
    @IBOutlet public weak var attachmentButtonWidth: NSLayoutConstraint!
    @IBOutlet public weak var attachmentButtonRight: NSLayoutConstraint!
    @IBOutlet public weak var subLandIdLabel: UILabel!
    @IBOutlet public weak var regionLabel: UILabel!
    @IBOutlet public weak var areaLabel: UILabel!
    @IBOutlet public weak var areaValueLabel: UILabel!
    @IBOutlet public weak var areaTypeLabel: UILabel!
    @IBOutlet public weak var areaTypeValueLabel: UILabel!
    @IBOutlet public weak var divideLineView2: UIView!
    @IBOutlet public weak var divideLineView3: UIView!
    @IBOutlet public weak var attachmentsButton: UIButton!
    @IBOutlet public weak var mapButton: UIButton!
    @IBOutlet public weak var imagesView: KMAUIImagesPreviewView!
    @IBOutlet weak var imagesViewLeft: NSLayoutConstraint!
    @IBOutlet weak var imagesViewWidth: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUICitizenLandCaseTableViewCell"
    public lazy var previewItem = NSURL()
    public var citizenCallback: ((Bool) -> Void)?
    public var mapCallback: ((Bool) -> Void)?
    public var attachmentCallback: ((Bool) -> Void)?
    public var landCase = KMAUILandCaseStruct() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background virew
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 7)
        bgView.layer.shadowRadius = 8
        
        // Citizen hightlight view
        citizenHightlightView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        citizenHightlightView.layer.cornerRadius = 8
        
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Title number
        titleLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Attachment view
        imagesView.layer.cornerRadius = 8
        imagesView.clipsToBounds = true
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        
        // Divide line
        divideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        divideLineView2.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        divideLineView3.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Sub land id
        subLandIdLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Region label
        regionLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        
        // Area
        areaLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        areaLabel.text = "Area"
        areaValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Area type
        areaTypeLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        areaTypeLabel.text = "Type"
        areaTypeValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Attachments button
        attachmentsButton.layer.cornerRadius = 6
        attachmentsButton.clipsToBounds = true
        attachmentsButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        attachmentsButton.setImage(KMAUIConstants.shared.attachmentIcon.withRenderingMode(.alwaysTemplate), for: .normal)
        attachmentsButton.tintColor = KMAUIConstants.shared.KMAUITextColor //UIColor.black
        
        // Map button
        mapButton.layer.cornerRadius = 6
        mapButton.clipsToBounds = true
        mapButton.backgroundColor = KMAUIConstants.shared.KMAUILightBorderColor
        mapButton.setImage(KMAUIConstants.shared.mapButtonImage.withRenderingMode(.alwaysTemplate), for: .normal)
        mapButton.tintColor = KMAUIConstants.shared.KMAUITextColor //UIColor.black

        // No selection required
        selectionStyle = .none
    }
    
    public func setupCell() {
        // Name label
        nameLabel.text = landCase.citizen.fullName
        // Title label
        titleLabel.text = "Citizen"
        // Citizen image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = KMAUIConstants.shared.KMAUILightBorderColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.layer.borderColor = KMAUIConstants.shared.KMAUILightBorderColor.cgColor
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.kf.indicatorType = .activity
        profileImageView.contentMode = .scaleAspectFill
        // Get image
        if !landCase.citizen.profileImage.isEmpty, let url = URL(string: landCase.citizen.profileImage) {
            profileImageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    self.profileImageView.image = value.image
                    self.profileImageView.layer.borderWidth = 0
                case .failure(let error):
                    print(error.localizedDescription) // The error happens
                }
            }
        }
        // Sub land id
        subLandIdLabel.text = "Land ID \(landCase.subLand.subLandId)"
        // Region label
        regionLabel.text = "\(landCase.subLand.regionName) region"
        
        if landCase.subLand.regionName.isEmpty {
            regionLabel.text = "Makkah region"
        }
        
        // Area
        areaValueLabel.text = "\(Int(landCase.subLand.subLandSquare)) m²"
        // Area type
        areaTypeValueLabel.text = landCase.subLand.subLandType.capitalized
        // Check if residential
        if landCase.subLand.subLandType.lowercased().contains("residential") {
            areaTypeValueLabel.text = "Residential"
        }
        // Setup images
        if landCase.subLand.subLandImagesAllArray.isEmpty {
            // No images, hide the view
            imagesView.alpha = 0
            imagesViewWidth.constant = 0
            imagesViewLeft.constant = 3
            attachmentButtonWidth.constant = 0
            attachmentButtonRight.constant = 0
        } else {
            imagesView.alpha = 1
            imagesViewWidth.constant = 200
            imagesViewLeft.constant = 27
            attachmentButtonWidth.constant = 32
            attachmentButtonRight.constant = 8
            imagesView.subLand = landCase.subLand
            // Callback for actions
            imagesView.viewAttachmentsAction = { action in
                self.attachmentCallback?(true)
            }
        }
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - IBOutlets
    
    @IBAction func citizenHightlightButtonPressed(_ sender: Any) {
        // Highlight the view
        citizenHightlightView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        citizenCallback?(true)
        
        // Give a small delay before deselect
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.citizenHightlightView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        }
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {
        mapCallback?(true)
    }
}
