//
//  Cart.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation

class Cart {
    
    var id : String!
    var ownerId : String!
    var itemIds : [String]!
    
    init() {
    }
    
    init(_dictionary : NSDictionary) {
        
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        itemIds = _dictionary[kITEMSIDS] as? [String]
    }
}

//MARK: Download Cart

func downloadCartFromFirestore(_ ownerId : String, completion : @escaping (_ cart : Cart?) -> Void) {
    
    FirebaseReference(.Cart).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            
            let cart = Cart(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(cart)
        } else {
            completion(nil)
        }
        
    }
    
}

//MARK:SaveTo Firebase

func saveCartToFirestore(_ cart : Cart) {
    FirebaseReference(.Cart).document(cart.id).setData(cartDictionaryFrom(cart) as! [String : Any])
}

func cartDictionaryFrom(_ cart : Cart) -> NSDictionary {
    return NSDictionary(objects: [cart.id, cart.ownerId, cart.itemIds], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMSIDS as NSCopying])
}

//MARK: UPdateCart

func updateCartInFirestore(_ cart : Cart, withValues : [String : Any], completion : @escaping(_ error : Error?) -> Void) {
    
    FirebaseReference(.Cart).document(cart.id).updateData(withValues) { (error) in
        completion(error)
    }
}

