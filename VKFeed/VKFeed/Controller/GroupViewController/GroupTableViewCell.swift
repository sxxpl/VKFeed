//
//  GroupTableViewCell.swift
//  VKFeed
//
//  Created by Артем Тихонов on 18.09.2022.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    static let identifier: String = "GroupCell"
    
    ///картинка
    var groupImage:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    ///имя группы
    var groupName:UILabel = {
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
        groupImage.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///настройка компонентов
    private func setupLabels(){
        groupName.textColor = .black
        groupName.font = .preferredFont(forTextStyle: .body)
        
        groupImage.layer.masksToBounds = true
        groupImage.layer.cornerRadius = 30
    }
    
    ///задание констреинтов
    private func setupConstraints(){
        contentView.addSubview(groupImage)
        contentView.addSubview(groupName)
        NSLayoutConstraint.activate([
            groupImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            groupImage.heightAnchor.constraint(equalToConstant: 60),
            groupImage.widthAnchor.constraint(equalToConstant: 60),
            groupImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            groupImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            groupName.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            groupName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            groupName.leadingAnchor.constraint(equalTo: groupImage.trailingAnchor,constant: 15),
            groupName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
        ])
    }
    
    ///конфигурация ячейки в зависимости от данных
    func configure(author:String, image:UIImage){
        groupName.text = author
        groupImage.image = image
    }

}
