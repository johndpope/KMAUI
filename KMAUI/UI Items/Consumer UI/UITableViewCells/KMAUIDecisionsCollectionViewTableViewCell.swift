//
//  KMAUISubLandImagesTableViewCell.swift
//  KMA EYES CITIZENS
//
//  Created by Stanislav Rastvorov on 16.04.2020.
//  Copyright © 2020 Stanislav Rastvorov. All rights reserved.
//

import UIKit

public class KMAUIDecisionsCollectionViewTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet public weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    public static let id = "KMAUIDecisionsCollectionViewTableViewCell"
    public var decisions = [KMAUIMinistryDecisionStruct]() {
        didSet {
            setupCell()
        }
    }
    public var callback: ((Int) -> Void)?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // No selection required
        selectionStyle = .none
    }
    
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        // Register collection view cells
        let bundle = Bundle(for: KMAUIDecisionCollectionViewCell.self)
        collectionView.register(UINib(nibName: KMAUIDecisionCollectionViewCell.id, bundle: bundle), forCellWithReuseIdentifier: KMAUIDecisionCollectionViewCell.id)
        
        let cellSize = CGSize(width: 240, height: 172)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        // Propery horizontal collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView data source and delegate methods

extension KMAUIDecisionsCollectionViewTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return decisions.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: KMAUIDecisionCollectionViewCell.id, for: indexPath) as? KMAUIDecisionCollectionViewCell {
            imageCell.decision = decisions[indexPath.row]
            return imageCell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        callback?(indexPath.row)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let itemCell = collectionView.cellForItem(at: indexPath) as? KMAUIDecisionCollectionViewCell {
            itemCell.rightArrowImageView.tintColor = UIColor.white
            itemCell.rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAUIBlackTitleButton
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let itemCell = collectionView.cellForItem(at: indexPath) as? KMAUIDecisionCollectionViewCell {
            // Give a small delay before deselect
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                itemCell.rightArrowImageView.tintColor = KMAUIConstants.shared.KMAUIGreyLineColor
                itemCell.rightArrowImageView.backgroundColor = KMAUIConstants.shared.KMAProgressGray
            }
        }
    }
}
