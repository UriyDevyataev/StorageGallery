//
//  CustomButton.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 20.02.2022.
//

import UIKit

class CustomButton: UIButton {
    
    var curWidth: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitle("", for: .normal)
        self.tintColor = .white
        self.backgroundColor = .lightGray.withAlphaComponent(0.5)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if curWidth != bounds.width {
            curWidth = bounds.width
                    
            self.layer.cornerRadius = self.frame.size.height/2

            let size = self.frame.height * 0.5
            let config = UIImage.SymbolConfiguration(pointSize: size)

            let imagePerson = UIImage(systemName: "person.fill",
                                      withConfiguration: config)
            let imageSafary = UIImage(systemName: "safari",
                                      withConfiguration: config)

            switch restorationIdentifier {
            case "1": self.setImage(imagePerson, for: .normal)
            case "2": self.setImage(imageSafary, for: .normal)
            default: break
            }
        }
    }
}
