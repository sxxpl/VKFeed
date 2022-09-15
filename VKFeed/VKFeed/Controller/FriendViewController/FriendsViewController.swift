//
//  FriendsViewController.swift
//  VKFeed
//
//  Created by Артем Тихонов on 06.09.2022.
//

import UIKit
import RealmSwift

class FriendsViewController: UIViewController {
    
    var friends=[User]()
    var sortedFriends = [Character:[User]]()
    
    let service = FriendsAdapter()
    
    private var photoService: PhotoService?

    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        photoService = PhotoService(container: tableView)
        loadFriends()
    }
    
    func setupTableView(){
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
    }
}

extension FriendsViewController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedFriends.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keySorted = sortedFriends.keys.sorted()
        let friendsCount = sortedFriends[keySorted[section]]?.count ?? 0
        return friendsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier) as! FriendTableViewCell
        
        let firstChar = sortedFriends.keys.sorted()[indexPath.section]
        let friends = sortedFriends[firstChar]!

        let friend:User = friends[indexPath.row]
        
        cell.configure(author: friend.name, image: friend.image ?? UIImage())
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sortedFriends.keys.sorted()[section])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: view.bounds.width * 0.4, height: view.bounds.width * 0.4)
        var nextViewController = FriendsPhotosCollectionViewController(collectionViewLayout: layout)
        nextViewController.id = sortedFriends[sortedFriends.keys.sorted()[indexPath.section]]?[indexPath.row].id ?? 0
        navigationController?.pushViewController(nextViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FriendsViewController {
    ///загрузка друзей вк
    private func loadFriends(){
        service.getFriends{ [weak self] newFriends in
                DispatchQueue.main.async {
                    self?.friends = newFriends
                    self?.sortedFriends = (self?.sort(friends: self?.friends ?? [])) ?? [:]
                    self?.tableView.reloadData()
                }
        }
    }
    
    ///сортировка для отображения друзей по алфавиту
    private func sort(friends:[User])->[Character:[User]]{
        var friendDict = [Character:[User]]()
        friends.forEach(){friend in
            guard let firstChar = friend.name.first else {return}

            if var thisCharFriends = friendDict[firstChar]{
                thisCharFriends.append(friend)
                friendDict[firstChar] = thisCharFriends
            } else {
                friendDict[firstChar] = [friend]
            }
        }
        return friendDict
    }
}
