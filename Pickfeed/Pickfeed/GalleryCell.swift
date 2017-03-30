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
    
    @IBOutlet weak var dateLabel: UILabel!
    var post: Post! {
        didSet {
            self.ImageView.image = post.image
            let dateString = DateFormatter.localizedString(from: post.postDate,
                                                           dateStyle: .short,
                                                           timeStyle: .short)
            self.dateLabel.text = dateString
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ImageView.image = nil
    }
    
}
