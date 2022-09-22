//
//  AuthorTableViewCell.swift
//  VKFeed
//
//  Created by Артем Тихонов on 21.09.2022.
//

import UIKit

class AuthorTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
//    func configure(_ viewModel:NewsViewModel){
//        self.authorImage = viewModel.authorImage
//        self.authorLabel = viewModel.authorLabel
//    }
    
    func configure(image:UIImage,text:String){
        self.authorImage.image = image
        self.authorLabel .text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        authorImage.layer.masksToBounds = true
        authorImage.layer.cornerRadius = 22.5
    }
}

