//
//  GalleryCell.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/29/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    
    var post: Post! {
        didSet {
            self.ImageView.image = post.image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ImageView.image = nil
    }
    
}
