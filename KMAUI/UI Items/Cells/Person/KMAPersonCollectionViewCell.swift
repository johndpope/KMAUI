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
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var barChartView: BarChartView!
    
    // MARK: - Variables
    public var type = ""
    public var peopleArray = [KMAPerson]()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
                male = Double(Int((male / total) * 10000)) / 100
                female = Double(Int((female / total) * 10000)) / 100
                other = Double(Int((other / total) * 10000)) / 100
                
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
                
                let dataSet = PieChartDataSet(entries: dataEntries, label: "Gender distribution, %")
                dataSet.colors = ChartColorTemplates.pastel()
                let data = PieChartData(dataSet: dataSet)
                pieChartView.data = data
                pieChartView.notifyDataSetChanged()
            }
        } else if type == "age" {
            barChartView.alpha = 1
            
            let ageStrings = ["13-17", "18-24", "25-34", "35-44", "45-54", "55-64", "65+"]
            let ageRanges = [[13, 17], [18, 24], [25, 34], [35, 44], [45, 54], [55, 64], [65]]
            var ageDistribution = [0, 0, 0, 0, 0, 0, 0]
            
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
                            } else if ageRange.count == 1, ageRange[0] <= age {
                                ageDistribution[index] = ageDistribution[index] + 1
                            }
                        }
                    }
                }
            }
            
            var ageDistributionArray = [Int]()
            var ageStringsArray = [String]()
            
            for (index, ageItem) in ageDistribution.enumerated() {
                if ageItem != 0 {
                    ageDistributionArray.append(ageItem)
                    ageStringsArray.append(ageStrings[index])
                }
            }
            
            print("Age distribution: \(ageStrings), \(ageDistribution)")

            let entry1 = BarChartDataEntry(x: 0, y: 100)
            let entry2 = BarChartDataEntry(x: 1, y: 250)
            let entry3 = BarChartDataEntry(x: 2, y: 60)
            let dataSet = BarChartDataSet(entries: [entry1, entry2, entry3], label: "Age distribution")
            dataSet.colors = ChartColorTemplates.pastel()
            let data = BarChartData(dataSets: [dataSet])
            barChartView.data = data
//            barChart.chartDescription?.text = "Number of Widgets by Type"

            //All other additions to this function will go here

            //This must stay at end of function
            barChartView.notifyDataSetChanged()
        }
    }
}

