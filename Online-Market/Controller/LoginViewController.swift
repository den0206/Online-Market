//
//  LoginViewController.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/09.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    let HUD = JGProgressHUD(style: .dark)
    var activityIndicator : NVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), padding: nil)
    }
    //MARK: IBActions
    
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if checkTextField() {
            // no empty(error)
            // login User
             
            loginUser()
        } else {
            HUD.textLabel.text = "全ての項目を埋めてください"
            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
            HUD.show(in: self.view)
            HUD.dismiss(afterDelay: 3.0)
        }
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        
        if checkTextField() {
            // no empty(error)
            // register User
            registerUser()
            
        } else {
            HUD.textLabel.text = "全ての項目を埋めてください"
            HUD.indicatorView = JGProgressHUDErrorIndicatorView()
            HUD.show(in: self.view)
            HUD.dismiss(afterDelay: 3.0)
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        dismissView()
    }
    
    //MARK: register User
    
    private func registerUser() {
        
        showLoadingIndicator()
        
        MUser.registerUser(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil {
                // no error
//                self.HUD.textLabel.text = "Eメールを送りました！"
                self.HUD.textLabel.text = "登録しました！"
                self.HUD.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.HUD.show(in: self.view)
                self.HUD.dismiss(afterDelay: 3.0)
                
            } else {
                print(error!.localizedDescription)
                self.HUD.textLabel.text = "登録に失敗しました\(error!.localizedDescription)"
                self.HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                self.HUD.show(in: self.view)
                self.HUD.dismiss(afterDelay: 3.0)
            }
            
            self.hideLoadingIndicator()
        }
    }
    
    //MARK: Login User
    
    private func loginUser() {
        
        showLoadingIndicator()
        
        MUser.loginUserWithNoEmailV(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error == nil {
                // no error
                    self.dismissView()

            } else {
                print(error!.localizedDescription)
                self.HUD.textLabel.text = "ユーザーが見つかりません"
                self.HUD.indicatorView = JGProgressHUDErrorIndicatorView()
                self.HUD.show(in: self.view)
                self.HUD.dismiss(afterDelay: 3.0)
            }

            self.hideLoadingIndicator()
        }
        
        //MARK: Eメール認証　今回使わず
        
//        MUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
//
//            if error == nil {
//                // no error
//
//                if isEmailVerified {
//                    self.dismissView()
//                    print("Eメール認証に成功しました")
//                } else {
//                    self.HUD.textLabel.text = "Eメール認証を行ってください"
//                    self.HUD.indicatorView = JGProgressHUDErrorIndicatorView()
//                    self.HUD.show(in: self.view)
//                    self.HUD.dismiss(afterDelay: 3.0)
//                }
//
//            } else {
//                print(error!.localizedDescription)
//                self.HUD.textLabel.text = "ユーザーが見つかりません"
//                self.HUD.indicatorView = JGProgressHUDErrorIndicatorView()
//                self.HUD.show(in: self.view)
//                self.HUD.dismiss(afterDelay: 3.0)
//            }
//
//            self.hideLoadingIndicator()
//        }
    }
    
    //MARK: helper
    
    private func checkTextField () -> Bool {
        
        return (emailTextField.text != "" && passwordTextField.text != "" )
        
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: ACtivity Indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
        }
        
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator?.stopAnimating()
        }
        
    }
    
    
    
}
