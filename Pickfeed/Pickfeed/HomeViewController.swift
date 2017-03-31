//
//  HomeViewController.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/27/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import UIKit
import Social

class HomeViewController: UIViewController {
    
    let filterNames = [FilterName.vintage, FilterName.blackAndWhite, FilterName.sepia,FilterName.colorInvert ]
    
    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var CollectionViewHieghtConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var filterButtonTopContraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var postButtonRightConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {// override superclass
        super.viewDidLoad()
        imagePicker.delegate = self
        setupGalleryDelegate()
        
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        print("User tapped Image!")
        presentActionSheet()//basically an event  listener
        
    }
    @IBAction func postButtonPress(_ sender: Any) {
        if let image = self.imageView.image {
            let newPost = Post(image: image, date: Date())
            CloudKit.shared.save(post: newPost, completion: { ( success) in
                
                if success {
                    print ("Saved Post Succesfully to CloudKit!")
                } else {
                    print ("We did NOT successfuly save to CloudKit!")
                }
            })
        }
    }
    
    @IBAction func filterButtonPress(_ sender: Any) {
        guard self.imageView.image != nil else { return }
        
        self.CollectionViewHieghtConstraint.constant = 150
        
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
    }
    
        
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
    
        if(SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)){
            guard let composeController = SLComposeViewController(forServiceType: SLServiceTypeTwitter) else {
                return
            }
            composeController.add(self.imageView.image)
            self.present(composeController, animated: true, completion: nil)
        }

    }


        func presentActionSheet() {
            
            let actionSheetController = UIAlertController(title: "Source", message: "Please Select Source Type!", preferredStyle: .actionSheet)
            
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
    
//MARK: UICollectionView DataSource

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let filterCell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCell.identifier, for: indexPath)as! FilterCell
        
        guard let originalImage = Filters.shared.originalImage else { return filterCell }
        
        guard let resizedImage = originalImage.resize(size: CGSize(width: 75, height: 75)) else { return filterCell }
        
        let filterName = self.filterNames[indexPath.row]
        
        Filters.shared.filter(name: filterName, image: resizedImage) { (filterdImage) in
            filterCell.imageView.image = filterdImage
            
        }
        
        return filterCell
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNames.count
    }
}
//MARK: GalleryViewControllerDelegate
    extension HomeViewController: GalleryViewControllerDelegate {
        
        func galleryController(didSelect image: UIImage){
            
            self.imageView.image = image
            
            self.tabBarController?.selectedIndex = 0
            
        }
    }

//MARK: UIImagePickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate {
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
        //        imageView.image = image
        Filters.shared.originalImage = image
        
        // this is the flow previous select
        imagePicker.dismiss(animated: true) {
            UIView.transition(with: self.imageView,
                              duration: 1,
                              options: .transitionCurlDown, animations: {
                                self.imageView.image = image
                                self.collectionView.reloadData()
            }, completion: nil)
        }
        
        print("Info\(info)")
    }

}

//MARK: UINavigationControllerDelegate

extension HomeViewController: UINavigationControllerDelegate {
    func setupGalleryDelegate() {
        
        if let tabBarController = self.tabBarController {
            
            guard let viewControllers = tabBarController.viewControllers else { return }
            
            guard let galleryController = viewControllers[1] as? GalleryViewController else { return }
            galleryController.delegate = self
        }
        
        filterButtonTopContraint.constant = 8
        
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
            
            self.collectionView.dataSource = self
        }
    }

}

