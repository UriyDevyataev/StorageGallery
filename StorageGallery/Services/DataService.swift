//
//  DataService.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import Foundation
import UIKit

protocol DataService {
    
    func receiveData(success: @escaping ([ImageData]) -> Void, error: @escaping (Error?) -> Void)
    func loadImage(imageKey: String, handler: @escaping (UIImage?) -> Void)
}

class DataServiceImp: DataService {
    
//    func receiveData(success: @escaping ([String: ImageData]) -> Void, error: @escaping (Error?) -> Void) {
    func receiveData(success: @escaping ([ImageData]) -> Void, error: @escaping (Error?) -> Void) {
        let session = URLSession.shared
        guard let url = URL.init(string: "http://dev.bgsoft.biz/task/") else {
            return
        }
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, err in
            guard let data = data, err == nil else {
                error(err)
                return}
            
            do {
//                var dictionary = [String: ImageData]()
                var array = [ImageData]()
                
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let jsonDictionary = json as? [String: Any]
                
                jsonDictionary?.forEach { (key: String, value: Any) in
                    guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
                    do {
                        var imageObject = try JSONDecoder().decode(ImageData.self, from: data)
                        imageObject.photoKey = key
                        array.append(imageObject)
                    } catch let errorData {
                        error(errorData)
                    }
                }
                let sortArray = array.sorted{$0.user_name < $1.user_name}
                success(sortArray)
                
            } catch let errorData {
                error(errorData)
            }
        }
        task.resume()
    }
    
    func loadImage(imageKey: String, handler: @escaping (UIImage?) -> Void) {
        let session = URLSession.shared
        guard let url = URL.init(string: "http://dev.bgsoft.biz/task/\(imageKey).jpg") else { return}
        let request: URLRequest = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, err in
            guard let data = data, err == nil else {
                handler(nil)
                return}
            
            do {
                if let uiImage = UIImage(data: data) {
                    handler(uiImage)
                }
                else {
                    handler(nil)
                }
            }
        }
        task.resume()
        }
    }
//    func receiveData() -> [String: ImageData]? {
//
//        var dict = [String: ImageData]()
//
//        guard let file = URL(string: "http://dev.bgsoft.biz/task/") else {return nil}
//        guard let data = try? Data(contentsOf: file) else {return nil}
//        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {return nil}
//        guard let jsonDictionary = json as? [String: Any] else {return nil}
//
//        jsonDictionary.forEach { (key: String, value: Any) in
//            guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {return}
//            do {
//                let imageObject = try JSONDecoder().decode(ImageData.self, from: data)
//                dict[key] = imageObject
//            } catch let errorData {
//                print(errorData)
//            }
//        }
//        return dict
//    }

