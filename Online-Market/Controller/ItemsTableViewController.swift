//
//  ItemsTableViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/06.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {
    
    var category : Category?
    var itemArray : [Item] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
        
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            // download Items
            loadItems()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemView(itemArray[indexPath.row])
        
        
    }
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemToAddItemSeg" {
            
            let vc = segue.destination as! AddItemsViewController
            vc.category = self.category!
        }
    }
    
    private func showItemView(_ item : Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! DetailItemViewController
        
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
    //MARK: Load Items
    
    private func loadItems() {
        
        downloadItemsFromFirebase(categoryId: category!.id) { (allItems) in
            
           
            self.itemArray = allItems
            self.tableView.reloadData()
            
        }
        
    }
}
