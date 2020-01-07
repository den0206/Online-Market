//
//  ImageCollectionViewCell.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(_ itemImage : UIImage) {
        
        imageView.image = itemImage
        
    }
    
    
    
}
