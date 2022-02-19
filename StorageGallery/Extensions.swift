//
//  Extensions.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 17.02.2022.
//

import Foundation
import UIKit

// MARK: - UIView
extension UIView {
    
    func cornerHalfHeight(){
        corner(withRadius: frame.height / 2)
    }
    
    func cornerHalfWidth(){
        corner(withRadius: frame.width / 2)
    }
    
    func corner(withRadius: CGFloat) {
        layer.cornerRadius = withRadius
        if self is UIImageView || self is UITextField || self is UILabel {
            clipsToBounds = true
        }
    }
    
    func cornerAll(withRadius: CGFloat) {
        layer.cornerRadius = withRadius
        layer.sublayers?.forEach{ $0.cornerRadius = withRadius}
        if self is UIImageView || self is UITextField || self is UILabel {
            clipsToBounds = true
        }
    }
    
    func shadow(color: UIColor, offset: CGSize, opacity: Float, radius: CGFloat ){
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = CGSize(width: offset.width, height: offset.height)
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    

    
}

extension NSLayoutConstraint {

    static func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([constraint])

        let newConstraint = NSLayoutConstraint(item: constraint.firstItem, attribute: constraint.firstAttribute, relatedBy: constraint.relation, toItem: constraint.secondItem, attribute: constraint.secondAttribute, multiplier: multiplier, constant: constraint.constant)

        newConstraint.priority = constraint.priority
        newConstraint.shouldBeArchived = constraint.shouldBeArchived
        newConstraint.identifier = constraint.identifier

        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }

}
