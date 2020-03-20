//
//  KMAUIDocumentsTableViewCell.swift
//  KMAUI
//
//  Created by Stanislav Rastvorov on 19.03.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDocumentsTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet public weak var collectionView: UICollectionView!
    // MARK: - Variables
    public static let id = "KMAUIDocumentsTableViewCell"
    public var documents = [KMAPropertyDocument]() {
        didSet {
            setupCell()
        }
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // No selection  required
        selectionStyle = .none
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    public func setupCell() {
        // Register collection view cells
        let bundle = Bundle(for: KMAUIDocumentCollectionViewCell.self)
        collectionView.register(UINib(nibName: KMAUIDocumentCollectionViewCell.id, bundle: bundle), forCellWithReuseIdentifier: KMAUIDocumentCollectionViewCell.id)
        
        if let documentCell = collectionView.dequeueReusableCell(withReuseIdentifier: KMAUIDocumentCollectionViewCell.id, for: indexPath) as? KMAUIDocumentCollectionViewCell {
            print("CAN LOAD THE COLLECTION VIEW CELL!")
        }
    }
}
