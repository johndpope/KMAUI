//
//  KMAUIBuildingPermitsTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 21.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIBuildingPermitsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var bgView: KMAUIRoundedCornersView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    @IBOutlet weak var rightArrowImageView: UIImageView!
    @IBOutlet weak var rightArrowImageViewRight: NSLayoutConstraint!
    @IBOutlet weak var nameLabel: KMAUIBoldTextLabel!
    @IBOutlet weak var ministryLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIBuildingPermitsTableViewCell"
    public var isFirst = false
    public var dataset = KMAUIDataset() {
        didSet {
            setupCell()
        }
    }
    public var isClickable = false
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Larger shadow for bgView
        bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
        bgView.layer.shadowOffset = CGSize(width: 0, height: 4)
        bgView.layer.shadowRadius = 12
        
        // Background color
        backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Setup the right arrow
        rightArrowImageView.image = KMAUIConstants.shared.arrowIndicator.withRenderingMode(.alwaysTemplate)
        rightArrowImageView.layer.cornerRadius = 4
        rightArrowImageView.clipsToBounds = true
        // Default state - disabled
        rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
        rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        
        // Name label
        nameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(18)
        
        // Ministry label
        ministryLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(14)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        setupColors(highlight: selected)
    }
    
    override public func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        setupColors(highlight: highlighted)
    }
    
    public func setupColors(highlight: Bool) {
        if highlight, isClickable {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUILightButtonColor
            rightArrowImageView.tintColor = UIColor.white
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
        } else {
            bgView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColor
            rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
            rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
        }
    }
    
    public func setupCell() {
        if isFirst {
            stackViewTop.constant = 16
        } else {
            stackViewTop.constant = 0
        }
        
        // Check if clickable
        if isClickable {
            rightArrowImageViewRight.constant = 16
            rightArrowImageView.alpha = 1
        } else {
            rightArrowImageViewRight.constant = -18
            rightArrowImageView.alpha = 0
        }
        
        // Name label
        nameLabel.text = dataset.name + " for \(dataset.region.nameE)"
        nameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        // Ministry label
        ministryLabel.text = dataset.owner
        ministryLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
        
        // Dataset mode
        if dataset.type == "governmentWellsByTypesAndRegions" {
            setupStackViewGovernmentWells()
        } else if dataset.type == "hospitalBedsSectors" || dataset.type == "hospitalBedsSectorsByRegion" {
            // Remove subviews
            for subview in stackView.subviews {
                stackView.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
            
            setupStackViewHospitalBedsSectors()
        } else {
            // Setup stack view
            var rowsTitles = [String]()
            var rows = [KMAUIRowData]()
            var values = [[String: Int]]()
            
            for sets in dataset.detailsArray {
                for (key, value) in sets {
                    if let value = value as? [String: Int] {
                        values.append(value)
                    }
                    
                    rowsTitles.append(key)
                    rows.append(KMAUIRowData(rowName: key, rowValue: ""))
                }
            }
            
            setupStackView(rows: rows, values: values)
        }
    }
    
    /**
     Show the stack view for hospitalBedsSectors
     */
    
    public func setupStackViewHospitalBedsSectors() {
        let datasetDictionary = dataset.detailsDictionary
        
        if let sectionTitles = datasetDictionary["sectionTitles"] as? [String],
            var years = datasetDictionary["rowTitles"] as? [String],
            let points = datasetDictionary["points"] as? [String],
            let datasetData = datasetDictionary["data"] as? [String: AnyObject] {
            // Title inserted
            if dataset.type == "hospitalBedsSectors" {
                years.insert("Years", at: 0)
            }
            if dataset.type == "hospitalBedsSectorsByRegion" {
                years.insert("Sectors", at: 0)
            }
            
            for sectionTitle in sectionTitles {
                if let rowDetails = datasetData[sectionTitle] as? [String: AnyObject] {
                let rowTitleLabel = KMAUIBoldTextLabel()
                rowTitleLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(16)
                rowTitleLabel.text = "   " + sectionTitle
                rowTitleLabel.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                rowTitleLabel.backgroundColor = KMAUIConstants.shared.KMAUIMainBgColor
                rowTitleLabel.layer.cornerRadius = 8
                rowTitleLabel.clipsToBounds = true
                stackView.addArrangedSubview(rowTitleLabel)

                // rows - years
                for (index, year) in years.enumerated() {
                    // Title
                    let itemView = UIStackView()
                    itemView.axis = .horizontal
                    itemView.distribution = UIStackView.Distribution.fill
                    itemView.alignment = UIStackView.Alignment.fill
                    itemView.spacing = 4
                    
                    // Year title
                    let rowTitleLabel = KMAUIBoldTextLabel()
                    rowTitleLabel.text = year
                    rowTitleLabel.textAlignment = .left
                    rowTitleLabel.heightAnchor.constraint(equalToConstant: 32.0).isActive = true
                    itemView.addArrangedSubview(rowTitleLabel)
                    
                    if index == 0 {
                        for point in points {
                            let rowTitleLabel = KMAUIBoldTextLabel()
                            rowTitleLabel.text = point
                            rowTitleLabel.textAlignment = .center
                            itemView.addArrangedSubview(rowTitleLabel)
                        }
                        
                        addLine()
                    } else {
                        if let pointsDetails = rowDetails[year] as? [String: Double] {
                            for point in points {
                                if let pointValue = pointsDetails[point] {
                                    let rowTitleLabel = KMAUIRegularTextLabel()
                                    
                                    if pointValue > 0 {
                                        rowTitleLabel.text = "\(pointValue.withCommas())"
                                    } else {
                                        rowTitleLabel.text = "-" // Empty space
                                    }
                                    
                                    rowTitleLabel.textAlignment = .center
                                    itemView.addArrangedSubview(rowTitleLabel)
                                }
                            }
                        }
                    }
                    
                    stackView.addArrangedSubview(itemView)
                    itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                }

                // columns - beds, hospitals
                }
            }
        }
    }
    
    /**
     Show the stackView
     */
    
    public func setupStackView(rows: [KMAUIRowData], values: [[String: Int]]) {
        // Remove subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        // Optimize the font size for the 9.7-inch iPad
        var fontSize: CGFloat = 12
        
        if UIScreen.main.bounds.size.width == 768 || UIScreen.main.bounds.size.height == 768 {
            fontSize = 10
        }
        
        // Rows
        var keys = KMAUIConstants.shared.establishmentPermitKeys
        
        if dataset.name == "Manpower in the Productive Factories Licensed Under the Protection and Encouragement of National Industries and Foreign Capital Investment Laws Classified by Industrial Activity and Regions Until 2012 A.D." {
            keys = KMAUIConstants.shared.manpower2012Keys
        } else if dataset.name == "Manpower in the Productive Factories Licensed Under the Protection and Encouragement of National Industries and Foreign Capital Investment Laws Classified by Industrial Sector and Region: Up to the End of 1426A.H." {
            keys = KMAUIConstants.shared.manpowerKeys
        } else if dataset.type == "buildingPermits" {
            keys = KMAUIConstants.shared.buildingPermitKeys
        } else if dataset.type == "hospitalBeds" {
            keys = KMAUIConstants.shared.hospitalBedsKeys
        }
        
        // Title
        let itemView = UIStackView()
        itemView.axis = .horizontal
        itemView.distribution = UIStackView.Distribution.fill
        itemView.alignment = UIStackView.Alignment.fill
        itemView.spacing = 4
        
        var titlesArray = [KMAUIRowData(rowName: "Types of Activities", rowValue: "")]
        
        if dataset.name == "Manpower in the Productive Factories Licensed Under the Protection and Encouragement of National Industries and Foreign Capital Investment Laws Classified by Industrial Sector and Region: Up to the End of 1426A.H." || dataset.name == "Manpower in the Productive Factories Licensed Under the Protection and Encouragement of National Industries and Foreign Capital Investment Laws Classified by Industrial Activity and Regions Until 2012 A.D." {
            titlesArray = [KMAUIRowData(rowName: "Industrial sector", rowValue: "")]
        } else  if dataset.type == "buildingPermits" {
            titlesArray = [KMAUIRowData(rowName: "Type of Permit", rowValue: "")]
        } else if dataset.type == "hospitalBeds" {
            titlesArray = [KMAUIRowData(rowName: "Speciality", rowValue: "")]
        }
        
        titlesArray.append(contentsOf: rows)
        
        for (index, titles) in titlesArray.enumerated() {
            // Building kind
            let rowNameLabel = KMAUIBoldTextLabel()
            rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize)
            rowNameLabel.text = titles.rowName
            
            if index == 0 {
                rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
            } else {
                rowNameLabel.textAlignment = .center
                rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .center)
            }

            rowNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24.0).isActive = true
            itemView.addArrangedSubview(rowNameLabel)
        }
        
        stackView.addArrangedSubview(itemView)
        itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        
        addLine()
        
        for key in keys {
            // Title
            let itemView = UIStackView()
            itemView.axis = .horizontal
            itemView.distribution = UIStackView.Distribution.fill
            itemView.alignment = UIStackView.Alignment.fill
            itemView.spacing = 4
            
            // Row title
            let rowNameLabel = KMAUIBoldTextLabel()
            rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize)
            rowNameLabel.text = key
            rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
            rowNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24.0).isActive = true
            
            rowNameLabel.layer.cornerRadius = 8
            rowNameLabel.clipsToBounds = true
            itemView.addArrangedSubview(rowNameLabel)
            
            // Values
            for value in values {
                if let count = value[key] {
                    // Value title
                    let rowNameLabel = KMAUIRegularTextLabel()
                    rowNameLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(fontSize)
                    rowNameLabel.textAlignment = .center
                    rowNameLabel.text = "\(count)"
                    itemView.addArrangedSubview(rowNameLabel)
                }
            }
            
            stackView.addArrangedSubview(itemView)
            itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        }
    }
    
    public func setupStackViewGovernmentWells() {
        // Remove subviews
        for subview in stackView.subviews {
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        let datasetDictionary = dataset.detailsDictionary
        
        // Optimize the font size for the 9.7-inch iPad
        var fontSize: CGFloat = 12
        
        if UIScreen.main.bounds.size.width == 768 || UIScreen.main.bounds.size.height == 768 {
            fontSize = 10
        }
        
        var rowTitles = [""]
        var firstRow = ["المنطقة"]
        
        if dataset.name == "كميات الطلب السنوية على المياه – مليون م3 / سنة" {
            firstRow = [" الأغراض"]
        } else if dataset.name == "Total water consumption by region and purpose 2018-2019" {
            firstRow = ["المنطقة المستفيدة"]
        }
        
        if let columnTitles = datasetDictionary["sectionTitles"] as? [String], let rowTitlesValue = datasetDictionary["rowTitles"] as? [String], let datasetData = datasetDictionary["data"] as? [String: AnyObject] {
            firstRow.append(contentsOf: columnTitles)
            rowTitles.append(contentsOf: rowTitlesValue)
            
            for (rowIndex, rowTitle) in rowTitles.enumerated() {
                // Title
                let itemView = UIStackView()
                itemView.axis = .horizontal
                itemView.distribution = UIStackView.Distribution.fill
                itemView.alignment = UIStackView.Alignment.fill
                itemView.spacing = 4
              
                for (index, columnTitle) in firstRow.enumerated() {
                    // Building kind
                    let rowNameLabel = KMAUIBoldTextLabel()
                    rowNameLabel.font = KMAUIConstants.shared.KMAUIBoldFont.withSize(fontSize)
                    
                    if rowIndex == 0 {
                        rowNameLabel.text = columnTitle
                    } else if rowIndex > 0, index == 0 {
                        rowNameLabel.text = rowTitles[rowIndex]
                    } else if rowIndex > 0, index > 0 {
                        rowNameLabel.font = KMAUIConstants.shared.KMAUIRegularFont.withSize(fontSize)
                        
                        if let rowValues = datasetData[rowTitle] as? [String: Int], let value = rowValues[columnTitle] {
                            rowNameLabel.text = "\(value.withCommas())"
                        }
                    } else {
                        rowNameLabel.text = "-"
                    }
                     
                    if index == 0 {
                        rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .left)
                    } else {
                        rowNameLabel.textAlignment = .center
                        rowNameLabel.setLineSpacing(lineSpacing: 1.2, lineHeightMultiple: 1.2, alignment: .center)
                    }
                                     
                    rowNameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 24.0).isActive = true
                    itemView.addArrangedSubview(rowNameLabel)
                }
                
                stackView.addArrangedSubview(itemView)
                itemView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
                
                if rowIndex == 0 {
                    addLine()
                }
            }
        }
    }
    
    func addLine() {
        // Line view
        let lineView = UIView()
        lineView.backgroundColor = KMAUIConstants.shared.KMAUIGreyLineColor.withAlphaComponent(0.2)
        lineView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
        stackView.addArrangedSubview(lineView)
        lineView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0).isActive = true
        lineView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0).isActive = true
    }
}
