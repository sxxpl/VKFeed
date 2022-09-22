//
//  NewsCellsFactory.swift
//  VKFeed
//
//  Created by Артем Тихонов on 21.09.2022.
//

import UIKit

class NewsCellsFactory{
    func constructViewModels(from news: [News]) -> [NewsViewModel] {
        return news.map{viewModel(from: $0)}
    }
    
    private func viewModel(from news: News) -> NewsViewModel {
        let authorImage = UIImageView()
        authorImage.image = news.authorImage
        authorImage.layer.cornerRadius = authorImage.frame.width/2
        authorImage.layer.masksToBounds = true
        let authorLabel = UILabel()
        authorLabel.text = news.authorName
        let cellTextLabel = UILabel()
        cellTextLabel.text = news.text
        let cellImage =  UIImageView()
        cellImage.image = news.image
        let numberOfLikes = UILabel()
        numberOfLikes.text = String(news.countOfLikes)
        return NewsViewModel(authorImage: authorImage, authorLabel: authorLabel, cellTextLabel: cellTextLabel, cellImage: cellImage, numberOfLikes: numberOfLikes)
    }
}

struct NewsViewModel{
    var authorImage: UIImageView
    var authorLabel: UILabel
    var cellTextLabel: UILabel
    var cellImage: UIImageView
    var numberOfLikes: UILabel
}

