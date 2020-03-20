//
//  KMAUIDocumentCollectionViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 20.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDocumentCollectionViewCell: UICollectionViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var documentImageView: UIImageView!
    @IBOutlet public weak var documentNameLabel: KMAUIBoldTextLabel!
    @IBOutlet public weak var dateLabel: KMAUIRegularTextLabel!
    @IBOutlet public weak var infoLabel: KMAUIRegularTextLabel!
    
    // MARK: - Variables
    public static let id = "KMAUIDocumentCollectionViewCell"
    public var document = KMAPropertyDocument() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setupCell() {
        
    }
}
