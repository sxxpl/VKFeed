//
//  GroupAdapter.swift
//  VKFeed
//
//  Created by Артем Тихонов on 18.09.2022.
//

import Foundation
import RealmSwift


class GroupAdapter{
    private let vkService = VKService()
    
    let photoService:PhotoService
    
    weak var viewController:GroupViewController?
    
    init(viewController:GroupViewController){
        self.viewController = viewController
        photoService = PhotoService(container: viewController.tableView)
        vkService.getGroups{}
    }
    
    func getGroups(completion: @escaping ([Group]) -> Void) {
        guard let realm = try? Realm() else {
            return
        }
        let realmGroups = Array(realm.objects(VKGroups.self))
        var vkGroups: [Group] = []
        guard let items = realmGroups.first?.response?.items else {
            return
        }
        for i in 0..<items.count{
            let indexPath = IndexPath(row:i, section:0)
            vkGroups.append(self.groups(from: items[i],indexPath: indexPath))
        }
        completion(vkGroups)
    }
    
    
    private func groups(from realmGroup: GroupInformationResponse,indexPath:IndexPath) -> Group {
        return Group(name: realmGroup.name, image: photoService.photoAtIndexPath(atIndexPath: indexPath, byUrl: realmGroup.photo,completion: { image in
            self.viewController?.groups[indexPath.row].image = image
        }) ?? UIImage())
    }
    
}
