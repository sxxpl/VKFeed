//
//  SessionSingleton.swift
//  VKFeed
//
//  Created by Артем Тихонов on 06.09.2022.
//

import Foundation

class Session {
    static let instance = Session()
    
    var token:String?
    var userId:Int?
    
    private init() {}
}
