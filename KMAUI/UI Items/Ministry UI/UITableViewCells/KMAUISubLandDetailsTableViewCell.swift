//
//  KMAUISubLandDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 02.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Kingfisher
import CoreLocation

public class KMAUISubLandDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var viewOnMapButton: UIButton!
    @IBOutlet weak var viewOnMapSingleButton: UIButton!
    @IBOutlet weak var viewAttachmentsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var regionLabel: KMAUIRegularTextLabel!
    @IBOutlet weak var imagesBgView: KMAUIImagesPreviewView!
    @IBOutlet weak var imagesBgViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imagesBgViewLeft: NSLayoutConstraint!
    
    // MARK: - Variables
    public static let id = "KMAUISubLandDetailsTableViewCell"
    public var subLand = KMAUISubLandStruct() {
        didSet {
            setupCell()
        }
    }
    public var viewOnMapCallback: ((Bool) -> Void)?
    public var viewAttachmentsCallback: ((Bool) -> Void)?
    var rules = [KMAUILotteryRule]()

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        // Setup the bgView shadow
        bgView.layer.cornerRadius = 8
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 8
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        bgView.layer.shadowColor = KMAUIConstants.shared.KMAUIGreyLineColor.cgColor
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = UIScreen.main.scale

        // viewOnMapButton rounded corners
        viewOnMapButton.layer.cornerRadius = 6
        viewOnMapButton.clipsToBounds = true
        viewOnMapButton.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
        viewOnMapButton.setTitleColor(KMAUIConstants.shared.KMAUITextColor, for: .normal)
        
        // viewOnMapSingleButton rounded corners
        viewOnMapSingleButton.layer.cornerRadius = 6
        viewOnMapSingleButton.clipsToBounds = true
        
        // viewAttachmentsButton rounded corners
        viewAttachmentsButton.layer.cornerRadius = 6
        viewAttachmentsButton.clipsToBounds = true
        
        // imagesBgView
        imagesBgView.layer.cornerRadius = 6
        imagesBgView.clipsToBounds = true
        imagesBgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        // No selection required
        selectionStyle = .none
        
        // tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: KMAUIRulesPointTableViewCell.id, bundle: Bundle(identifier: "org.cocoapods.KMAUI")), forCellReuseIdentifier: KMAUIRulesPointTableViewCell.id)
        
        // nameLabel
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Name and region
        nameLabel.text = "Land ID \(subLand.subLandId)"
        
        if subLand.regionName.isEmpty {
            regionLabel.text = ""
        } else {
            regionLabel.text = "\(subLand.regionName) Region"
        }
        // Setup the rows
        rules = [KMAUILotteryRule]()
        rules.append(KMAUILotteryRule(name: "Status", value: subLand.status.capitalized))
        rules.append(KMAUILotteryRule(name: "Square", value: "\(subLand.subLandSquare.formatNumbersAfterDot()) m²"))
        rules.append(KMAUILotteryRule(name: "Land percent", value: "\(Int(subLand.subLandPercent * 100)) %"))
        if subLand.extraPrice > 0 {
            rules.append(KMAUILotteryRule(name: "Extra price", value: "$ \(subLand.extraPrice.formatNumbersAfterDot().withCommas())"))
            // Setup the paid status
            if subLand.status == "confirmed" {
                rules.append(KMAUILotteryRule(name: "Payment", value: "Completed"))
            } else if subLand.status == "awaiting payment" {
                rules.append(KMAUILotteryRule(name: "Payment", value: "Pending"))
            }
        }
        // Reload tableView
        tableView.reloadData()
        // Setup images
        imagesBgView.subLand = subLand
        // Callback for actions
        imagesBgView.viewAttachmentsAction = { action in
            self.viewAttachmentsCallback?(true)
        }
        // Setup buttons
        setupButtons()
    }
    
    /**
     Setup bottom action buttons
     */
    
    func setupButtons() {
        viewOnMapButton.alpha = 0
        viewOnMapSingleButton.alpha = 0
        viewAttachmentsButton.alpha = 0
        // Setup buttons visibility
        if subLand.subLandImagesArray.isEmpty {
            imagesBgView.alpha = 0
            imagesBgViewWidth.constant = 0
            imagesBgViewLeft.constant = 12
            viewOnMapSingleButton.alpha = 1
        } else {
            imagesBgView.alpha = 1
            imagesBgViewWidth.constant = 200
            imagesBgViewLeft.constant = 20
            viewOnMapButton.alpha = 1
            viewAttachmentsButton.alpha = 1
        }
    }
    
    // MARK: - IBOutlets
    
    @IBAction public func viewOnMapButtonPressed(_ sender: Any) {
        viewOnMapCallback?(true)
    }
    
    @IBAction public func viewAttachmentsButtonPressed(_ sender: Any) {
        viewAttachmentsCallback?(true)
    }
}

// MARK: - UITableView data source and delegate method

extension KMAUISubLandDetailsTableViewCell: UITableViewDataSource, UITableViewDelegate {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewHeight.constant = CGFloat(rules.count) * 44
        
        return rules.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let pointCell = tableView.dequeueReusableCell(withIdentifier: KMAUIRulesPointTableViewCell.id) as? KMAUIRulesPointTableViewCell {
            pointCell.subLandDetails = true
            pointCell.rule = rules[indexPath.row]
            pointCell.lineView.isHidden = indexPath.row == rules.count - 1
            pointCell.nameLabelLeft.constant = 0
            return pointCell
        }
        
        return KMAUIUtilities.shared.getEmptyCell()
    }
}

/*
/*
 Square
 Percent
 Extra price
 Status
 */

for (index, subLand) in self.subLands.enumerated() {
    print("\n\(index + 1). Sub land details:")
    // subLandId
    print("ID: \(subLand.subLandId)")
    // subLandType
    print("Type: \(subLand.subLandType)")
    // planId?
    print("Plan ID: \(subLand.landPlanId)")
    // subLandArea
    print("Area exists: \(!subLand.subLandArea.isEmpty)")
    // subLandSquare
    print("Square: \(subLand.subLandSquare.formatNumbersAfterDot()) sq. m.")
    // subLandWidth
    print("Width: \(subLand.subLandWidth.formatNumbersAfterDot()) m")
    // subLandHeight
    print("Height: \(subLand.subLandHeight.formatNumbersAfterDot()) m")
    // location
    print("Location: \(subLand.location.latitude), \(subLand.location.longitude)")
    // minX, minY, maxX, maxY
    print("Bounds: \(subLand.sw.latitude), \(subLand.sw.longitude) -> \(subLand.ne.latitude), \(subLand.ne.longitude)")
    // subLandPercent
    print("Percent: \(Int(subLand.subLandPercent * 100)) %")
    // extraPrice
    print("Extra price: $ \(subLand.extraPrice.formatNumbersAfterDot())")
    // status
    print("Status: \(subLand.status)")
    // comfirmed
    print("Confirmed: \(subLand.confirmed)")
    // paid
    print("Paid: \(subLand.paid)")
    // description
    // images
}*/
