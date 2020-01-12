//
//  MUser.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/10.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import FirebaseAuth

class MUser {
    
    let objectId : String
    var email : String
    var firstName :String
    var lastName : String
    var fullName : String
    var purchasedItemids : [String]
    
    var fullAdress : String?
    var onBoard : Bool
    
    init(_objectId : String,_email : String, _firstName : String, _lastName : String) {
        
        let _fullName = _firstName + " " + _lastName
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _fullName
        fullAdress = ""
        onBoard = false
        purchasedItemids = []
    }
    
    //MARK: init Dictionary
    
    init(_dictionary : NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let name = _dictionary[kFIRSTNAME] {
            firstName = name as! String
        } else {
            firstName = ""
        }
        
        
        if let last = _dictionary[kLASTNAME] {
            lastName = last as! String
        } else {
            lastName = ""
        }
        
        fullName = firstName + " " + lastName
        
        if let address = _dictionary[kFULLADRESS] {
            fullAdress = address as! String
        } else {
            fullAdress = ""
        }
        
        if let Board = _dictionary[kONBOARD] {
            onBoard = Board as! Bool
        } else {
            onBoard = false
        }
        
        if let purchased = _dictionary[kPURCHASEDITEMIDS] {
            purchasedItemids = purchased as! [String]
        } else {
            purchasedItemids = []
        }
  
    }
    
    //MARK: Return CurrentUser
    
    class func currentID() -> String{
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> MUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return MUser(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    //MARK: Login & register 前者は今回使わず
    
    
//    class func loginUserWith(email : String, password : String, completion  : @escaping(_ error : Error?, _ isEmailVerified : Bool) -> Void) {
//
//        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
//
//            if error ==  nil {
//                // no error
//                if authDataResult!.user.isEmailVerified {
//
//                    // download User From Firestore
//                    completion(error, true)
//
//                } else {
//                    print("email is not verified")
//                    completion(error, false)
//                }
//
//            } else {
//                completion(error, false)
//            }
//        }
//    }
    
    class func loginUserWithNoEmailV(email : String, password : String, completion  : @escaping(_ error : Error?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error != nil {
                completion(error)
                return
            } else {
                
                // download User From Firestore
                downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                completion(error)
            }
        }
    }
    
    class func registerUser(email : String, password : String, completion : @escaping(_ error : Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                // no error
                // send Email Verification
                
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error : ",  error?.localizedDescription)
                }
            }
        }
    }
    
    
    
    //MARK: Resend Link Method 今回使わず

    class func resetPasswordFor(email : String, compltion : @escaping(_ error : Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            compltion(error)
        }
    }
    
    class func resentVerificarionEmail(email :String, completion : @escaping(_ error : Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                
                print("resend Email Error", error?.localizedDescription)
                completion(error)
            })
        })
    }
    
    
    class func logOutCurrentUser(completion : @escaping(_ error : Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)
        } catch let error as NSError {
            completion(error)
            
        }
        
        
    }
   
    
} // End of MUser Class

//MARK: Helper

//MARK: DownLoad User in Firestore

func downloadUserFromFirestore(userId : String, email : String) {
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        guard let snapshot = snapshot else {
            return
        }
        
        if snapshot.exists {
            print("download currentUser From Firestore")
            saveUserLocal(snapshot.data()! as NSDictionary)
            
        } else {
            
            
            let user = MUser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            // local
            saveUserLocal(userDictionaryFrom(user: user))
            // save New Firestore
            saveUserToFirestore(user)
            
        }
    }
    
}

//MARK: Save User in Firestore

func saveUserToFirestore(_ user : MUser) {
    FirebaseReference(.User).document(user.objectId).setData(userDictionaryFrom(user : user) as! [String : Any]) { (error) in
        
        
        if error != nil {
            print(error!.localizedDescription)
        }
    }
}

func saveUserLocal(_ userDictionary : NSDictionary) {
    
    UserDefaults.standard.set(userDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
    
}



func userDictionaryFrom(user : MUser)  -> NSDictionary {
    return NSDictionary(objects: [user.objectId, user.email,user.firstName, user.lastName, user.fullName,user.fullAdress ?? "" , user.onBoard, user.purchasedItemids], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADRESS as NSCopying, kONBOARD as NSCopying, kPURCHASEDITEMIDS as NSCopying])
}

//MARK: Update User Profile

func updateCurrentUserInFireStore(withValues : [String : Any], completion : @escaping(_ error : Error?) -> Void) {
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        
        let userObject = ( dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        let currentId = MUser.currentID()
        
        FirebaseReference(.User).document(currentId).updateData(withValues) { (error) in
            
            completion(error)
            
            // update Success
            if error == nil {
                
                saveUserLocal(userObject)
                
                
            }
        }
    }
    
}


