
//
//  InterestCollectionViewCell.swift
//  Interests
//
//  Created by Duc Tran on 3/6/17.
//  Copyright © 2017 Developer Inspirus. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
  
    var interest: Interest? {
        didSet {
            self.updateUI()
        }
    }
    
    private func updateUI()
    {
        if let interest = interest {
            //featuredImageView.image = interest.featuredImage
            interestTitleLabel.text = interest.title
            //backgroundColorView.backgroundColor = interest.color
            
           let randomInt = Int.random(in: 0..<6)
            print (randomInt)
            switch randomInt {
            case 0:
                backgroundColorView.backgroundColor = UIColor(red: 105/255.0, green: 80/255.0, blue: 227/255.0, alpha: 0.8)
            case 1:
                backgroundColorView.backgroundColor = UIColor(red: 102/255.0, green: 102/255.0, blue: 102/255.0, alpha: 0.8)
            case 2:
                backgroundColorView.backgroundColor = UIColor(red: 245/255.0, green: 62/255.0, blue: 40/255.0, alpha: 0.8)
            case 3:
                backgroundColorView.backgroundColor = UIColor(red: 103/255.0, green: 217/255.0, blue: 87/255.0, alpha: 0.8)
            case 4:
                backgroundColorView.backgroundColor = UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8)
            case 5:
                backgroundColorView.backgroundColor = UIColor(red: 240/255.0, green: 133/255.0, blue: 91/255.0, alpha: 0.8)
            default:
                backgroundColorView.backgroundColor = UIColor(red: 240/255.0, green: 133/255.0, blue: 91/255.0, alpha: 0.8)
            }
            
        }
            
         else {
            featuredImageView.image = nil
            interestTitleLabel.text = nil
            backgroundColorView.backgroundColor = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 5, height: 10)
        
        self.clipsToBounds = false
    }
}






















