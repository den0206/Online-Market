//
//  FinishRegistrationViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/11.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    var HUD = JGProgressHUD(style: .dark)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButtonOutlet.isEnabled = false
         
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surNameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
    }
    
    //MARK: IBActions
    
    @objc func textFieldDidChange(_ textField : UITextField) {
        
        updateDoneBttonStatus()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        if checkTectField() {
            print("aa")
        } else {
            HUD.textLabel.text = "全ての項目を埋めてください"
            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
            HUD.show(in: self.view)
            HUD.dismiss(afterDelay: 3.0)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    private func checkTectField() -> Bool {
        
        return (nameTextField.text != "" && surNameTextField.text != "" && addressTextField.text != "")
    }
    
    //MARK: Helper
    private func updateDoneBttonStatus() {
        
        if nameTextField.text != "" &&  surNameTextField.text != "" && addressTextField.text != "" {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            doneButtonOutlet.isEnabled = true
        } else {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            doneButtonOutlet.isEnabled = false
        }
    }
    

}
