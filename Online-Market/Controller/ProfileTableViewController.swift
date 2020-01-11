//
//  ProfileTableViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import Firebase

class ProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var histroryButtonOutlet: UIButton!
    
    var editBarButtonOutlet : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoginStatus()
        checkOnboadingStatus()
        
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    
    //MARK: no use because static Cells
   
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        return UITableViewCell()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    //MARK: Helpers
    
    private func checkOnboadingStatus() {
        
        if MUser.currentUser() != nil {
            // login now
            
            if MUser.currentUser()!.onBoard {
                
                finishRegistrationButtonOutlet.setTitle("Account Is Active", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = false
            } else {
                finishRegistrationButtonOutlet.setTitle("finish Registration", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = true
                finishRegistrationButtonOutlet.tintColor = .red
            }
            
        } else {
            
            finishRegistrationButtonOutlet.setTitle("Logged Out", for: .normal)
            finishRegistrationButtonOutlet.isHidden = false
            histroryButtonOutlet.isHidden = false
        }
    }
    
    private func checkLoginStatus() {
        
        if MUser.currentUser() == nil {
            
            createRightBarButton(title: "login")
        } else {
            
            // login Now
            
            createRightBarButton(title: "Edit")
        }
        
    }
    
    private func createRightBarButton(title : String) {
           
        editBarButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonPressed))
        self.navigationItem.rightBarButtonItem = editBarButtonOutlet
           
       }
    
    
    
    //MARK: IBACtions
    
    @objc func rightBarButtonPressed() {
        
        if editButtonItem.title == "Login" {
            // show LoginView
            showLoginVC()
        } else {
            // go to Edit Profile
            
            showEditProfileVC()
            
        }
        
    }
    
    private func showLoginVC() {
        
        let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginVC")
        
        present(loginVC, animated: true, completion: nil)
    }
    
    private func showEditProfileVC() {
        print("editProfile")
    }
    
    
    

}
