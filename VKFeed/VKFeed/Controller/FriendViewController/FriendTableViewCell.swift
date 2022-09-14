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
    var uiImage:ShadowView = {
        var image = ShadowView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    ///имя автора
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
        uiImage.image.image = nil
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///настройка компонентов
    private func setupLabels(){
        nameLabel.textColor = .black
        nameLabel.font = .preferredFont(forTextStyle: .body)
    }
    
    ///задание констреинтов
    private func setupConstraints(){
        contentView.addSubview(uiImage)
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            uiImage.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            uiImage.heightAnchor.constraint(equalToConstant: 60),
            uiImage.widthAnchor.constraint(equalToConstant: 60),
            uiImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            uiImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 15),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            nameLabel.leadingAnchor.constraint(equalTo: uiImage.trailingAnchor,constant: 15),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
        ])
    }
    
    ///конфигурация ячейки в зависимости от данных
    func configure(author:String, image:UIImage){
        nameLabel.text = author
        uiImage.image.image = image
    }
}
