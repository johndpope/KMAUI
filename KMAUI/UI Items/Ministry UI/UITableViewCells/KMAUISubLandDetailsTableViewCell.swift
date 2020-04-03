//
//  KMAUISubLandDetailsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 02.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUISubLandDetailsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var viewOnMapButton: UIButton!
    @IBOutlet weak var viewAttachmentsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var regionLabel: KMAUIRegularTextLabel!
    @IBOutlet weak var imagesBgView: UIView!
    @IBOutlet weak var noImagesLabel: KMAUIRegularTextLabel!
    
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
        
        // Setup the bgView shadow
        bgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        bgView.layer.shadowRadius = 8
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        
        // viewOnMapButton rounded corners
        viewOnMapButton.layer.cornerRadius = 6
        viewOnMapButton.clipsToBounds = true
        
        // viewAttachmentsButton rounded corners
        viewAttachmentsButton.layer.cornerRadius = 6
        viewAttachmentsButton.clipsToBounds = true
        
        // imagesBgView
        imagesBgView.layer.cornerRadius = 6
        imagesBgView.clipsToBounds = true
        
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
        regionLabel.text = "\(subLand.regionName) Region"
        // Setup the rows
        rules = [KMAUILotteryRule]()
        rules.append(KMAUILotteryRule(name: "Square", value: "\(subLand.subLandSquare.formatNumbersAfterDot()) m²"))
        // Reload tableView
        tableView.reloadData()
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
            pointCell.rule = rules[indexPath.row]
            pointCell.nameLabelHeight.constant = 44
            pointCell.lineView.isHidden = indexPath.row == 4
            pointCell.nameLabelLeft.constant = 20
            pointCell.valueLabelRight.constant = 20
            
            return pointCell
        }
        
        return KMAUIUtilities.shared.getEmptyCell()
    }
}
