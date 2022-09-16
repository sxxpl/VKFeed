//
//  BigPhotoViewController.swift
//  VKFeed
//
//  Created by Артем Тихонов on 15.09.2022.
//

import UIKit

class BigPhotoViewController: UIViewController {
    
    public var profImage = [UIImage]()
    public var selectedPhotoIndex:Int = 0
    
    private let additionalImageView = UIImageView()
    
    var bigPhotoImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        guard !profImage.isEmpty else {return}
        bigPhotoImage.image = profImage[selectedPhotoIndex]
        
        view.addSubview(bigPhotoImage)
        view.addSubview(additionalImageView)
        view.sendSubviewToBack(additionalImageView)
        additionalImageView.translatesAutoresizingMaskIntoConstraints  = false
        additionalImageView.contentMode = .scaleAspectFit
        bigPhotoImage.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            bigPhotoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            bigPhotoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bigPhotoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bigPhotoImage.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.5),
            additionalImageView.leadingAnchor.constraint(equalTo: bigPhotoImage.leadingAnchor),
            additionalImageView.trailingAnchor.constraint(equalTo: bigPhotoImage.trailingAnchor),
            additionalImageView.topAnchor.constraint(equalTo: bigPhotoImage.topAnchor),
            additionalImageView.bottomAnchor.constraint(equalTo: bigPhotoImage.bottomAnchor)])
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeFunc))
        leftSwipe.direction = .left
        bigPhotoImage.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeFunc))
        rightSwipe.direction = .right
        bigPhotoImage.addGestureRecognizer(rightSwipe)
        
    }
    
    @objc func leftSwipeFunc(){
        guard selectedPhotoIndex + 1 <= profImage.count-1 else {return}
        
        additionalImageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        additionalImageView.image=profImage[selectedPhotoIndex+1]
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.bigPhotoImage.transform = CGAffineTransform(translationX: -self.bigPhotoImage.bounds.width, y: 0)
            self.additionalImageView.transform = .identity
        },
                       completion: {_ in
            self.selectedPhotoIndex+=1
            self.bigPhotoImage.image=self.profImage[self.selectedPhotoIndex]
            self.bigPhotoImage.transform = .identity
        })
    }
    
    @objc func rightSwipeFunc() {
        guard selectedPhotoIndex  >= 1 else {return}
        view.sendSubviewToBack(bigPhotoImage)
        additionalImageView.transform = CGAffineTransform(translationX: -1.5*additionalImageView.bounds.width, y: 0).concatenating(CGAffineTransform(scaleX: 1.2, y: 1.2))
        additionalImageView.image=profImage[selectedPhotoIndex-1]
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: {
            self.bigPhotoImage.transform=CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.additionalImageView.transform = .identity
        }, completion: {_ in
            self.selectedPhotoIndex-=1
            
            self.bigPhotoImage.image = self.profImage[self.selectedPhotoIndex]
            self.view.sendSubviewToBack(self.additionalImageView)
            self.bigPhotoImage.transform = .identity
        })
    }
    
}

