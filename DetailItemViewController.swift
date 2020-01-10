//
//  DetailItemViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import JGProgressHUD

class DetailItemViewController: UIViewController {
    
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var item : Item!
    var itemImages : [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight : CGFloat = 196.0
    private let itemsPerRow : CGFloat = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        downloadPictures()
        
        // Left Button
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(named: "back"), style: .
            plain, target: self, action: #selector(backAction))]
        
        // Right Button
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "basket"), style: .
        plain, target: self, action: #selector(addCart))]

    }
    
    
    //MARK: setup UI
    
    private func setupUI() {
        
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            priceLabel.text = convertCurrency(item.price)
            descriptionTextView.text = item.description
        }
        
    }
    
    private func downloadPictures() {

        if item != nil && item.imagelinks != nil {
            downloadImage(imageUrls: item.imagelinks) { (allImages) in
                
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }

    }
    
    //MARK: IBActions
    
    
    
    @objc func addCart() {
        
//        downloadCartFromFirestore("1234") { (cart) in
//
//            if cart == nil {
//                self.createNewCart()
//            } else {
//                cart!.itemIds.append(self.item.id)
//                self.updateCart(cart: cart!, withValues: [kITEMSIDS : cart!.itemIds])
//            }
//        }
//
////        createNewCart()
//
//        // else update
        
        showLoginView()
        
    }
    
    @objc func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func showLoginView() {
        
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC")
              
              
        self.present(loginVC, animated: true, completion: nil)
          
    }
    
    // Add cart
    
    private func createNewCart() {
        
        let newCart = Cart()
        
        newCart.id = UUID().uuidString
        newCart.ownerId = "1234"
        newCart.itemIds = [self.item.id]
        saveCartToFirestore(newCart)
        
        // HUD
        
        self.hud.textLabel.text = "Add To Cart"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        
        self.hud.dismiss(afterDelay: 3.0)
        
        
    }
    
    private func updateCart(cart : Cart, withValues : [String : Any]) {
        0
        updateCartInFirestore(cart, withValues: withValues) { (error) in
            
            if error != nil {
                self.hud.textLabel.text = "Error\(error?.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                
                self.hud.dismiss(afterDelay: 3.0)
            } else {
                // no error
                
                self.hud.textLabel.text = "Add To Cart"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                
                self.hud.dismiss(afterDelay: 3.0)
                
            }
        }
        
    }


}
extension DetailItemViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        
        if itemImages.count > 0 {
            cell.setupImageWith(itemImages[indexPath.row])
        }
        
        
        return cell
    }
    
    
    
    
}

extension DetailItemViewController : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let availableWidth = collectionView.frame.width - sectionInsets.left
        
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
    
}
