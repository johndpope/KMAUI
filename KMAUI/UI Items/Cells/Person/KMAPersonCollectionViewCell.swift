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
    @IBOutlet public weak var pieChartView: PieChartView!
    @IBOutlet public weak var barChartView: BarChartView!
    
    // MARK: - Variables
    public var type = ""
    public var peopleArray = [KMAPerson]()
    public var ageDistributionArray = [Double]()
    public var ageStringsArray = [String]()
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
        pieChartView.alpha = 0
        barChartView.alpha = 0
        
        if type == "gender" {
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
                pieChartView.alpha = 1
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
                
                data.setValueFont(.systemFont(ofSize: 10, weight: .regular))
                data.setValueTextColor(.white)
                
                pieChartView.data = data
                pieChartView.notifyDataSetChanged()
            }
        } else if type == "age" {
            barChartView.alpha = 1
            
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
                        print("\(person.username.formatUsername()), age: \(age)")
                        
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
                barChartView.alpha = 1
                
                let xAxis = barChartView.xAxis
                xAxis.drawAxisLineEnabled = false
                xAxis.drawGridLinesEnabled = false
                xAxis.labelPosition = .bottom
                xAxis.valueFormatter = axisFormatDelegate
                
                let leftAxis = barChartView.leftAxis
                leftAxis.drawAxisLineEnabled = false
                leftAxis.drawGridLinesEnabled = false
                leftAxis.drawLabelsEnabled = false
                
                let rightAxis = barChartView.rightAxis
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
                data.setValueFont(.systemFont(ofSize: 10, weight: .regular))
                
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
                
                barChartView.data = data
            }
        }
    }
}

extension KMAPersonCollectionViewCell: IAxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if Int(value) >= 0, Int(value) < ageStringsArray.count {
            return ageStringsArray[Int(value)]
        }
        
        return ""
    }
}
