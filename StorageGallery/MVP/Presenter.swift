//
//  Presenter.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 21.02.2022.
//

import Foundation
import UIKit

//MARK: - Protocols Presenter

protocol PresenterInput {
    
    var view: PresenterOutput? {get set}
    
    func viewIsReady()
    func actionShowWebController(withLink: String?)
    func userActivity()
    func cachedImage(key: String) -> UIImage?
    func loadImage(key: String, handler: @escaping(UIImage) -> Void)
}

protocol PresenterOutput: AnyObject {
    func setState(model: MainModel)
    func showWebController(controller: WebViewController)
    func scrollToStart()
}

//MARK: - Class Implementation

class PresenterImp: PresenterInput {
    
    
    
    var view: PresenterOutput?
    
    var dataService: DataService?
    var activityService: ActivityService?
    
    func viewIsReady() {
        receiveData()
    }
    
    func userActivity() {
        activityService?.startTimer()
    }
    
    func actionShowWebController(withLink: String?) {
        activityService?.stopTimer()
        guard let controller = self.prepareWebViewController(
            startLink: withLink) else {return}
        view?.showWebController(controller: controller)
    }
    
    func loadImage(key: String, handler: @escaping(UIImage) -> Void) {
        dataService?.loadImage(imageKey: key) { image in
            guard let image = image else {return}
            handler(image)
        }
    }
    
    func cachedImage(key: String) -> UIImage? {
        return dataService?.imageDict[key]
    }
    
    private func receiveData() {
        dataService?.receiveData {[weak self] array in
            guard let self = self else {return}
            let infinityArray = self.configToInfinity(array: array)
            let model = MainModel(data: infinityArray)
            self.view?.setState(model: model)
        } error: { err in
            //print(err ?? "")
        }
    }
    
    private func configToInfinity(array: [ImageData]) -> [ImageData] {
        let saveFirst = array.first!
        var newArray = array
        newArray.insert(array.last!, at: 0)
        newArray.append(saveFirst)
        return newArray
    }
    
    private func prepareWebViewController(startLink: String?) -> WebViewController? {
        guard let link = startLink else {return nil}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller  = storyboard.instantiateViewController(identifier: "WebViewControllerIdent") as? WebViewController {
            controller.modalPresentationStyle = .formSheet
            controller.url = URL(string: link)
            return controller
        } else {
            return nil
        }
    }
}

extension PresenterImp: ActivityServiceOut {
    func notActivity() {
        view?.scrollToStart()
    }
}
