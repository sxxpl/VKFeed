//
//  RealmCacheService.swift
//  VKFeed
//
//  Created by Артем Тихонов on 17.09.2022.
//

import Foundation
import RealmSwift

final class RealmCacheService{
    
    func create<T: Object>(_ object: T){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(object,update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func create<T: Object>(_ object: [T]){
        do{
            let realm = try Realm()
            try realm.write {
                realm.add(object,update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func read<T: Object>(_ object: T.Type) -> Results<T>{
            let realm = try! Realm()
            return realm.objects(object)
    }
}
