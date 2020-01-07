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
        }
    }
}

