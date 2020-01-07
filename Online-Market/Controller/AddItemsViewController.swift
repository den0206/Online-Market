//
//  AddItemsViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/06.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemsViewController: UIViewController {
    
  
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var category : Category!
    var gallery : GalleryController!
    var hud = JGProgressHUD(style: .dark)
    
    var activityIndicator : NVActivityIndicatorView?
    
    var itemImages : [UIImage?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1) , padding: nil)
        
    }
    
    
    //MARK: IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if fieldAreCompleted() {
            saveToFirebase()
        } else {
            
            self.hud.textLabel.text = "全ての項目を埋めてください"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            
            self.hud.dismiss(afterDelay: 3.0)
        }
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        // reset Images
        itemImages = []
        
        showGallary()
    }
    
    @IBAction func backGroundTapped(_ sender: Any) {
        
        dismissKeyboard()
    }
    
    //MARK: helper
    
    private func fieldAreCompleted() -> Bool {
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextView.text != "" )
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    // dismiss View
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    //MARK: Save Item
    
    private func saveToFirebase() {
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text
        item.description = descriptionTextView.text
        item.categoryId = category.id
        item.price = Double(priceTextField.text!)
        
        if itemImages.count > 0 {
            
            uploadeImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                
                print(imageLinkArray)
                item.imagelinks = imageLinkArray
                
                saveItemToFirestore(item)
                self.hideLoadingIndicator()
                
                self.popTheView()
                
               
            }
            
        } else {
            saveItemToFirestore(item)
            
            self.hideLoadingIndicator()
            popTheView()
        }
        
        
    }
    
    //MARK: Activity Indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
        
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
        
    }
    
    //MARK: SHow Gallary
    private func showGallary() {
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 3
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
}

extension AddItemsViewController : GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
                controller.dismiss(animated: true, completion: nil)
                
                
            }
        }
        
    }
    
    // no to Use
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
