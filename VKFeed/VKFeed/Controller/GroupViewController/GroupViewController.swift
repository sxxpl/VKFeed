//
//  GroupViewController.swift
//  VKFeed
//
//  Created by Артем Тихонов on 18.09.2022.
//

import UIKit
import RealmSwift

class GroupViewController:UIViewController,UISearchBarDelegate {
    
    var service:GroupAdapter?
    var groups = [Group]()
    
    var searchActive = false
    var filtered:[Group] = []
    
    private var notificationToken: NotificationToken?
    let realm = RealmCacheService()
    private var groupRespons: Results<VKGroups>? {
        realm.read(VKGroups.self)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //    private var groupFirebase:[FirebaseCommunity] = []
    //    private var ref = Database.database().reference(withPath: "Communities")
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service = GroupAdapter(viewController: self)
        createNotificatoinToken()
        setupTableView()
        loadGroups()
        //        ref.observe(.value) {snapshot in
        //            var communities: [FirebaseCommunity] = []
        //            for child in snapshot.children {
        //                if let snapshot = child as? DataSnapshot,
        //                   let group = FirebaseCommunity(snapshot: snapshot){
        //                    communities.append(group)
        //                }
        //            }
        //            print("Добавлена группа")
        //            communities.forEach{print($0)}
        //
        //        }
        searchBar.delegate = self
    }
    
    func setupTableView(){
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(GroupTableViewCell.self, forCellReuseIdentifier: GroupTableViewCell.identifier)
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = groups.filter({ (group) -> Bool in
            return group.name.contains(searchText)
        })
        if(filtered.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
}

extension GroupViewController:UITableViewDelegate ,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtered.count }
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GroupTableViewCell.identifier, for: indexPath) as? GroupTableViewCell else {
            return UITableViewCell()
        }
        if searchActive {
            cell.groupName.text = filtered[indexPath.row].name
            cell.groupImage.image = filtered[indexPath.row].image
        } else {
            cell.groupName.text = groups[indexPath.row].name
            cell.groupImage.image = groups[indexPath.row].image
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    private func loadGroups(){
        service?.getGroups{ [weak self] groups in
            DispatchQueue.main.async {
                self?.groups = groups
                self?.tableView.reloadData()
            }
        }
    }

    
//    private func infoTransform(){
//        for response in VKGroupsModel?.first?.response?.items ?? List<GroupInformationResponse>(){
//            self.groups.append(Group(name: response.name, image: UIImage(named: "kot")))
//            let com = FirebaseCommunity(name: response.name, id: response.id)
//            let reference = self.ref.child(response.name.lowercased().removeCharacters(from: ".#$[]"))
//            reference.setValue(com.toAnyObject())
//        }
//    }
//
    
    func createNotificatoinToken(){
        notificationToken = groupRespons?.observe{ [weak self] result in
            guard let self = self else {return}
            switch result{
            case .initial(let groupData):
                print("\(groupData.count)")
            case .update( _,
                         deletions: _,
                         insertions: _,
                         modifications: _):
                self.loadGroups()
            case .error(let error):
                print(error)
            }
        }
    }
    
}

