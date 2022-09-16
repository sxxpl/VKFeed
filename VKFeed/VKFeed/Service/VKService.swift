//
//  VKService.swift
//  VKFeed
//
//  Created by Артем Тихонов on 06.09.2022.
//

import UIKit
import RealmSwift
import PromiseKit



///класс загрузки информации из ВК
final class VKService {
    ///загрузка друзей пользователя с помощью PromiseKit
    func getFriends(completion: @escaping (() -> Void)) {
        getFriendsUrl()
            .then(on: .global(), getFriendsData(_:))
            .then(on: .global(), getParsedFriendsData(_:))
            .done(on: .global()){ friends in
                completion()
            }.catch {error in
                print(error)
            }
    }
    
    
    ///url для запроса друзей
    
    func getFriendsUrl()->Promise<URL>{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [URLQueryItem(name: "user_id", value: String(Session.instance.userId!)),
                                    URLQueryItem(name: "order", value: "random"),
                                    URLQueryItem(name: "fields", value: "nickname,photo_100"),
                                    URLQueryItem(name: "access_token", value: Session.instance.token),
                                    URLQueryItem(name: "v", value: "5.131")]
        return Promise{ resolver in
            guard let url = urlComponents.url else {
                resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
       
    }
    
    
    
    /// запрос
    func getFriendsData(_ url:URL) -> Promise<Data> {
        return Promise{ resolver in
            URLSession.shared.dataTask(with: URLRequest(url:url)) {data, response, error in
                if let _ = error  {
                    resolver.reject(AppError.errorTask)
                }
                guard let data = data else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    ///парсим данные
    func getParsedFriendsData(_ data:Data) -> Promise<VKFriends> {
        return Promise{ resolver in
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(VKFriends.self, from: data)
                self.saveFriends(friends: result)
                resolver.fulfill(result)
            }catch {
                resolver.reject(AppError.errorTask)
            }
        }
    }
    
    
    
    

    
    
    ///загрузrа групп пользователя
    func getGroup(completion: @escaping (() -> Void)) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [URLQueryItem(name: "user_id", value: String(Session.instance.userId!)),
                                    URLQueryItem(name: "extended", value: "1"),
                                    URLQueryItem(name: "access_token", value: Session.instance.token),
                                    URLQueryItem(name: "v", value: "5.131")]
        guard let url = urlComponents.url else {return}
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {[weak self]data, response, error in
            if let error = error  {
                print(error)
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(VKGroups.self, from: data)
                self?.saveGroups(groups: result)
                completion()
            }catch {
                print(error)
            }
        }.resume()
    }
    
    
    
    ///загрузка фото пользователя
    func getPhotos(id:Int,completion: @escaping ((Swift.Result<VKFriendsPhoto,Error>) -> ())) {
        getPhotoUrl(id:id)
            .then(on: .global(), getPhotoData(_:))
            .then(on: .global(), getParsedPhotoData(_:))
            .done(on: .global()){photos in
                completion(.success(photos))
            }.catch {error in
                print(error)
            }
    }
    
    func getPhotoUrl(id:Int)->Promise<URL>{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.get"
        urlComponents.queryItems = [URLQueryItem(name: "owner_id", value: String(id)),
                                    URLQueryItem(name: "album_id", value: "profile"),
                                    URLQueryItem(name: "count", value: "20"),
                                    URLQueryItem(name: "access_token", value: Session.instance.token),
                                    URLQueryItem(name: "v", value: "5.131")]
        return Promise{ resolver in
            guard let url = urlComponents.url else {
                resolver.reject(AppError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
       
    }
    
    func getPhotoData(_ url:URL) -> Promise<Data> {
        return Promise{ resolver in
            URLSession.shared.dataTask(with: URLRequest(url:url)) {data, response, error in
                if let _ = error  {
                    resolver.reject(AppError.errorTask)
                }
                guard let data = data else {
                    resolver.reject(AppError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    func getParsedPhotoData(_ data:Data) -> Promise<VKFriendsPhoto> {
        return Promise{ resolver in
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(VKFriendsPhoto.self, from: data)
                resolver.fulfill(result)
            } catch {
                resolver.reject(AppError.errorTask)
            }
        }
    }
    
    
    
    
    ///загрузка новостей
    func getNews(completion: @escaping ((Swift.Result<VKNews,Error>) -> ()),_ nextForm:String?){
        var url:URL
        if let nextForm = nextForm {
            guard let urll = getNewsUrl(nextForm) else {return}
            url = urll
        } else {
            guard let urll = getNewsUrl() else {return}
            url = urll
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            if let error = error  {
                print(error)
            }
            guard let data = data else {
                return
            }
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode(VKNews.self, from: data)
                completion(.success(result))
            }catch {
                print(error)
            }
        }.resume()
    }
    
    ///получить url без данных следующей страницы
    func getNewsUrl()->URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [URLQueryItem(name: "filters", value: "post"),
                                    URLQueryItem(name: "count", value: "20"),
                                    URLQueryItem(name: "access_token", value: Session.instance.token),
                                    URLQueryItem(name: "v", value: "5.131")]
        return urlComponents.url
        
       
    }
    
    ///получить url c данными следующей страницы
    func getNewsUrl(_ nextFrom : String)->URL?{
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [URLQueryItem(name: "filters", value: "post"),
                                    URLQueryItem(name: "start_from", value: nextFrom),
                                    URLQueryItem(name: "count", value: "20"),
                                    URLQueryItem(name: "access_token", value: Session.instance.token),
                                    URLQueryItem(name: "v", value: "5.131")]
        return urlComponents.url
       
    }
}

private extension VKService {
    func saveFriends(friends: VKFriends){
        do {
            let realm = try Realm()
            let friendsOld = realm.objects(VKFriends.self)
            realm.beginWrite()
            realm.delete(friendsOld)
            realm.add(friends)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveGroups(groups: VKGroups){
        do {
            let realm = try Realm()
            let groupsOld = realm.objects(VKGroups.self)
            realm.beginWrite()
            realm.delete(groupsOld)
            realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}




