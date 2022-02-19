//
//  FileModel.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import Foundation

//struct FileResponse: Codable {
//    let dict: [String: ImageData]
//}

struct ImageData : Codable {
    var photoKey: String?
    let photo_url: String
    let user_name: String
    let user_url: String
    let colors: [String]
}

struct HexColor: Codable {
    let color: String
}
