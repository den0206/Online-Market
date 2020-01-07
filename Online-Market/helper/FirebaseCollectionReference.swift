//
//  FirebaseCollectionReference.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/06.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference : String {
    case User
    case Category
    case Items
    case Cart
}

func FirebaseReference(_ collectionReference : FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}
