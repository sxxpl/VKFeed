//
//  FriendTableViewCell.swift
//  VKFeed
//
//  Created by Артем Тихонов on 12.09.2022.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    static let identifier: String = "FriendCell"
    
    ///картинка
    var uiImage:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    ///источник новости
    var nameLabel:UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabels()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        uiImage.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///настройка компонентов
    private func setupLabels(){
        nameLabel.textColor = .secondaryLabel
        nameLabel.font = .preferredFont(forTextStyle: .caption1)
        
        uiImage.layer.cornerRadius = 8
        uiImage.layer.masksToBounds = true
    }
    
    ///задание констреинтов
    private func setupConstraints(){
        contentView.addSubview(uiImage)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            uiImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            uiImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            uiImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
//            uiImage.heightAnchor.constraint(equalToConstant: 224),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: uiImage.trailingAnchor,constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: -5),
        ])
    }
    
    ///конфигурация ячейки в зависимости от данных
    func configure(author:String, imageUrl:String?){
        nameLabel.text = author
        guard let url = imageUrl else {
            return
        }
        uiImage.loadImage(url)
    }
}
