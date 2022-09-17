//
//  GroupStruct.swift
//  VKFeed
//
//  Created by Артем Тихонов on 18.09.2022.
//

import UIKit


///структура для представления группы в GroupTableViewController
protocol GroupProtocol {
    var name:String{get set}
    var image:UIImage?{get set}
}

struct Group:GroupProtocol {
    var name:String
    var image:UIImage?
}
