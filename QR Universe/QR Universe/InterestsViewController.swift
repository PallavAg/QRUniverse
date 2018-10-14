//
//  InterestsCollectionViewController.swift
//  Interests
//
//  Created by Duc Tran on 3/6/17.
//  Copyright © 2017 Developer Inspirus. All rights reserved.
//

import UIKit
import Disk

class InterestsViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var interests = [Interest] ()

    let cellScaling: CGFloat = 0.6
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            self.interests = try Disk.retrieve("contacts.json", from: .caches, as: [Interest].self)
        } catch {
            print("loading list failed")
        }

        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * cellScaling)
        let cellHeight = floor(screenSize.height * cellScaling)
        
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        
        let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    @IBAction func clearAction(_ sender: Any) {
        viewDidAppear(true)

        do {

            try Disk.remove("contacts.json", from: .caches)
            self.interests = [Interest]()
            self.collectionView.reloadData()
        } catch {
            print ("not working")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        do {
            self.interests = try Disk.retrieve("contacts.json", from: .caches, as: [Interest].self)
            self.collectionView.reloadData()
        } catch {
            print("loading list failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (self.isMovingFromParent)  {
            // we're already on the navigation stack
            // another controller must have been popped off
//            do {
//                self.interests = try Disk.retrieve("contacts.json", from: .caches, as: [Interest].self)
//                self.collectionView.reloadData()
//            } catch {
//                print("loading list failed")
//            }
        }
    }
}

extension InterestsViewController : UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InterestCell", for: indexPath) as! InterestCollectionViewCell
        
        cell.interest = interests[indexPath.item]
        
        return cell
    }
}

extension InterestsViewController : UIScrollViewDelegate, UICollectionViewDelegate
{
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
}



















