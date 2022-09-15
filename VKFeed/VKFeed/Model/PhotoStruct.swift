//
//  PhotoStruct.swift
//  VKFeed
//
//  Created by Артем Тихонов on 15.09.2022.
//

import UIKit

class Photo{
    var image = UIImage()
    var isLiked = false
    
    init(image: UIImage = UIImage(), isLiked: Bool = false) {
        self.image = image
        self.isLiked = isLiked
    }
}
