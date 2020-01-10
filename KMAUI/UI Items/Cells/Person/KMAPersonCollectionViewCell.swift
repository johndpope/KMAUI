//
//  KMAPersonCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 06.01.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit
import Charts

public class KMAPersonCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var genderPieChartView: PieChartView!
    @IBOutlet public weak var ageBarChartView: BarChartView!
    @IBOutlet public weak var cityPieChartView: PieChartView!
    @IBOutlet public weak var propertyBarChartView: BarChartView!
    @IBOutlet public weak var uploadsHorizontalBarChartView: HorizontalBarChartView!
    @IBOutlet public weak var titleLabel: KMAUITitleLabel!
    
    // MARK: - Variables
    public var type = ""
    public var peopleArray = [KMAPerson]()
    public var ageDistributionArray = [Double]()
    public var ageStringsArray = [String]()
    public var propertyStringsArray = ["Has property", "No property"]
    public var areasArray = [[String: AnyObject]]()
    public var usernameVals = [String]()
    public weak var axisFormatDelegate: IAxisValueFormatter?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Setting the delegate connection for axis
        axisFormatDelegate = self
    }
    
    /**
     Setup the data for cell
     */
    
    public func setupCell() {
        genderPieChartView.alpha = 0
        ageBarChartView.alpha = 0
        cityPieChartView.alpha = 0
        propertyBarChartView.alpha = 0
        uploadsHorizontalBarChartView.alpha = 0
        
        if type == "age" {
            setupAgeChart()
        } else if type == "gender" {
            setupGenderChart()
        } else if type == "city" {
            setupCityChart()
        } else if type == "property" {
            setupPropertyPercentChart()
        } else if type == "uploads" {
            setupUploadsBarChart()
        }
    }
    
    // MARK: - Setup charts
    
    public func setupAgeChart() {
        ageBarChartView.alpha = 1
        ageBarChartView.doubleTapToZoomEnabled = false
        ageBarChartView.legend.enabled = false
        
        titleLabel.text = "Age distribution"
        
        let ageStrings = ["13-17", "18-24", "25-34", "35-44", "45-54", "55-64", "65+"]
        let ageRanges = [[13, 17], [18, 24], [25, 34], [35, 44], [45, 54], [55, 64], [65]]
        var ageDistribution = [0, 0, 0, 0, 0, 0, 0]
        
        ageDistributionArray = [Double]()
        ageStringsArray = [String]()
        
        var total = 0
        
        for person in peopleArray {
            if person.birthday != 0 {
                let birthday = Date(timeIntervalSince1970: person.birthday)
                let components = Set<Calendar.Component>([.year])
                let differenceOfDate = Calendar.current.dateComponents(components, from: birthday, to: Date())
                
                if let age = differenceOfDate.year {
                    for (index, ageRange) in ageRanges.enumerated() {
                        if ageRange.count == 2, ageRange[0] <= age, ageRange[1] >= age {
                            ageDistribution[index] = ageDistribution[index] + 1
                            total += 1
                        } else if ageRange.count == 1, ageRange[0] <= age {
                            ageDistribution[index] = ageDistribution[index] + 1
                            total += 1
                        }
                    }
                }
            }
        }
        
        for (index, ageItem) in ageDistribution.enumerated() {
            if ageItem > 0 {
                ageDistributionArray.append(Double(ageItem) / Double(total) * 100)
                ageStringsArray.append(ageStrings[index])
            }
        }
        
        if !ageDistributionArray.isEmpty {
            let xAxis = ageBarChartView.xAxis
            xAxis.drawAxisLineEnabled = false
            xAxis.drawGridLinesEnabled = false
            xAxis.labelPosition = .bottom
            xAxis.valueFormatter = axisFormatDelegate
            xAxis.labelTextColor = KMAUIConstants.shared.KMATextColor
            
            let leftAxis = ageBarChartView.leftAxis
            leftAxis.drawAxisLineEnabled = false
            leftAxis.drawGridLinesEnabled = false
            leftAxis.drawLabelsEnabled = false
            
            leftAxis.axisMinimum = 0
            
            let rightAxis = ageBarChartView.rightAxis
            rightAxis.drawAxisLineEnabled = false
            rightAxis.drawGridLinesEnabled = false
            rightAxis.drawLabelsEnabled = false
            
            var yVals = [BarChartDataEntry]()
            
            for (index, item) in ageDistributionArray.enumerated() {
                yVals.append(BarChartDataEntry(x: Double(index), y: item))
            }
            
            let set = BarChartDataSet(entries: yVals, label: "Age distribution")
            set.colors = ChartColorTemplates.pastel()
            set.valueColors = ChartColorTemplates.pastel()
            
            let data = BarChartData(dataSet: set)
            data.setValueFont(.systemFont(ofSize: 12, weight: .regular))
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.barWidth = 0.9
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = "%"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            ageBarChartView.data = data
            ageBarChartView.notifyDataSetChanged()
        }
    }
    
    public func setupGenderChart() {
        genderPieChartView.alpha = 1
        genderPieChartView.legend.enabled = false
        
        titleLabel.text = "Gender distribution"
        
        var male: Double = 0
        var female: Double = 0
        var other: Double = 0
        
        for person in peopleArray {
            if person.gender == "Male" {
                male += 1
            } else if person.gender == "Female" {
                female += 1
            } else if person.gender == "Other" {
                other += 1
            }
        }
        
        let total = male + female + other
        
        if total > 0 {
            male = male / total * 100
            female = female / total * 100
            other = other / total * 100
            
            var dataEntries = [PieChartDataEntry]()
            
            if male > 0 {
                dataEntries.append(PieChartDataEntry(value: male, label: "Male"))
            }
            
            if female > 0 {
                dataEntries.append(PieChartDataEntry(value: female, label: "Female"))
            }
            
            if other > 0 {
                dataEntries.append(PieChartDataEntry(value: other, label: "Other"))
            }
            
            let dataSet = PieChartDataSet(entries: dataEntries, label: "Gender distribution")
            dataSet.colors = ChartColorTemplates.pastel()
            let data = PieChartData(dataSet: dataSet)
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = "%"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            data.setValueFont(.systemFont(ofSize: 12, weight: .light))
            data.setValueTextColor(UIColor.white)
            
            genderPieChartView.data = data
            genderPieChartView.notifyDataSetChanged()
        }
    }
    
    public func setupCityChart() {
        cityPieChartView.alpha = 1
        cityPieChartView.legend.enabled = false
        
        titleLabel.text = "Area stats"
        
        var areas = [String: Int]()
        var total = 0
        
        for personObject in peopleArray {
            if !personObject.city.isEmpty, !personObject.country.isEmpty {
                let cityCountry = personObject.city + ", " + personObject.country
                
                if let value = areas[cityCountry] {
                    areas[cityCountry] = value + 1
                } else {
                    areas[cityCountry] = 1
                }
                
                total += 1
            }
        }
        
        areasArray = [[String: AnyObject]]()
        
        for (key, value) in areas {
            if areasArray.count < 5 {
                let cityArray = key.components(separatedBy: ", ")
                
                if !cityArray.isEmpty {
                    areasArray.append(["city": cityArray[0] as AnyObject, "count": value as AnyObject])
                }
            }
        }
        
        areasArray = KMAUIUtilities.shared.orderCount(crimes: areasArray)
        
        if !areasArray.isEmpty {
            cityPieChartView.alpha = 1

            var dataEntries = [PieChartDataEntry]()
            
            for area in areasArray {
                if let city = area["city"] as? String, let count = area["count"] as? Int {
                    dataEntries.append(PieChartDataEntry(value: Double(count) / Double(total) * 100, label: city))
                }
            }
            
            let dataSet = PieChartDataSet(entries: dataEntries, label: "Area stats")
            dataSet.colors = ChartColorTemplates.pastel()
            let data = PieChartData(dataSet: dataSet)
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = "%"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            data.setValueFont(.systemFont(ofSize: 12, weight: .light))
            data.setValueTextColor(UIColor.white)
            
            cityPieChartView.data = data
            cityPieChartView.notifyDataSetChanged()
        }
    }
    
    public func setupPropertyPercentChart() {
        propertyBarChartView.alpha = 1
        propertyBarChartView.doubleTapToZoomEnabled = false
        propertyBarChartView.legend.enabled = false
        
        titleLabel.text = "Property owners percentage"
        
        var hasPropertyCount = 0
        var noPropertyCount = 0
        
        for personObject in peopleArray {
            if personObject.propertyCount > 0 {
                hasPropertyCount += 1
            } else {
                noPropertyCount += 1
            }
        }
        
        if hasPropertyCount + noPropertyCount > 0 {
            let hasPercent = Double(hasPropertyCount) / Double(hasPropertyCount + noPropertyCount) * 100
            let noPercent = Double(noPropertyCount) / Double(hasPropertyCount + noPropertyCount) * 100
            
            let xAxis = propertyBarChartView.xAxis
            xAxis.drawAxisLineEnabled = false
            xAxis.drawGridLinesEnabled = false
            xAxis.labelPosition = .bottom
            
            xAxis.axisMinimum = -0.5
            xAxis.axisMaximum = 1.5
            xAxis.labelCount = 4
            xAxis.valueFormatter = axisFormatDelegate
            
            xAxis.labelTextColor = KMAUIConstants.shared.KMATextColor
            
            let leftAxis = propertyBarChartView.leftAxis
            leftAxis.drawAxisLineEnabled = false
            leftAxis.drawGridLinesEnabled = false
            leftAxis.drawLabelsEnabled = false
            
            leftAxis.axisMinimum = 0
            
            let rightAxis = propertyBarChartView.rightAxis
            rightAxis.drawAxisLineEnabled = false
            rightAxis.drawGridLinesEnabled = false
            rightAxis.drawLabelsEnabled = false
            
            var yVals = [BarChartDataEntry]()
            
            propertyStringsArray = [String]()
            
            if hasPercent > noPercent {
                if hasPercent > 0 {
                    yVals.append(BarChartDataEntry(x: 0, y: hasPercent))
                }
                
                if noPercent > 0 {
                    yVals.append(BarChartDataEntry(x: 1, y: noPercent))
                }
                
                propertyStringsArray = ["Has property", "No property"]
            } else if hasPercent < noPercent {
                if noPercent > 0 {
                    yVals.append(BarChartDataEntry(x: 0, y: noPercent))
                }
                
                if hasPercent > 0 {
                    yVals.append(BarChartDataEntry(x: 1, y: hasPercent))
                }
                
                propertyStringsArray = ["No property", "Has property"]
            }

            let set = BarChartDataSet(entries: yVals, label: "Property owners percentage")
            set.colors = ChartColorTemplates.pastel()
            set.valueColors = ChartColorTemplates.pastel()
            
            let data = BarChartData(dataSet: set)
            data.setValueFont(.systemFont(ofSize: 12, weight: .light))
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 1
            data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
            data.barWidth = 0.9
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .percent
            pFormatter.maximumFractionDigits = 1
            pFormatter.multiplier = 1
            pFormatter.percentSymbol = "%"
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            propertyBarChartView.data = data
            propertyBarChartView.notifyDataSetChanged()
        }
    }
    
    public func setupUploadsBarChart() {
        uploadsHorizontalBarChartView.alpha = 1
        uploadsHorizontalBarChartView.doubleTapToZoomEnabled = false
        uploadsHorizontalBarChartView.legend.enabled = false
        
        titleLabel.text = "Most active users by uploads"
        
        var maxCount = 0
        
        var yVals = [BarChartDataEntry]()
        var yValsBackup = [BarChartDataEntry]()
        usernameVals = [String]()
        var usernameValsBackup = [String]()
        
        for (index, personObject) in peopleArray.enumerated() {
            if index >= 5 {
                break
            } else {
                if personObject.uploadsCount > 0 {
                    yValsBackup.append(BarChartDataEntry(x: Double(index), y: Double(personObject.uploadsCount)))
                    usernameValsBackup.append(personObject.username.formatUsername())
                    
                    if maxCount < personObject.uploadsCount {
                        maxCount = personObject.uploadsCount
                    }
                }
            }
        }
        
        if !yValsBackup.isEmpty {
            for (index, item) in yValsBackup.enumerated() {
                yVals.insert(BarChartDataEntry(x: Double(yValsBackup.count) - Double(index) - 1, y: item.y), at: 0)
            }
            
            for item in usernameValsBackup {
                usernameVals.insert(item, at: 0)
            }
            
            print("Username vals: \(usernameVals)")
            
            let set = BarChartDataSet(entries: yVals, label: "Most active users by uploads")
            set.drawIconsEnabled = false
            
            set.colors = ChartColorTemplates.pastel()
            set.valueColors = ChartColorTemplates.pastel()
            
            let data = BarChartData(dataSet: set)
            data.setValueFont(.systemFont(ofSize: 12, weight: .light))
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .decimal
            pFormatter.maximumFractionDigits = 0
            pFormatter.multiplier = 1
            data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
            
            let xAxis = uploadsHorizontalBarChartView.xAxis
            xAxis.drawAxisLineEnabled = false
            xAxis.drawGridLinesEnabled = false
            xAxis.labelPosition = .bottom
            
            xAxis.labelTextColor = KMAUIConstants.shared.KMATextColor
            
            xAxis.axisMinimum = -0.5
            xAxis.axisMaximum = Double(yVals.count - 1) + 0.5
            xAxis.labelCount = yVals.count * 2 + 1
            xAxis.valueFormatter = axisFormatDelegate
            
            let leftAxis = uploadsHorizontalBarChartView.leftAxis
            leftAxis.drawAxisLineEnabled = false
            leftAxis.drawGridLinesEnabled = false
            leftAxis.drawLabelsEnabled = false
            
            leftAxis.axisMinimum = 0
            leftAxis.axisMaximum = Double(maxCount) * 1.1
            
            let rightAxis = uploadsHorizontalBarChartView.rightAxis
            rightAxis.drawAxisLineEnabled = false
            rightAxis.drawGridLinesEnabled = false
            rightAxis.drawLabelsEnabled = false
            
            uploadsHorizontalBarChartView.data = data
        }
    }
}

extension KMAPersonCollectionViewCell: IAxisValueFormatter {
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if type == "age", Int(value) >= 0, Int(value) < ageStringsArray.count {
            return ageStringsArray[Int(value)]
        } else if type == "property", Int(value) >= 0, Int(value) < propertyStringsArray.count, (value == 0 || value == 1) {
            return propertyStringsArray[Int(value)]
        } else if type == "uploads", floor(value) == value, Int(value) < usernameVals.count {
            return usernameVals[Int(value)]
        }
        
        return ""
    }
}
