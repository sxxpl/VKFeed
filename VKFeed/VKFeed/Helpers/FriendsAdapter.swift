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
    
    let photoService = PhotoService(container: UITableView())

    func getFriends(completion: @escaping ([User]) -> Void) {
        guard let realm = try? Realm() else {
            return
        }
        let realmFriends = Array(realm.objects(VKFriends.self))
        
        var vkFriends: [User] = []
        for realmFriend in realmFriends.first?.response?.items ?? List<FriendInformationResponse>(){
            vkFriends.append(self.friends(from: realmFriend)) }
        completion(vkFriends)
    }
    
    
    private func friends(from realmFriend: FriendInformationResponse) -> User {
        return User(name: realmFriend.firstName + "" + realmFriend.lastName, image: photoService.photo(byUrl: realmFriend.photoProfile) ?? UIImage(), id: realmFriend.id)
    }
    
}
