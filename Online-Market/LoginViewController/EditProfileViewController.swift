//
//  EditProfileViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIBarButtonItem!
    
    let HUD = JGProgressHUD(style: .dark)

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUserProgile()
    }
    
    //MARK: IBActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if checkTextField() {
            editUserProfile()
        } else {
            
            HUD.textLabel.text = "すべての項目を埋めてください。"
            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
            HUD.show(in: self.view)
            HUD.dismiss(afterDelay: 3.0)
        }
        
        
        
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        
        logoutUser()
        
    }
    
    // Edit User
    
    private func editUserProfile() {
        
        let withValues = [kFIRSTNAME : nameTextField.text!,
                          kLASTNAME : surNameTextField.text!,
                          kFULLADRESS : addressTextField.text!,
                          kFULLNAME : (nameTextField.text! + " " + surNameTextField.text!)] as [String : Any]
        
        updateCurrentUserInFireStore(withValues: withValues) { (error) in
            
            if error == nil {
                // no error
                self.HUD.textLabel.text = "更新しました"
                self.HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.HUD.show(in: self.view)
                self.HUD.dismiss(afterDelay: 3.0)
                
            } else {
                print("エラー", error?.localizedDescription)
                
                self.HUD.textLabel.text = "更新に失敗しました"
                self.HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                self.HUD.show(in: self.view)
                self.HUD.dismiss(afterDelay: 3.0)
            }
        }
        
    }
    
    //MARK: Logout User
    
    private func logoutUser() {
        
        MUser.logOutCurrentUser { (error) in
            
            if error == nil {
                // no error
                print("log Out")
                self.navigationController?.popViewController(animated: true)
                
            } else {
                print(" エラー\(error?.localizedDescription)")
            }
        }
        
    }
    
    //MARK: heloer
    
    private func setUserProgile() {
        
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            surNameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAdress
        }
       
    }
    
    private func checkTextField() -> Bool{
        
        return (nameTextField.text != "" && surNameTextField.text != "" && addressTextField.text != "")
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    

}
