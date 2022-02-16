//
//  ContentCollectionViewCell.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    var imageLinkButtonTap: (() -> ())?
    var userLinkButtonTap: (() -> ())?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageLinkButton: UIButton!
    @IBOutlet weak var userLinkButton: UIButton!
    
    static let identifier = "ContentCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ContentCollectionViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configLayoutButtons()
        configLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func configLayoutButtons() {
        imageLinkButton.layoutIfNeeded()
        imageLinkButton.layer.cornerRadius = imageLinkButton.frame.size.height/2
        
        userLinkButton.layoutIfNeeded()
        userLinkButton.layer.cornerRadius = userLinkButton.frame.size.height/2
        
        let size = imageLinkButton.frame.width * 0.5
        let config = UIImage.SymbolConfiguration(pointSize: size)

        let imageSafary = UIImage(systemName: "safari",
                                  withConfiguration: config)
        let imagePerson = UIImage(systemName: "person.fill",
                                  withConfiguration: config)

        if imageLinkButton.imageView?.image == nil {
            imageLinkButton.setImage(imageSafary, for: .normal)
            userLinkButton.setImage(imagePerson, for: .normal)
        }
    }
    
    private func configButtons() {
        imageLinkButton.setTitle("", for: .normal)
        userLinkButton.setTitle("", for: .normal)
        
        imageLinkButton.backgroundColor = .lightGray.withAlphaComponent(0.5)
        imageLinkButton.tintColor = .white
        
        userLinkButton.backgroundColor = .lightGray.withAlphaComponent(0.5)
        userLinkButton.tintColor = .white
    }
    
    private func configLabel() {
        nameLabel.layoutIfNeeded()
        
        nameLabel.font = UIFont(name: "Avenir Next Ultra Light",
                                size: nameLabel.frame.height * 0.8)

        nameLabel.adjustsFontSizeToFitWidth = true
        
        nameLabel.layer.shadowColor = UIColor.yellow.cgColor
        nameLabel.layer.shadowRadius = 1.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
        nameLabel.layer.masksToBounds = false
    }
    
    @IBAction func imageLinkAction(_ sender: UIButton) {
        imageLinkButtonTap?()
    }
    
    @IBAction func userLinkAction(_ sender: Any) {
        userLinkButtonTap?()
    }
}
