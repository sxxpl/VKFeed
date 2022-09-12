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
    }
    
    func setupTableView(){
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.identifier)
    }
}

extension FriendsViewController:UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedFriends.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keySorted = sortedFriends.keys.sorted()
        let friendsCount = sortedFriends[keySorted[section]]?.count ?? 0
        return friendsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as! FriendTableViewCell
        
        let firstChar = sortedFriends.keys.sorted()[indexPath.section]
        let friends = sortedFriends[firstChar]!

        let friend:User = friends[indexPath.row]
        
        cell.nameLabel.text = friend.name
        cell.uiImage.image = friend.image
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        <#code#>
    }
}
