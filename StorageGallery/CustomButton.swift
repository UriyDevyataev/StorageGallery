//
//  CustomButton.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 20.02.2022.
//

import UIKit

class CustomButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitle("", for: .normal)
        self.tintColor = .white
        self.backgroundColor = .lightGray.withAlphaComponent(0.5)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    
        self.layer.cornerRadius = self.frame.size.height/2

        let size = self.frame.height * 0.5
        let config = UIImage.SymbolConfiguration(pointSize: size)

        let imagePerson = UIImage(systemName: "person.fill",
                                  withConfiguration: config)
        let imageSafary = UIImage(systemName: "safari",
                                  withConfiguration: config)

        switch restorationIdentifier {
        case "1":
            if image(for: .normal) != imagePerson {
                self.setImage(imagePerson, for: .normal)
            }
        case "2":
            if image(for: .normal) != imageSafary {
                self.setImage(imageSafary, for: .normal)
            }
        default: break
        }
    }
    

    

}
