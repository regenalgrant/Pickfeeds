//
//  FilterCell.swift
//  Pickfeed
//
//  Created by Regenal Grant on 3/30/17.
//  Copyright © 2017 Regenal Grant. All rights reserved.
//

import UIKit

class FilterCell: UICollectionViewCell {
    

    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    
    
}
