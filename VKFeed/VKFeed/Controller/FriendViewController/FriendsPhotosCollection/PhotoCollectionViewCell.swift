//
//  PhotoCollectionViewCell.swift
//  VKFeed
//
//  Created by Артем Тихонов on 14.09.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "PhotoCell"
    
    var like:LikeControl = {
        var like = LikeControl()
        like.translatesAutoresizingMaskIntoConstraints = false
        return like
    }()
    
    var friendPhoto:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    
    override func awakeFromNib() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapRecognizer))
        doubleTap.numberOfTapsRequired = 2
        like.addGestureRecognizer(doubleTap)
        contentView.addSubview(friendPhoto)
        friendPhoto.addSubview(like)
        
        NSLayoutConstraint.activate([
            friendPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            friendPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            friendPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            friendPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            like.bottomAnchor.constraint(equalTo: friendPhoto.bottomAnchor),
            like.trailingAnchor.constraint(equalTo: friendPhoto.trailingAnchor),
            like.heightAnchor.constraint(equalToConstant: friendPhoto.bounds.height*0.2),
            like.widthAnchor.constraint(equalToConstant: friendPhoto.bounds.width*0.2),
        ])
    }
    
    
    @objc func doubleTapRecognizer(_:UITapGestureRecognizer){
        like.isLike.toggle()
        if like.isLike {
            like.likeImage.image = UIImage(systemName: "heart.fill")
        } else {
            like.likeImage.image = nil
        }
    }
}
