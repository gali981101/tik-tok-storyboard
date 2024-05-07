//
//  StorageService.swift
//  TikTok
//
//  Created by Terry Jason on 2024/4/19.
//

import UIKit
import FirebaseStorage

enum StorageService {
    
    // MARK: - Firebase Storage Ref
    
    static let PROFILE_PHOTO_STORAGE_REF: StorageReference = Storage.storage().reference().child(K.FStorage.profileImages)
}

// MARK: - Upload Image

extension StorageService {
    
    static func uploadImage(image: UIImage, completionHandler: @escaping (String) -> Void) {
        
        // 使用唯一個 key 作為圖片名稱
        let filename = NSUUID().uuidString
        
        // 準備 Storage 參照
        let imageStorageRef = PROFILE_PHOTO_STORAGE_REF.child("\(filename).jpg")
        
        // 調整圖片大小
        let scaledImage = image.scale(newWidth: 640.0)
        
        guard let imageData = scaledImage.jpegData(compressionQuality: 1) else { return }
        
        // 建立檔案元資料
        let metadata = StorageMetadata()
        metadata.contentType = K.ContentType.jpg
        
        // 準備上傳任務
        let uploadTask = imageStorageRef.putData(imageData, metadata: metadata) { metadata, error in
            
            if error != nil {
                print(error.debugDescription)
                return
            }
            
            imageStorageRef.downloadURL { url, error in
                guard let imageUrl = url?.absoluteString else { return }
                completionHandler(imageUrl)
            }
        }
        
        // 顯示上傳進度
        uploadTask.observe(.progress) { snapshot in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print("上傳 \(filename).jpg... \(percentComplete)% 完成")
        }
        
    }
    
}
