//
//  LikeControl.swift
//  VKFeed
//
//  Created by Артем Тихонов on 14.09.2022.
//

import UIKit

class LikeControl: UIControl {

    var likeImage:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var isLike:Bool = false
    
    override func awakeFromNib() {
        likeImage.backgroundColor = .clear
        likeImage.tintColor = .red
    }


}
