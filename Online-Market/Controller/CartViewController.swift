//
//  CartViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/08.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import JGProgressHUD

class CartViewController: UIViewController {


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var cartTotalView: UILabel!
    
    @IBOutlet weak var totalItemLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var cart : Cart?
    var allItems : [Item] = []
    var purchasedItemIds : [String] = []
    
    let HUD = JGProgressHUD(style: .dark)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadCartFromFirestore()

    }

//    MARK: IBActions
    
 
    @IBAction func checkoutBUttonPressed(_ sender: Any) {
        
    }
    
    //MARK:Load Cart
    
    private func loadCartFromFirestore() {
        
        downloadCartFromFirestore("1234") { (cart) in
            self.cart = cart
            self.getCartItems()
        }
    }
    
    private func getCartItems() {

        if cart != nil {
            downloadItems(cart!.itemIds) { (allItems) in
                self.allItems = allItems
                
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }

    }
    
    
    private func updateTotalLabels(_ isEmpty : Bool) {
        
        if isEmpty {
            totalItemLabel.text = "0"
            cartTotalView.text = returnBasketTotoalPrice()
            
        } else {
            totalItemLabel.text = "\(allItems.count)"
            cartTotalView.text = returnBasketTotoalPrice()
        }
        
        checkoutButtonStatusUpdate()
    }
    
    private func returnBasketTotoalPrice() -> String {
        
        var totalPrice : Double = 0.0
        for item in allItems {
            totalPrice += item.price
        }
        
        return convertCurrency(totalPrice)
    }
    
    private func checkoutButtonStatusUpdate() {
        
        checkoutButton.isEnabled = allItems.count > 0
        
        if checkoutButton.isEnabled {
            checkoutButton.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        } else {
            disableCheckoutButton()
        }
    }
    
    private func disableCheckoutButton() {
        checkoutButton.isEnabled = false
        checkoutButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    }
    
    private func removeItemFromCart(itemID : String) {
        
        for i in 0 ..< cart!.itemIds.count {
            if itemID == cart!.itemIds[i] {
                cart!.itemIds.remove(at: i)
                
                return
            }
        }
    }

}

extension CartViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        cell.generateCell(allItems[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = allItems[indexPath.row]
        
        showItemView(item)
        
    }
    
    private func showItemView(_ item : Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! DetailItemViewController
        
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: delete
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            
            // remove itemID from Cart object
            removeItemFromCart(itemID: itemToDelete.id)
            
            // delete from Firestore
            updateCartInFirestore(cart!, withValues: [kITEMSIDS : cart!.itemIds]) { (error) in
                
                if error != nil {
                    print(error?.localizedDescription)
                }
                
                self.getCartItems()
            }
            
        }
    }
    
    
}
