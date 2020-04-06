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
    @IBOutlet weak var headerLogoImageView: UIImageView!
    
    // MARK: - Variables
    public var isFirst = false
    public var region = KMAMapAreaStruct() {
        didSet {
            setupHeader()
        }
    }
    public var headerTitle = "" {
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
        
        headerLogoImageView.layer.cornerRadius = 8
        headerLogoImageView.clipsToBounds = true
        
        headerLogoImageView.image = KMAUIConstants.shared.headerLotteryIcon
    }
    
    public func setupHeaderTitle() {
        print("Setup header view.")
    }
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUIRegionHeaderView.self)
        bundle.loadNibNamed("KMAUIRegionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
