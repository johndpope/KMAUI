//
//  KMAUIQueueCitizenHeaderView.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 10.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIQueueCitizenHeaderView: UIView {
    
    // MARK: - IBOutlets
    @IBOutlet public var contentView: UIView!
    @IBOutlet public weak var regionLabel: KMAUIBoldTextLabel!
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
    
    public var actionCallback: ((Bool) -> Void)?
    
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
        
        self.setupHeaderTitle()
    }
    
    public func setupHeaderTitle() {
        lineViewTop.constant = -1
        lineView.alpha = 0
        
        regionLabel.text = "Citizens"
        timeframeLabel.text = "\(region.lotteryMembersCount) citizens in the queue"
        headerLogoImageView.image = KMAUIConstants.shared.headerCitizenIcon.withRenderingMode(.alwaysTemplate)
    }
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUIQueueCitizenHeaderView.self)
        bundle.loadNibNamed("KMAUIQueueCitizenHeaderView", owner: self, options: nil)
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
