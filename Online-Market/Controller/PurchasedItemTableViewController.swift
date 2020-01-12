//
//  PurchasedItemTableViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/11.
//  Copyright © 2020 Yuukisakai. All rights reserved.
//

import UIKit

class PurchasedItemTableViewController: UITableViewController {
    
    var itemsArray :[Item] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemTableViewCell
        
        cell.generateCell(itemsArray[indexPath.row])
        
        return cell
    }
    
    //MARK: Load Items
    
    private func loadItems() {
        
        downloadItems(MUser.currentUser()!.purchasedItemids) { (allItems) in
            
            self.itemsArray = allItems
            print(allItems.count)
            self.tableView.reloadData()
        }
    }
  

}
