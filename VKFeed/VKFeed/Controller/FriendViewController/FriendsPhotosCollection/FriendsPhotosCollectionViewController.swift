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
    var photos = [UIImage]()
    var photoService:PhotoService?

    override func viewDidLoad() {
        super.viewDidLoad()
        photoService = PhotoService(container: collectionView)
        setupCollectionView()

        loadPhotos()
    }
    
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
        
        cell.friendPhoto.image = photos[indexPath.row]
    
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowPhotos",
//           let allPhotoVC = segue.destination as? PhotosGalViewController,
//           let selectedPhoto = collectionView.indexPathsForSelectedItems?.first
//        {
//            allPhotoVC.selectedPhotoIndex = selectedPhoto.item
//            allPhotoVC.profImage = photos
//        }
//    }
    
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
        for response in VKFriendsPhotoModel?.response?.items ?? List<FriendPhotoInformationResponse>() {
            self.photos.append(photoService?.photo(byUrl: response.sizes[response.sizes.endIndex-1].url) ?? UIImage())
        }
    
    }
    
    
}

extension FriendsPhotosCollectionViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width * 0.48, height: view.bounds.width * 0.48)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
