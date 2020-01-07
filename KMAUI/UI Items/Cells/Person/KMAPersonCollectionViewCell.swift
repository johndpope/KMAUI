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
        if type == "gender" {
            var male = 0
            var female = 0
            var other = 0
            
            for person in peopleArray {
                if person.gender == "Male" {
                    male += 1
                } else if person.gender == "Female" {
                    female += 1
                } else if person.gender == "Other" {
                    other += 1
                }
            }
            
            print("Gender distribution: \(male), \(female), \(other)")
            
            let entry1 = PieChartDataEntry(value: Double(male), label: "Male")
            let entry2 = PieChartDataEntry(value: Double(female), label: "Female")
            let entry3 = PieChartDataEntry(value: Double(other), label: "Other")
            let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3], label: "")
            dataSet.colors = ChartColorTemplates.pastel()
            let data = PieChartData(dataSet: dataSet)
            pieChartView.data = data
            pieChartView.notifyDataSetChanged()
        }
    }
}

