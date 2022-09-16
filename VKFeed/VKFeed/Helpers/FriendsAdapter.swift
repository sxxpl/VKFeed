//
//  FriendsAdapter.swift
//  VKFeed
//
//  Created by Артем Тихонов on 12.09.2022.
//

import Foundation
import RealmSwift
import PromiseKit

///паттерн адаптер
final class FriendsAdapter {
    
    private let vkService = VKService()
    
    let photoService = PhotoService(container: UITableView())
  
    func getFriends(completion: @escaping ([User]) -> Void) {
        vkService.getFriends {
            self.loadFriends()
                .done(on: .global()){friends in
                    completion(friends)
                }
        }
    }
    
    
    private func loadFriends()->Promise<[User]>{
        return Promise{ resolver in
            do{
                guard let realm = try? Realm() else {
                    return
                }
                let realmFriends = Array(realm.objects(VKFriends.self))
                var vkFriends: [User] = []
                for realmFriend in realmFriends.first?.response?.items ?? List<FriendInformationResponse>(){
                    vkFriends.append(self.friends(from: realmFriend)) }
                resolver.fulfill(vkFriends)
            }catch{
                resolver.reject(error)
            }
        }
    }

    
    private func friends(from realmFriend: FriendInformationResponse) -> User {
        return User(name: realmFriend.firstName + " " + realmFriend.lastName, image: photoService.photo(byUrl: realmFriend.photoProfile,synchr: true) ?? UIImage(), id: realmFriend.id)
    }
    
}
