//
//  Filters.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/28/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import UIKit
enum FilterName : String {
    case vintage =  "CIPhotoEffectTransfer"
    case blackAndWhite = "CIPhotoEffectMono"
    case sepia = "CISepiaTone"
    case colorInvert = "CIColorInvert"
    case colorPosterize = "CIColorPosterize"
}

typealias FilterCompletion = (UIImage?) -> ()

class Filters {
    static var originalImage = UIImage ()
    
     class func filter(name: FilterName, image: UIImage, completion: @escaping FilterCompletion) {
        OperationQueue().addOperation {
            guard let filter = CIFilter(name: name.rawValue) else { fatalError("Failed to create CIFilter") }//rawValue will point enum case CIPhotoFilter
            let coreImage = CIImage(image: image)
            filter.setValue(coreImage, forKey:kCIInputImageKey)
            
            //GPU CONTEXT
            let options = [kCIContextWorkingColorSpace: NSNull()]
            let eaglContext = EAGLContext(api: .openGLES2)
            let context = CIContext(eaglContext: (eaglContext)!, options: options)

                
            //Get final image using GPU
                guard let outputImage = filter.outputImage else {fatalError("Failed to get output image from Filter.")}
                
                if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
                    
                    let finalImage = UIImage (cgImage: cgImage)
                    OperationQueue.main.addOperation {
                        completion(finalImage)
                    }
                } else {
                    OperationQueue.main.addOperation{
                        completion(nil)
                    }
                }
                
        }
        
    }
    
}


