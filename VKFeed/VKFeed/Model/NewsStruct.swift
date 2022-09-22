//
//  NewsStruct.swift
//  VKFeed
//
//  Created by Артем Тихонов on 21.09.2022.
//

import UIKit

protocol NewsProtocol {
    var countOfLikes:Int{get set}
    var text:String{get set}
    var image:UIImage?{get set}
    var authorName: String {get set}
    var authorImage:UIImage{get set}
}

struct News:NewsProtocol {
    var countOfLikes:Int = 0
    var text:String = ""
    var image:UIImage?
    var authorName: String = ""
    var authorImage:UIImage = UIImage()
    
    init(countOfLikes: Int, text:String) {
        self.countOfLikes = countOfLikes
        self.text = text
    }
}
