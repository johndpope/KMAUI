//
//  KMAUITrespassCaseDetailsTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 25.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUITrespassCaseDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var citizenHightlightView: UIView!
    @IBOutlet public weak var caseNumberLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var departmentLabel: KMAUIRegularTextLabel!
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
    @IBOutlet public weak var imagesViewLeft: NSLayoutConstraint!
    @IBOutlet public weak var imagesViewWidth: NSLayoutConstraint!
    @IBOutlet public weak var statusView: UIView!
    @IBOutlet public weak var statusLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUITrespassCaseDetailsTableViewCell"
    public var citizenCallback: ((Bool) -> Void)?
    public var mapCallback: ((Bool) -> Void)?
    public var attachmentCallback: ((Bool) -> Void)?
    public var trespassCase = KMAUITrespassCaseStruct() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background virew
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Citizen hightlight view
        citizenHightlightView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        citizenHightlightView.layer.cornerRadius = 8
        
        // Name label
        caseNumberLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Title number
        departmentLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Attachment view
        imagesView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        imagesView.layer.cornerRadius = 8
        imagesView.clipsToBounds = true
        
        // Status view
        statusView.layer.cornerRadius = 4
        statusView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
        statusView.clipsToBounds = true
        
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
    
    /**
     Created - blue
     Declined - red
     Resolved - green
     
     Setup the imagesView when copying to KMAUI
     */
    
    public func setupCell() {
        // Status label
        statusLabel.text = trespassCase.caseStatus
        // Name label
        caseNumberLabel.text = "Case #\(trespassCase.caseNumber)"
        // Title label
        departmentLabel.text = "Department of Urban Planning" //trespassCase.department.departmentName
        // Sub land id
        subLandIdLabel.text = "Land ID \(trespassCase.subLand.subLandId)"
        // Region label
        regionLabel.text = "\(trespassCase.subLand.regionName) region"
        if trespassCase.subLand.regionName.isEmpty {
            regionLabel.text = "Makkah region"
        }
        // Area
        areaValueLabel.text = "\(Int(trespassCase.subLand.subLandSquare)) m²"
        // Area type
        areaTypeValueLabel.text = trespassCase.subLand.subLandType.capitalized
        // Setup images
        if trespassCase.subLand.subLandImagesAllArray.isEmpty {
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
            imagesView.subLand = trespassCase.subLand
            // Callback for actions
            imagesView.viewAttachmentsAction = { action in
                self.attachmentCallback?(true)
            }
        }
        // Status view color
        if trespassCase.caseStatus == "Created" {
            statusView.backgroundColor = KMAUIConstants.shared.KMABrightBlueColor
        } else if trespassCase.caseStatus == "Declined" {
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        } else if trespassCase.caseStatus == "Resolved" {
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        } else if trespassCase.caseStatus == "Awaiting verification" {
            statusView.backgroundColor = KMAUIConstants.shared.KMAUIYellowProgressColor
        }
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - IBOutlets
    
    @IBAction public func citizenHightlightButtonPressed(_ sender: Any) {
        /*// Highlight the view
         citizenHightlightView.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
         citizenCallback?(true)
         
         // Give a small delay before deselect
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         self.citizenHightlightView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
         }*/
    }
    
    @IBAction public func mapButtonPressed(_ sender: Any) {
        mapCallback?(true)
    }
    
    @IBAction public func attachmentButtonPressed(_ sender: Any) {
        attachmentCallback?(true)
    }
}
