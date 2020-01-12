//
//  SearchViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/12.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchOptionView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    var searchResults : [Item] = []
    
    var activityIndocator : NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        searchOptionView.isHidden = true
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndocator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballBeat, color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), padding: nil)
    }
    
    
    //MARK: IBActuons
    
    @IBAction func showSearchBarButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        showSearchField()
        
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        showIndicator()
        
        
    }
    
    //MARK: helper
    
    private func cleanTextField() {
        searchTextField.text = ""
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func  showSearchField() {
        
        cleanTextField()
        animateSearchOptionIn()
        
    }
    
    @objc func textFieldDidChange(_ textField : UITextField) {
        
//        searchButtonOutlet.isEnabled = searchTextField.text != ""
//        
        
        if searchTextField.text != "" {
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            searchButtonOutlet.isEnabled = true
        } else {
           searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            searchButtonOutlet.isEnabled = false
        }
    }
    
    //MARK: Aimation
    
    private func animateSearchOptionIn() {
        UIView.animate(withDuration: 0.5) {
            self.searchOptionView.isHidden = !self.searchOptionView.isHidden
        }
    }
    
    //MARK: Activity-Indcator
    
    private func showIndicator() {
        
        if activityIndocator != nil {
            self.view.addSubview(activityIndocator!)
            activityIndocator?.startAnimating()
        }
    }
    
    private func hideIndicator() {
        
        if activityIndocator != nil {
            activityIndocator?.removeFromSuperview()
            activityIndocator?.stopAnimating()
        }
        
    }
}



extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ItemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        showItemPage(searchResults[indexPath.row])
    }
    
    private func showItemPage(_ item : Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! DetailItemViewController
        
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
        
        
    }
    
}


