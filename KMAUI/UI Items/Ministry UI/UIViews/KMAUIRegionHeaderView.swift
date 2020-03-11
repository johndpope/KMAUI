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
    
    // MARK: - Variables
    public var region = KMAMapAreaStruct() {
        didSet {
            setupCell()
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
    
    public func setupCell() {
        if region.nameE.isEmpty {
            // Demo data
            region.nameE = "Ar Riyad"
            region.queueCount = 759
        }
        
        // Get the current year
        let year = Calendar.current.component(.year, from: Date())
        // Get the first day of the current year
        if let firstOfCurrentYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)) {
            region.periodStart = firstOfCurrentYear
        }
        // Get the first day of next year
        if let firstOfNextYear = Calendar.current.date(from: DateComponents(year: year + 1, month: 1, day: 1)) {
            // Get the last day of the current year
            if let lastOfYear = Calendar.current.date(byAdding: .day, value: -1, to: firstOfNextYear) {
                region.periodEnd = lastOfYear
            }
        }
        
        regionLabel.text = region.nameE
        regionLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        queueLabel.text = "Queue – \(region.queueCount)"
        timeframeLabel.text = "From \(KMAUIUtilities.shared.formatStringShort(date: region.periodStart, numOnly: true)) – To \(KMAUIUtilities.shared.formatStringShort(date: region.periodEnd, numOnly: true))"
    }
    
    private func commonInit() {
        let bundle = Bundle(for: KMAUIRegionHeaderView.self)
        bundle.loadNibNamed("KMAUIRegionHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
