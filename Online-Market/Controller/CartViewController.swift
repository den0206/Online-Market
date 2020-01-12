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
    
    // PayPal Vars
    
    var enviroment : String = PayPalEnvironmentNoNetwork {
        willSet(newEnviroment) {
            if (newEnviroment != enviroment) {
                PayPalMobile.preconnect(withEnvironment: newEnviroment)
            }
        }
    }
    
    var payPalConfig = PayPalConfiguration()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView
        
        setupPaypal()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if MUser.currentUser() != nil {
            loadCartFromFirestore()
        } else {
            self.updateTotalLabels(true)
        }


    }

//    MARK: IBActions
    
    
    @IBAction func checkoutBUttonPressed(_ sender: Any) {
        
        if MUser.currentUser()!.onBoard {
            
            // append Ids
//            tempFunction()
            
            // update purchased
//            addItemToPurchasedHistory(self.purchasedItemIds)
//
//            resetTheCart()
            
            payButtonPressed()
            
        } else {
            
            self.HUD.textLabel.text = "アクティブして下さい。"
            self.HUD.indicatorView = JGProgressHUDErrorIndicatorView()
            self.HUD.show(in: self.view)
            self.HUD.dismiss(afterDelay: 3.0)
        }
        
    }
    
    //MARK:Load Cart
    
    private func loadCartFromFirestore() {
        
        downloadCartFromFirestore(MUser.currentID()) { (cart) in
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
    
    //MARK: Helpers
    
//    func tempFunction() {
//
//        for item in allItems {
//
//            purchasedItemIds.append(item.id)
//        }
//    }
//
    
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
    
    private func resetTheCart() {
        
        purchasedItemIds.removeAll()
        allItems.removeAll()
        
        tableView.reloadData()
        
        cart!.itemIds = []
        
        updateCartInFirestore(cart!, withValues: [kITEMSIDS : cart!.itemIds]) { (error) in
            
            if error != nil {
                print("エラー: \(error?.localizedDescription)")
            } else {
                self.getCartItems()
            }
        }
        
    }
    
    private func addItemToPurchasedHistory(_ itemIds : [String]) {
        
        if MUser.currentUser() != nil {
            
            let newItemIds = MUser.currentUser()!.purchasedItemids + itemIds
            updateCurrentUserInFireStore(withValues: [kPURCHASEDITEMIDS : newItemIds]) { (error) in
                
                if error != nil {
                    print("エラー: \(error?.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: PayPal
    
    private func setupPaypal() {
        
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "iOS Yuuki"
        
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        payPalConfig.payPalShippingAddressOption = .both
    }
    
    private func payButtonPressed() {
        
        var itemsToBuy : [PayPalItem] = []
        
        for item in allItems {
            let tempItem = PayPalItem(name: item.name, withQuantity: 1, withPrice: NSDecimalNumber(value: item.price), withCurrency: "USD", withSku: nil)
            
            purchasedItemIds.append(item.id)
            itemsToBuy.append(tempItem)
        }
        
        let subTotal = PayPalItem.totalPrice(forItems: itemsToBuy)
        
        // options
        let shippingCost = NSDecimalNumber(string: "50.0")
        let tax = NSDecimalNumber(string: "5.00")
        
        //payment
        let paymentDetails = PayPalPaymentDetails(subtotal: subTotal, withShipping: shippingCost, withTax: tax)
        
        let total = subTotal.adding(shippingCost).adding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "Payment To Yuuki", intent: .sale)
        
        payment.items = itemsToBuy
        payment.paymentDetails = paymentDetails
        
        // prresent Paypal Popup
        
        if payment.processable {
            
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            
            present(paymentViewController!, animated: true, completion: nil)
            
        } else {
            print("payment not Processible")
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

//MARK: Paypal Delegate

extension CartViewController : PayPalPaymentDelegate {
    
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("Cancel")
        paymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        
        paymentViewController.dismiss(animated: true) {
            
            // ex : send thankusFUll Email TO customer
            
            self.addItemToPurchasedHistory(self.purchasedItemIds)
            self.resetTheCart()
        }
        
    }
    
    
}
