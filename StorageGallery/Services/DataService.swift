//
//  DataService.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import Foundation
import UIKit

protocol DataService {
    
    var imageDict: [String: UIImage] {get}
    
    func receiveData(success: @escaping ([ImageData]) -> Void, error: @escaping (Error?) -> Void)
    func loadImage(imageKey: String, handler: @escaping (UIImage?) -> Void)
}

class DataServiceImp: DataService {
    
    static var shared: DataService = DataServiceImp()
    
    var imageDict = [String : UIImage]()
    
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
                    self.imageDict[imageKey] = uiImage
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
