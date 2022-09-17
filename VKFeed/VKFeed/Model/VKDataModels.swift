//
//  VKDataModels.swift
//  VKFeed
//
//  Created by Артем Тихонов on 12.09.2022.
//

import Foundation
import RealmSwift

///структуры для парсинга друзей ВК
class VKFriends:Object, Decodable{
    @objc dynamic var  response:FriendsResponse?
    
    enum CodingKeys:String,CodingKey {
        case response
    }
}

final class FriendsResponse: Object, Decodable{
    @objc dynamic var count: Int = 0
    var items = List<FriendInformationResponse>()
    
    enum CodingKeys:String, CodingKey {
        case count
        case items
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode(List<FriendInformationResponse>.self, forKey: .items)
    }
}
 

class FriendInformationResponse:Object, Decodable{
    @objc dynamic var id:Int = 0
    @objc dynamic var firstName:String = ""
    @objc dynamic var lastName:String = ""
    @objc dynamic var photoProfile:String = ""
    
    enum CodingKeys:String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case photoProfile = "photo_100"
    }
}




///структуры для парсинга групп ВК
class VKGroups:Object, Decodable{
    @objc dynamic var response:GroupsResponse?
    
    enum CodingKeys:String,CodingKey {
        case response
    }
}

final class GroupsResponse:Object, Decodable{
    @objc dynamic var count: Int = 0
    var items = List<GroupInformationResponse>()
    
    enum CodingKeys:String, CodingKey {
        case count
        case items
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode(List<GroupInformationResponse>.self, forKey: .items)
    }
}

class GroupInformationResponse:Object, Decodable{
    @objc dynamic var name: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var photo:String = ""
    
    enum CodingKeys:String, CodingKey {
        case name
        case id
        case photo = "photo_100"
    }
}

///структуры для парсинга фото ВК
class VKFriendsPhoto:Object,Decodable{
    @objc dynamic var response:FriendsPhotoResponse?
    
    enum CodingKeys:String,CodingKey {
        case response
    }
}

final class FriendsPhotoResponse:Object, Decodable{
    @objc dynamic var count: Int = 0
    var items = List<FriendPhotoInformationResponse>()
    
    enum CodingKeys:String, CodingKey {
        case count
        case items
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode(List<FriendPhotoInformationResponse>.self, forKey: .items)
    }
}

final class FriendPhotoInformationResponse:Object,Decodable{
     var sizes=List<FriendPhotoSizes>()
    
    enum CodingKeys:String, CodingKey {
        case sizes
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sizes = try container.decode(List<FriendPhotoSizes>.self, forKey: .sizes)
    }
}

class FriendPhotoSizes:Object,Decodable {
    @objc dynamic var height:Int
    @objc dynamic var width:Int
    @objc dynamic var url:String
    @objc dynamic var type: String
    enum CodingKeys:String, CodingKey {
        case height
        case width
        case url
        case type
    }
}

///структуры для новостей
struct VKNews: Codable{
    var response:VKResponse
    
    enum CodingKeys:String,CodingKey {
        case response
    }
}

struct VKResponse: Codable {
    var items:[NewsItems]
    var profiles:[NewsProfiles]?
    var groups:[GroupNews]?
    var nextFrom:String
    
    enum CodingKeys:String,CodingKey {
        case items
        case profiles
        case groups
        case nextFrom = "next_from"
    }
}

class NewsItems: Codable{
    var sourceID: Int = 0
    var text:String = ""
    var likes:NewsLikes
    var attachments:[NewsAttachments]?
    
    
    
    enum CodingKeys:String,CodingKey {
        case sourceID = "source_id"
        case text
        case likes
        case attachments
    }
    
}

final class NewsProfiles: Codable{
    var id:Int
    var firstName:String
    var lastName:String
    var photoProfile:String
    
    
    enum CodingKeys:String,CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photoProfile = "photo_100"
    }
}

final class GroupNews: Codable{
    var id:Int
    var name:String
    var photoProfile:String
    
    
    enum CodingKeys:String,CodingKey {
        case id
        case name
        case photoProfile = "photo_100"
    }
}



final class NewsLikes: Codable {
    var count:Int
    
    enum CodingKeys:String,CodingKey {
        case count
    }
}

final class NewsAttachments: Codable {
    var type: String
    var photo:NewsPhoto?
    
    enum CodingKeys:String,CodingKey {
        case type
        case photo
    }
}

final class NewsPhoto: Codable{
    var id: Int
    var ownerID: Int
    var sizes:[NewsPhotoSizes]
    
    enum CodingKeys:String,CodingKey {
        case id
        case ownerID = "owner_id"
        case sizes
    }
    
}

final class NewsPhotoSizes: Codable {
    var url:String
    var type: String
    var width: Int
    var height: Int
    var aspectRatio: CGFloat { return CGFloat(height)/CGFloat(width) }
    
    enum CodingKeys:String,CodingKey {
        case url
        case type
        case width
        case height
    }
}




