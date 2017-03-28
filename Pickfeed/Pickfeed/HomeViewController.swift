//
//  HomeViewController.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/27/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {



let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var filterButtonTopContraint: NSLayoutConstraint!
    
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {// override superclass
        super.viewDidLoad()
        imagePicker.delegate = self
        
        filterButtonTopContraint.constant = 8
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType) {
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = sourceType
        self.present(self.imagePicker, animated: true, completion: nil)//from imagePickerController, see docs for options
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)//this allows functionality to dismiss the imageview
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image: UIImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        ImageView.image = image
        Filters.originalImage = image
        imagePicker.dismiss(animated: true, completion: nil)// this is the flow previous select
        
        print("Info\(info)")
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        print("User tapped Image!")
        presentActionSheet()//basically an event  listner
    }
    @IBAction func postButtonPress(_ sender: Any) {
        if let image = self.ImageView.image {
            let newPost = Post(image: image)
            CloudKit.shared.save(post: newPost, completion: { ( success) in
                
                if success {
                    print ("Saved Post Succesfully to CloudKit")
                } else {
                    print ("we did NOT successfuly save to CloudKit")
            }
        })
    }
}
    @IBAction func filterButtonPress(_ sender: Any) {
        guard let image = self.ImageView.image else { return }
        
        let alertController = UIAlertController(title: "Filter", message: "Please select a filter", preferredStyle:.alert)
        let blackAndWhiteAction = UIAlertAction(title: "Black and White", style: .default) { (action ) in
            Filters.filter(name: .blackAndWhite, image: image, completion: {(filteredImage) in
                self.ImageView.image = filteredImage
            })
        }
        let vintageAction = UIAlertAction(title: "Vintage", style: .default) { (action) in
            Filters.filter(name: .vintage, image: image, completion: {(filteredImage) in
                self.ImageView.image = filteredImage
            })
        }
        let resetAction = UIAlertAction(title: "Reset Image", style: .destructive) {(action) in
                self.ImageView.image = Filters.originalImage
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
    
        alertController.addAction(blackAndWhiteAction)
        alertController.addAction(vintageAction)
        alertController.addAction(resetAction)
        alertController.addAction(cancelAction)
    
        self.present(alertController, animated: true, completion: nil)
    
    }
            
    func presentActionSheet() {
        
        let actionSheetController = UIAlertController(title: "Source", message: "Please Select Source Type", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .camera)
        }
        
        let photoAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.presentImagePickerWith(sourceType: .photoLibrary)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            cameraAction.isEnabled = false
        }
        actionSheetController.addAction(cameraAction)
        actionSheetController.addAction(photoAction)
        actionSheetController.addAction(cancelAction)
        
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
}








