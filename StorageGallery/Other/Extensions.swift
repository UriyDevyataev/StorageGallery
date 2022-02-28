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
    
    func corner(withRadius: CGFloat) {
        layer.cornerRadius = withRadius
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

// MARK: - NSLayoutConstraint

extension NSLayoutConstraint {
    
    static func setMultiplier(_ multiplier: CGFloat, of constraint: inout NSLayoutConstraint) {
        NSLayoutConstraint.deactivate([constraint])

        let newConstraint = NSLayoutConstraint(
            item: constraint.firstItem as Any,
            attribute: constraint.firstAttribute,
            relatedBy: constraint.relation,
            toItem: constraint.secondItem,
            attribute: constraint.secondAttribute,
            multiplier: multiplier,
            constant: constraint.constant)

        newConstraint.priority = constraint.priority
        newConstraint.shouldBeArchived = constraint.shouldBeArchived
        newConstraint.identifier = constraint.identifier

        NSLayoutConstraint.activate([newConstraint])
        constraint = newConstraint
    }
}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func sizeWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGSize {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let font = UIFont.systemFont(ofSize: 1000)
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesFontLeading],
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        
        return boundingBox.size
    }
}
