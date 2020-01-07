//
//  CategoryCollectionViewCell.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/06.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func generateCell(_ category : Category){
        
        nameLabel.text = category.name
        imageView.image = category.image
        
    }
    

    
}
