//
//  KMAUIBundlesHorizontalTableViewCell.swift
//  KMA
//
//  Created by Stanislav Rastvorov on 14.07.2020.
//  Copyright © 2020 Office Mac. All rights reserved.
//

import UIKit

public class KMAUIBundlesHorizontalTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    public static let id = "KMAUIBundlesHorizontalTableViewCell"
    public var selectedBundleIndex = 0
    public var collectionViewOffset: CGFloat = 0
    public var region = KMAMapAreaStruct()
    public var bundleSelectedCallback: ((Int, CGFloat) -> Void)?
    public var bundles = [KMAUI9x9Bundle]() {
        didSet {
            setupCell()
        }
    }
    public var datasets = [KMAUIDataset]() {
        didSet {
            setupCell()
        }
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        // Background color
        contentView.backgroundColor = KMAUIConstants.shared.KMAUIViewBgColorReverse
        
        // Register collection view cells
        let bundle = Bundle(for: KMAUIBundlesCollectionViewCell.self)
        collectionView.register(UINib(nibName: KMAUIBundlesCollectionViewCell.id, bundle: bundle), forCellWithReuseIdentifier: KMAUIBundlesCollectionViewCell.id)
        
        // No selection required
        selectionStyle = .none
    }
    
    override public  func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public func setupCell() {
        let cellSize = CGSize(width: 330, height: 230)
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        // Propery horizontal collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        // Scroll to selected index
        collectionView.contentOffset = CGPoint(x: collectionViewOffset, y: 0)
    }
}

// MARK: - UICollectionView data source and delegate methods

extension KMAUIBundlesHorizontalTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Datasets mode
        if !datasets.isEmpty {
            return datasets.count
        }
        
        // Bundles mode
        return bundles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let bundleCell = collectionView.dequeueReusableCell(withReuseIdentifier: KMAUIBundlesCollectionViewCell.id, for: indexPath) as? KMAUIBundlesCollectionViewCell {
            bundleCell.isCellSelected = indexPath.row == selectedBundleIndex
            bundleCell.region = region
            
            if !datasets.isEmpty {
                bundleCell.dataset = datasets[indexPath.row]
            } else {
                bundleCell.bundle = bundles[indexPath.row]
            }
            
            return bundleCell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedBundleIndex = indexPath.row
        collectionView.reloadData()
        bundleSelectedCallback?(selectedBundleIndex, collectionView.contentOffset.x)
    }
}
