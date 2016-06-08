//
//  ECCategoriesController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit

protocol ECCategoriesDelegate {
    func categoriesController(cc:ECCategoriesController, hasSelectedCategory category:ECCategory)
}

class ECCategoriesController: UICollectionViewController {
    var user:ECUser! = nil
    var delegate:ECCategoriesDelegate? = nil

    let kMinLineSpacing: CGFloat = 50
    let kMinInteritemSpacing: CGFloat = 10
    let kEdgeInset: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.ec_registerCell(ECCategoryOverviewCell)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.user != nil ? self.user.userCategories!.count : 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kEdgeInset, kEdgeInset, kEdgeInset, kEdgeInset);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let defaultWidth = (collectionView.frame.size.width / 3) - kMinLineSpacing
        return CGSizeMake(200, 250)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kMinLineSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kMinInteritemSpacing
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ECCategoryOverviewCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ECCategoryOverviewCell), forIndexPath: indexPath) as! ECCategoryOverviewCell
        let category:ECCategory = (self.user.userCategories as [ECCategory])[indexPath.row]
        cell.category = category

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell:ECCategoryOverviewCell = cell as! ECCategoryOverviewCell
        let category:ECCategory = (self.user.userCategories as [ECCategory])[indexPath.row]
        
        cell.categoryLevel = category.userLevel
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.categoriesController(self, hasSelectedCategory: (self.user.userCategories as [ECCategory])[indexPath.row])
    }

}
