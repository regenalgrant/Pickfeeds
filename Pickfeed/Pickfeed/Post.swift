//
//  Post.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/28/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import UIKit
import CloudKit

class Post {
    let image: UIImage
    let postDate: Date
    
    init(image: UIImage, date: Date){// initialization
        self.image = image//assign init here
        self.postDate = date 
    }
}

enum PostError : Error{
    case writingImageToData
    case writingDataToDisk
    
}

extension Post {
    
    class func recordFor(post: Post) throws -> CKRecord? {
        guard let data = UIImageJPEGRepresentation(post.image, 0.7) else { throw PostError.writingImageToData }
        
        do {
            try data.write(to: post.image.path)
            let asset = CKAsset(fileURL: post.image.path)
            let record  = CKRecord(recordType: "Post")
            record.setValue(asset, forKey: "image")
            record.setValue(Date(), forKey: "post_date")
            return record
            
            
    } catch {
        throw PostError.writingDataToDisk
    
    }
  }
    
}
