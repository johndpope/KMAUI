//
//  KMAUIJudgeStatsTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 30.05.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit
import KMAUI
import Charts

public class KMAUIJudgeStatsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet public weak var profileImageView: UIImageView!
    @IBOutlet public weak var nameLabel: UILabel!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var distributedLandLabel: UILabel!
    @IBOutlet public weak var distributedLandValueLabel: UILabel!
    @IBOutlet public weak var distributedLandCenter: NSLayoutConstraint!
    @IBOutlet public weak var divideLineView: UIView!
    @IBOutlet public weak var caseStatisticsLabel: UILabel!
    @IBOutlet public weak var totalQuantityLabel: UILabel!
    @IBOutlet public weak var totalQuantityValueLabel: UILabel!
    @IBOutlet public weak var approvedView: UIView!
    @IBOutlet public weak var approvedLabel: UILabel!
    @IBOutlet public weak var approvedValueLabel: UILabel!
    @IBOutlet public weak var approvedDivideView: UIView!
    @IBOutlet public weak var declinedView: UIView!
    @IBOutlet public weak var declinedLabel: UILabel!
    @IBOutlet public weak var declinedValueLabel: UILabel!
    @IBOutlet public weak var declinedDivideView: UIView!
    @IBOutlet public weak var inProgressView: UIView!
    @IBOutlet public weak var inProgressLabel: UILabel!
    @IBOutlet public weak var inProgressValueLabel: UILabel!
    @IBOutlet public weak var chartView: PieChartView!
    @IBOutlet public weak var casesCountLabel: UILabel!
    @IBOutlet public weak var casesLabel: UILabel!
    
    // MARK: - Variables
    public static let id = "KMAUIJudgeStatsTableViewCell"
    public var landCases = [KMAUILandCaseStruct]()
    public var judge = KMAPerson() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Larger shadow for bgView
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 20
        
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(20)
        
        // Title label
        titleLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Distributed land label
        distributedLandLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(16)
        
        // Distributed land value label
        distributedLandValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
        
        // Divide line view
        divideLineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Case statistics label
        caseStatisticsLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Total quantity label
        totalQuantityLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        
        // Total quantity value label
        totalQuantityValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(14)
        
        // Approved view
        approvedView.layer.cornerRadius = 4
        approvedView.backgroundColor = KMAUIConstants.shared.KMAUIGreenProgressColor
        approvedView.clipsToBounds = true
        
        // Approved label
        approvedLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        
        // Approved value label
        approvedValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Approved divide view
        approvedDivideView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Declined view
        declinedView.layer.cornerRadius = 4
        declinedView.backgroundColor = KMAUIConstants.shared.KMAUIRedProgressColor
        declinedView.clipsToBounds = true
        
        // Declined label
        declinedLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        
        // Declined value label
        declinedValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Declined divide view
        declinedDivideView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        
        // Declined view
        inProgressView.layer.cornerRadius = 4
        inProgressView.backgroundColor = KMAUIConstants.shared.KMAUIGreyProgressColor
        inProgressView.clipsToBounds = true
        
        // Declined label
        inProgressLabel.font = KMAUIConstants.shared.KMAUIRegularFont
        
        // Declined value label
        inProgressValueLabel.font = KMAUIConstants.shared.KMAUIBoldFont
        
        // Cases count label
        casesCountLabel.font = UIFont.systemFont(ofSize: 24, weight: .heavy) //  KMAUIConstants.shared.KMAUIBoldFont.withSize(24)
        
        // Cases label
        casesLabel.font = UIFont.systemFont(ofSize: 24, weight: .light) // KMAUIConstants.shared.KMAUIRegularFont.withSize(24)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    publicfunc setupCell() {
        // Name label
        nameLabel.text = judge.fullName
        // Title label
        titleLabel.text = "Judge"
        // Distributed land
        var totalSquare: Double = 0
        
        for landCase in landCases {
            if landCase.courtStatus.lowercased() == "approved" {
                let subLand = landCase.subLand
                let square = subLand.subLandSquare
                totalSquare += square
            }
        }
        let squareKM = (totalSquare / 1000000).formatNumbersAfterDot()
        
        if totalSquare == 0 {
            distributedLandValueLabel.text = "0 km²"
        } else if squareKM > 0 {
            distributedLandValueLabel.text = "\(squareKM) km²"
        } else {
            distributedLandValueLabel.text = "\(totalSquare.formatNumbersAfterDot()) m²"
        }
        // Judge image
        profileImageView.image = KMAUIConstants.shared.profilePlaceholder.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = KMAUIConstants.shared.KMAUILightBorderColor
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = KMAUIConstants.shared.KMAUILightBorderColor.cgColor
        profileImageView.kf.indicatorType = .activity
        profileImageView.contentMode = .scaleAspectFill
        
        if !judge.profileImage.isEmpty, let url = URL(string: judge.profileImage) {
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
        
        if UIDevice.current.orientation.isLandscape {
            distributedLandCenter.constant = 0
        } else {
            distributedLandCenter.constant = 16
        }
        
        // Statistics
        var approvedCount = 0
        var declinedCount = 0
        var inProgressCount = 0
        var approvedPercents = 0
        var declinedPercents = 0
        var inProgressPercents = 0
        
        if !landCases.isEmpty {
            for landCase in landCases {
                if landCase.courtStatus.lowercased() == "approved" {
                    approvedCount += 1
                } else if landCase.courtStatus.lowercased() == "declined" {
                    declinedCount += 1
                } else if landCase.courtStatus.lowercased() == "in progress" {
                    inProgressCount += 1
                }
            }
            
            approvedPercents = Int(Double(approvedCount) / Double(landCases.count) * 100)
            declinedPercents = Int(Double(declinedCount) / Double(landCases.count) * 100)
            inProgressPercents = 100 - approvedPercents - declinedPercents
        }
        
        // Setup labels
        approvedValueLabel.text = "\(approvedCount) – \(approvedPercents)%"
        declinedValueLabel.text = "\(declinedCount) – \(declinedPercents)%"
        inProgressValueLabel.text = "\(inProgressCount) – \(inProgressPercents)%"
        
        // Total quantity
        totalQuantityValueLabel.text = "\(landCases.count)"
        
        // Land cases count
        casesCountLabel.text = "\(landCases.count)"
        
        // Setup chart
        let dataSet = [PieChartDataEntry(value: Double(approvedPercents) / 100), PieChartDataEntry(value: Double(declinedPercents) / 100), PieChartDataEntry(value: Double(inProgressPercents) / 100)]
        let set = PieChartDataSet(entries: dataSet, label: "Case statistics")
        set.colors = [KMAUIConstants.shared.KMAUIGreenProgressColor, KMAUIConstants.shared.KMAUIRedProgressColor, KMAUIConstants.shared.KMAUIGreyProgressColor]
        set.drawIconsEnabled = false
        set.selectionShift = 0
        set.drawValuesEnabled = false
        set.sliceSpace = 4
        let data = PieChartData(dataSet: set)
        chartView.data = data
        chartView.holeRadiusPercent = 0.85
        chartView.holeColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        chartView.minOffset = 0
        chartView.highlightPerTapEnabled = false
        chartView.rotationEnabled = false
        chartView.legend.enabled = false
        chartView.chartDescription?.enabled = false
    }
}
