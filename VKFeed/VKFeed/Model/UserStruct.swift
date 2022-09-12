//
//  UserStruct.swift
//  VKFeed
//
//  Created by Артем Тихонов on 12.09.2022.
//

import Foundation

import UIKit

///структура для представления друга  в FriendTableViewController

protocol UserProtocol {
    var id:Int?{get set}
    var name:String{get set}
    var image:UIImage?{get set}
}

struct User:UserProtocol {

    
    init(name:String){
        self.name = name
    }
    
    init(name:String, image:UIImage,id:Int){
        self.name = name
        self.image = image
        self.id = id
    }
    
    init(name:String, image:UIImage){
        self.name = name
        self.image = image
    }
    var id: Int?
    var name:String
    var image:UIImage?
}

