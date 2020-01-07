//
//  Downloader.swift
//  Online-Market
//
//  Created by 酒井ゆうき on 2020/01/07.
//  Copyright © 2020 Yuuki sakai. All rights reserved.
//

import Foundation
import FirebaseStorage

let storage = Storage.storage()

//MARK: Upload Image

func uploadeImages(images : [UIImage?], itemId : String, completion : @escaping (_ imageLinks : [String]) -> Void) {
    
    if Reachabilty.HasConnection() {
        
        var uploadImagesCount = 0
        var imageLinkArray : [String] = []
        var nameShuffix = 0
        
        for image in images {
            
            let fileName = "ItemImages/" + itemId + "/" + "\(nameShuffix)" + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.3)
            
            saveImageInFirebase(imageData: imageData!, fileName: fileName) { (imageLink) in
                
                if imageLink != nil {
                    
                    imageLinkArray.append(imageLink!)
                    uploadImagesCount += 1
                    
                    // last Upload count
                    if uploadImagesCount == images.count {
                        completion(imageLinkArray)
                    }
                }
            }
            
            
            nameShuffix += 1
        }
        
    } else {
        
        // No intrernet..
        print("No Internet Connectuion")
    }
}

func saveImageInFirebase(imageData : Data, fileName : String, completion : @escaping (_ imageLink : String?) -> Void) {
    
    var task : StorageUploadTask!
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metaData, error) in
        
        task.removeAllObservers()
        
        if error != nil {
            print("画像エラー", error?.localizedDescription)
            completion(nil)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil)
                return
                
            }
            
            completion(downloadUrl.absoluteString)
        }
        
    })
    
}

//MARK: Download Images

func downloadImage(imageUrls : [String], completion : @escaping (_ images : [UIImage?]) -> Void) {
    
    var imageArray : [UIImage] = []
    var downloadCounter = 0
    
    for link in imageUrls {
        
        let url = NSURL(string: link)
        let downloadQue = DispatchQueue(label: "imageDownloadQue")
        
        downloadQue.async {
            
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                imageArray.append(UIImage(data: data! as Data)!)
                print(imageArray.count)
                
                if downloadCounter == imageArray.count {
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                }
            } else {
              print("ダウンロードエラー")
                completion(imageArray)
            }
        }
    }
    
}
