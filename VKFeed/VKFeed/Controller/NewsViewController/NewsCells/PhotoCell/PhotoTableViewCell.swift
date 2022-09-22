//
//  PhotoTableViewCell.swift
//  VKFeed
//
//  Created by Артем Тихонов on 21.09.2022.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView?

    func configure(image:UIImage){
        self.cellImage?.image = image
    
    }
    
    override func prepareForReuse() {
        cellImage?.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImage?.layer.masksToBounds = true
        cellImage?.layer.cornerRadius = 12
    }
}

