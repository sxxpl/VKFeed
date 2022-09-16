//
//  FriendsPhotosCollectionViewController.swift
//  VKFeed
//
//  Created by Артем Тихонов on 14.09.2022.
//

import UIKit
import RealmSwift
private let reuseIdentifier = "Cell"

class FriendsPhotosCollectionViewController: UICollectionViewController {
    
    
    var id = Int()
    let service = VKService()
    var VKFriendsPhotoModel: VKFriendsPhoto?
    var photos = [Photo]()
    var photoService:PhotoService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService(container: collectionView)
        loadPhotos()
        setupCollectionView()    }
    
    func setupCollectionView(){
        collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell
        else { exit(0) }
        
        cell.friendPhoto.image = photos[indexPath.row].image
        if photos[indexPath.row].isLiked {
            cell.like.likeImage.image = UIImage(systemName: "heart.fill")
        }
        cell.photo = photos[indexPath.row]        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem  = collectionView.indexPathsForSelectedItems?.first?.item else {
            return
        }
        let newViewController = BigPhotoViewController()
        var images = [UIImage]()
        for photo in photos {
            images.append(photo.image)
        }
        newViewController.profImage = images
        newViewController.selectedPhotoIndex = selectedItem
        navigationController?.pushViewController(newViewController, animated: true)
    }
}


extension FriendsPhotosCollectionViewController{
    private func loadPhotos(){
        service.getPhotos(id: self.id) { [weak self] result in
            switch result {
            case .success(let photos):
                DispatchQueue.main.async {
                    self?.VKFriendsPhotoModel = photos
                    self?.infoTransform()
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func infoTransform(){
        guard let items = VKFriendsPhotoModel?.response?.items else {
            return
        }
        for i in 0..<items.count{
            photoService?.photo(byUrl: items[i].sizes[items[i].sizes.endIndex-1].url){[weak self]image in
                self?.photos.append(Photo(image:image))
                self?.collectionView.reloadItems(at: [IndexPath(row: i, section: 0)])
            }
        }
    }
    
}

extension FriendsPhotosCollectionViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width * 0.48, height: view.bounds.width * 0.48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return view.bounds.width * 0.04
    }
}


