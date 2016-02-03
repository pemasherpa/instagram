//
//  photoCell.swift
//  Instagram
//
//  Created by Pema Sherpa on 2/1/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class photoCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    
    @IBOutlet weak var photoCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
