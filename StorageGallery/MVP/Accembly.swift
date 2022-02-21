//
//  Accembly.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 21.02.2022.
//

import Foundation
import UIKit

class Assembly {
    
    static func configurateModule() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(
            withIdentifier: "MainController") as? ViewController else {return nil}
        
        let presenter = PresenterImp()
        presenter.view = controller
        
        var activityServise = ActivityServiceImp.shared
        activityServise.delegate = presenter
        presenter.activityService = activityServise
        
        presenter.dataService = DataServiceImp.shared
        
        controller.presenter = presenter
        
        return controller
    }
}

