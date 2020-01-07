//
//  ItemTableViewCell.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(_ item : Item) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        priceLabel.text = convertCurrency(item.price)
        priceLabel.adjustsFontSizeToFitWidth = true
        
        // download Image
        
        if item.imagelinks != nil && item.imagelinks.count > 0 {
            print(item.imagelinks.count)
            downloadImage(imageUrls: [item.imagelinks.first!]) { (images) in
                self.itemImageView.image = images.first as? UIImage
            }
        }
    }

}
