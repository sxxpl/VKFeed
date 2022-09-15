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

    }
    
    override func layoutSubviews() {
        addSubview(likeImage)
        NSLayoutConstraint.activate([
            likeImage.topAnchor.constraint(equalTo: topAnchor),
            likeImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            likeImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            likeImage.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        likeImage.backgroundColor = .clear
        likeImage.tintColor = .red
    }

}
