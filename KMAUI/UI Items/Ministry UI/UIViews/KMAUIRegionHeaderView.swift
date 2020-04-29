//
//  KMAUIRegionHeaderView.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 10.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIRegionHeaderView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var regionLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var queueLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var timeframeLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var lineView: UIView!
    @IBOutlet public weak var lineViewTop: NSLayoutConstraint!
    @IBOutlet public weak var headerLogoImageView: UIImageView!
    
    // MARK: - Variables
    public var isFirst = false
    public var region = KMAMapAreaStruct() {
        didSet {
            setupHeader()
        }
    }
    public var array = [AnyObject]() {
        didSet {
            setupHeaderTitle()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public func setupHeader() {
        // Top offset
        if isFirst {
            lineViewTop.constant = -1
            lineView.alpha = 0
        } else {
            lineViewTop.constant = 16
            lineView.alpha = 0.3
        }
        
        // Fill the data to display
        regionLabel.text = region.nameE
        regionLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        queueLabel.text = "Queue – \(region.lotteryMembersCount)"
        timeframeLabel.text = "\(KMAUIUtilities.shared.formatStringShort(date: region.periodStart, numOnly: true)) – \(KMAUIUtilities.shared.formatStringShort(date: region.periodEnd, numOnly: true))"

        headerLogoImageView.image = KMAUIConstants.shared.headerLotteryIcon.withRenderingMode(.alwaysTemplate)
        
    }
    
    public func setupHeaderTitle() {
        lineViewTop.constant = -1
        lineView.alpha = 0
        timeframeLabel.text = ""
        
        // Land plan
        if let landPlans = array as? [KMAUILandPlanStruct] {
            regionLabel.text = "Lotteries"
            
            if landPlans.count == 1 {
                queueLabel.text = "1 lottery was found"
            } else {
                queueLabel.text = "\(landPlans.count) lotteries were found"
            }
            
            headerLogoImageView.image = KMAUIConstants.shared.headerLotteryIcon.withRenderingMode(.alwaysTemplate)
        }
        // Sub land
        if let subLands = array as? [KMAUISubLandStruct] {
            regionLabel.text = "Sub lands"
            
            if subLands.count == 1 {
                queueLabel.text = "1 sub land was found"
            } else {
                queueLabel.text = "\(subLands.count) sub lands were found"
            }
            
            headerLogoImageView.image = KMAUIConstants.shared.headerSubLandIcon.withRenderingMode(.alwaysTemplate)
        }
        // Citizen
        if let citizens = array as? [KMAPerson] {
            regionLabel.text = "Citizens"
            
            if citizens.count == 1 {
                queueLabel.text = "1 citizen was found"
            } else {
                queueLabel.text = "\(citizens.count) citizens were found"
            }
            
            headerLogoImageView.image = KMAUIConstants.shared.headerCitizenIcon.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUIRegionHeaderView.self)
        bundle.loadNibNamed("KMAUIRegionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        // Corner radius for headerLogo
        headerLogoImageView.layer.cornerRadius = 8
        headerLogoImageView.clipsToBounds = true
        headerLogoImageView.tintColor = UIColor.white
        headerLogoImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlueDarkColor
    }
}
