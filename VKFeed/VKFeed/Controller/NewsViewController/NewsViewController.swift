//
//  NewsViewController.swift
//  VKFeed
//
//  Created by Артем Тихонов on 21.09.2022.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {
    
    let service = VKService()
    var vkNewsModel: VKNews?
    var news = [News]()
    var nextForm = ""
    var isLoading = false
    
    var photoService: PhotoService?
    
    let viewModelFactory = NewsCellsFactory()
    var viewModels:[NewsViewModel] = []
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints=false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService(container: self.tableView)
        setupTableView()
        setupConstraints()
        loadNews()
        setupRefreshControl()
    }
}


extension NewsViewController{
    func setupTableView(){
        tableView.backgroundColor = #colorLiteral(red: 0.9593362212, green: 0.9628924727, blue: 0.9751229882, alpha: 1)
        tableView.frame=self.view.bounds
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.register(UINib(nibName: "AuthorTableViewCell", bundle: nil), forCellReuseIdentifier: "AuthorTableViewCell")
        tableView.register(UINib(nibName: "TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        tableView.register(UINib(nibName: "PhotoTableViewCell", bundle: nil), forCellReuseIdentifier: "PhotoTableViewCell")
        tableView.register(UINib(nibName: "LikeTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeTableViewCell")
        view.addSubview(tableView)
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
            
        ])
    }
    
    private func loadNews(){
        service.getNews(completion:{ [weak self] result in
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self?.vkNewsModel = news
                    self?.infoTransform()
//                    self?.viewModels = self?.viewModelFactory.constructViewModels(from: self?.news ?? []) ?? []
                    self?.tableView.reloadData()
                }
                self?.nextForm = self?.vkNewsModel?.response.nextFrom ?? ""
            case .failure(let error):
                print(error)
            }
        },nil)
    }
    
    private func loadNewsWithEndRefreshing(){
        service.getNews(completion:{ [weak self] result in
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self?.vkNewsModel = news
                    self?.infoTransform()
                    self?.tableView.reloadData()
                    self?.tableView.refreshControl?.endRefreshing()
                }
                self?.nextForm = self?.vkNewsModel?.response.nextFrom ?? ""
            case .failure(let error):
                print(error)
            }
        },nil)
    }
    
    private func loadNewsWithNextForm(_ nextForm:String){
        service.getNews(completion:{ [weak self] result in
            switch result {
            case .success(let news):
                DispatchQueue.main.async {
                    self?.vkNewsModel = news
                    self?.infoTransform()
                    self?.tableView.reloadData()
                }
                self?.nextForm = self?.vkNewsModel?.response.nextFrom ?? ""
            case .failure(let error):
                print(error)
            }
        },nextForm)
    }
    
    private func infoTransform(){
//        self.news.removeAll()
        var newsItems = vkNewsModel?.response.items
        let groups = vkNewsModel?.response.groups
        let profiles = vkNewsModel?.response.profiles
        for item in vkNewsModel?.response.items ?? [NewsItems]() {
            self.news.append(News(countOfLikes: item.likes.count ?? 0, text: item.text))
        }
        
        guard let newsItems = newsItems,
              let groups = groups,
              let profiles = profiles
        else{
            return
        }
        for i in 0..<newsItems.count{
            var photoUrl:String? = vkNewsModel?.response.items[i].attachments?.first?.photo?.sizes.last?.url ?? nil
            if let photoUrl = photoUrl {
                news[i].image = photoService?.photo(byUrl: photoUrl)
            } else {
                news[i].image = nil
            }
            if newsItems[i].sourceID < 0 {
                let group = groups.first(where: { $0.id == -newsItems[i].sourceID })
                news[i].authorImage = (photoService?.photo(byUrl: group?.photoProfile ?? "") ?? UIImage())!
                news[i].authorName = group?.name ?? ""
            } else {
                let profile = profiles.first(where: { $0.id == newsItems[i].sourceID })
                news[i].authorImage = (photoService?.photo(byUrl: profile?.photoProfile ?? "") ?? UIImage())!
                news[i].authorName = (profile?.firstName ?? "") + (profile?.lastName ?? "")
            }
        }
    }
        
    
    private func infoTransformWithoutRemoving(){
        var newsItems = vkNewsModel?.response.items
        let groups = vkNewsModel?.response.groups
        let profiles = vkNewsModel?.response.profiles
        for item in vkNewsModel?.response.items ?? [NewsItems]() {
            self.news.append(News(countOfLikes: item.likes.count ?? 0, text: item.text))
        }
        
        guard let newsItems = newsItems,
              let groups = groups,
              let profiles = profiles
        else{
            return
        }
        for i in 0..<newsItems.count{
            var photoUrl:String? = vkNewsModel?.response.items[i].attachments?.first?.photo?.sizes.last?.url ?? nil
            if let photoUrl = photoUrl {
                news[i].image = photoService?.photo(byUrl: photoUrl)
            } else {
                news[i].image = nil
            }
            if newsItems[i].sourceID < 0 {
                let group = groups.first(where: { $0.id == -newsItems[i].sourceID })
                news[i].authorImage = (photoService?.photo(byUrl: group?.photoProfile ?? "") ?? UIImage())!
                news[i].authorName = group?.name ?? ""
            } else {
                let profile = profiles.first(where: { $0.id == newsItems[i].sourceID })
                news[i].authorImage = (photoService?.photo(byUrl: profile?.photoProfile ?? "") ?? UIImage())!
                news[i].authorName = (profile?.firstName ?? "") + (profile?.lastName ?? "")
            }
        }
    }
}


extension NewsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return configure(indexPath)
    }
    
    func configure(_ indexPath:IndexPath) -> UITableViewCell{
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorTableViewCell",for: indexPath) as? AuthorTableViewCell else
            {
                return UITableViewCell()
            }
            cell.configure(image: news[indexPath.section].authorImage,text: news[indexPath.section].authorName)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell") as? TextTableViewCell else
            {
                return UITableViewCell()
            }
            cell.configure(text:news[indexPath.section].text,tableView: self.tableView, indexPath: indexPath)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell") as? PhotoTableViewCell else
            {
                return UITableViewCell()
            }
            guard let image = news[indexPath.section].image else
            {
                return UITableViewCell()
            }
            cell.configure(image: image)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeTableViewCell") as? LikeTableViewCell else
            {
                return UITableViewCell()
            }
            cell.configure(numberOfLikes: news[indexPath.section].countOfLikes)
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return news.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            if news[indexPath.section].text.isEmpty {
                return 0
            }
        case 2:
            guard
                let _ = news[indexPath.section].image else {
                return 0
            }
            let width = view.frame.width
            let cellHeight = width * (vkNewsModel?.response.items[indexPath.section].attachments?.first?.photo?.sizes.last?.aspectRatio ?? 1)
            return cellHeight
            
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
        return UITableView.automaticDimension
    }
    
}

extension NewsViewController {
    fileprivate func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление")
        tableView.refreshControl?.tintColor = .blue
        tableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews(){
        loadNewsWithEndRefreshing()
    }
}

extension NewsViewController:UITableViewDataSourcePrefetching{
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({$0.section }).max() else{return}
        if  maxSection>news.count - 3,
            !isLoading{
            self.isLoading = true
            loadNewsWithNextForm(nextForm)
            isLoading = false
        }
    }

}
