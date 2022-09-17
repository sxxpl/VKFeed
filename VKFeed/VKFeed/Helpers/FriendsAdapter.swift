//
//  FriendsAdapter.swift
//  VKFeed
//
//  Created by Артем Тихонов on 12.09.2022.
//

import Foundation
import RealmSwift

///паттерн адаптер
final class FriendsAdapter {
    
    private let vkService = VKService()
    
    let photoService:PhotoService
    
    weak var viewController:FriendsViewController?
    
    init(viewController:FriendsViewController){
        self.viewController = viewController
        photoService = PhotoService(container: viewController.tableView)
        vkService.getFriends{}
    }
  
    func getFriends(completion: @escaping ([User]) -> Void) {
        guard let realm = try? Realm() else {
            return
        }
        var friendDict = [Character:[String]]()
        let realmFriends = Array(realm.objects(VKFriends.self))
        var vkFriends: [User] = []
        for realmFriend in realmFriends.first?.response?.items ?? List<FriendInformationResponse>(){
            guard let firstChar = realmFriend.firstName.first else {
                continue
            }
            var name = realmFriend.firstName + " " + realmFriend.lastName
            if var thisCharFriends = friendDict[firstChar]
            {
                thisCharFriends.append(name)
                friendDict[firstChar] = thisCharFriends
            } else {
                friendDict[firstChar] = [name]
            }
        }
        for realmFriend in realmFriends.first?.response?.items ?? List<FriendInformationResponse>(){
            guard let firstChar = realmFriend.firstName.first else {
                continue
            }
            var name = realmFriend.firstName + " " + realmFriend.lastName
            guard let firstIndexOfName = friendDict[firstChar]?.firstIndex(of: name) else {
                continue
            }
            let indexPath = IndexPath(row: firstIndexOfName, section: Array(friendDict.keys).firstIndex(of:firstChar)!)
            friendDict[firstChar]![firstIndexOfName] = ""
            vkFriends.append(self.friends(from: realmFriend,indexPath: indexPath,firstChar: firstChar))
        }
        completion(vkFriends)
    }
    
    
    
    
    private func friends(from realmFriend: FriendInformationResponse,indexPath:IndexPath,firstChar:Character) -> User {
        return User(name: realmFriend.firstName + " " + realmFriend.lastName, image: photoService.photoAtIndexPath(atIndexPath: indexPath, byUrl: realmFriend.photoProfile,completion: { image in
            self.viewController?.sortedFriends[firstChar]?[indexPath.row].image = image
            
        }) ?? UIImage(), id: realmFriend.id)
    }
    
}
