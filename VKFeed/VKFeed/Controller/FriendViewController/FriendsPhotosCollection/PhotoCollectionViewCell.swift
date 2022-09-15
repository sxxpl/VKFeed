//
//  PhotoCollectionViewCell.swift
//  VKFeed
//
//  Created by Артем Тихонов on 14.09.2022.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "PhotoCell"
    
    weak var photo:Photo?
    
    var like:LikeControl = {
        var like = LikeControl()
        like.translatesAutoresizingMaskIntoConstraints = false
        return like
    }()
    
    var friendPhoto:UIImageView = {
        var image = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(friendPhoto)
        contentView.addSubview(like)
        
        NSLayoutConstraint.activate([
            friendPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            friendPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            friendPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            friendPhoto.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            friendPhoto.heightAnchor.constraint(equalToConstant: contentView.bounds.height),
            like.bottomAnchor.constraint(equalTo: friendPhoto.bottomAnchor),
            like.trailingAnchor.constraint(equalTo: friendPhoto.trailingAnchor),
            like.heightAnchor.constraint(equalToConstant: contentView.bounds.height*0.14),
            like.widthAnchor.constraint(equalToConstant: contentView.bounds.width*0.2),
        ])
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapRecognizer))
        doubleTap.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func doubleTapRecognizer(_:UITapGestureRecognizer){
        like.isLike.toggle()
        if like.isLike {
            photo?.isLiked = true
            like.likeImage.image = UIImage(systemName: "heart.fill")
            
        } else {
            photo?.isLiked = false
            like.likeImage.image = nil
        }
    }
    
    override func prepareForReuse() {
        like.isLike = false
        like.likeImage.image = nil
        friendPhoto.image = nil
    }
}
