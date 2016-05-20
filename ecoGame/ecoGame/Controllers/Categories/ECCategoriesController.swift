//
//  ECCategoriesController.swift
//  ecoGame
//
//  Created by timofticiuc andrei on 02/05/16.
//  Copyright © 2016 timofticiuc andrei. All rights reserved.
//

import UIKit


class ECCategoriesController: UICollectionViewController {
    var user:ECUser! = nil

    let kMinLineSpacing: CGFloat = 50
    let kMinInteritemSpacing: CGFloat = 10
    let kEdgeInset: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        self.collectionView!.ec_registerCell(ECCategoryCell)
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
        return CGSizeMake(defaultWidth, defaultWidth)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kMinLineSpacing
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kMinInteritemSpacing
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:ECCategoryCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ECCategoryCell), forIndexPath: indexPath) as! ECCategoryCell
        let category:ECCategory = (self.user.userCategories as [ECCategory])[indexPath.row]
        cell.category = category

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell:ECCategoryCell = cell as! ECCategoryCell
        
        cell.categoryLevel = ECConstants.ECCategoryLevel(rawValue: Int32(arc4random()%3 + 1))
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
