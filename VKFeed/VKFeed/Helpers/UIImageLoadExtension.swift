//
//  UIImageLoadExtension.swift
//  VKFeed
//
//  Created by Артем Тихонов on 12.09.2022.
//

import UIKit

extension UIImageView {

    ///метод загрузки изображений с помощью url
    func loadImage(_ imageUrl: String) {

        guard let url = URL(string: imageUrl) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, let response = response else {
                print("error", error?.localizedDescription ?? "not localizedDescription")
                return
            }
            
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}

