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
        let entry1 = PieChartDataEntry(value: Double(243), label: "#1")
        let entry2 = PieChartDataEntry(value: Double(232), label: "#2")
        let entry3 = PieChartDataEntry(value: Double(123), label: "#3")
        let dataSet = PieChartDataSet(entries: [entry1, entry2, entry3], label: "Widget Types")
        let data = PieChartData(dataSet: dataSet)
        pieChartView.data = data
        pieChartView.chartDescription?.text = "Share of Widgets by Type"

        //All other additions to this function will go here

        //This must stay at end of function
        pieChartView.notifyDataSetChanged()
    }
}

