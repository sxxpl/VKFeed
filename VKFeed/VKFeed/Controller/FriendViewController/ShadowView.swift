//
//  ShadowView.swift
//  VKFeed
//
//  Created by Артем Тихонов on 14.09.2022.
//

import UIKit

class ShadowView: UIView {
    
    var image:UIImageView = {
        var image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var shadow:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    private func setupGesture() {
        let profImageTap = UITapGestureRecognizer(target: self, action: #selector(profImageTap))
        profImageTap.numberOfTapsRequired = 1
        addGestureRecognizer(profImageTap)
    }
    @objc private func profImageTap(_ tap:UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, delay: 0, options: .autoreverse, animations:{
            self.transform.scaledBy(x: 0.7, y: 0.7)
        } )
    }
    
    override func layoutSubviews() {
        image.layer.masksToBounds = true
        image.layer.cornerRadius = bounds.width/2
        shadow.layer.cornerRadius = bounds.width/2
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowRadius = 3
        shadow.layer.shadowOffset = .zero
        shadow.layer.shadowOpacity = 0.6
        
        addSubview(shadow)
        shadow.addSubview(image)
        
        NSLayoutConstraint.activate([
            shadow.topAnchor.constraint(equalTo: topAnchor),
            shadow.bottomAnchor.constraint(equalTo: bottomAnchor),
            shadow.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadow.trailingAnchor.constraint(equalTo: trailingAnchor),
            image.topAnchor.constraint(equalTo: shadow.topAnchor),
            image.bottomAnchor.constraint(equalTo: shadow.bottomAnchor),
            image.leadingAnchor.constraint(equalTo: shadow.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: shadow.trailingAnchor),
        ])
    }
}
