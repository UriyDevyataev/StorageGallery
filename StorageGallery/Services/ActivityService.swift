//
//  ActivityService.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 21.02.2022.
//

import Foundation

protocol ActivityService {
    
    var delegate: ActivityServiceOut? { get set }
    
    func startTimer()
    func stopTimer()
}

protocol ActivityServiceOut: AnyObject {
    func notActivity()
}

class ActivityServiceImp: ActivityService {
    
    static var shared: ActivityService = ActivityServiceImp()
    
    weak var delegate: ActivityServiceOut?
    
    var timer: Timer?
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 10,
                                         target: self,
                                         selector: #selector(timerInretval),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
    }
    
    @objc func timerInretval() {
        stopTimer()
        delegate?.notActivity()
    }
}
