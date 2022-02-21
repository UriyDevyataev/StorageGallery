//
//  ContentCollectionViewCell.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var equalHeight: NSLayoutConstraint!
    @IBOutlet weak var equalWidth: NSLayoutConstraint!

    @IBOutlet weak var customContentView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageLinkButton: UIButton!
    @IBOutlet weak var userLinkButton: UIButton!
    
    static let identifier = "ContentCollectionViewCell"
        
    var indexPath: IndexPath?
    
    var size: CGFloat = 0
    
    var normalEqualWidth: CGFloat?
    var normalEqualWidthConstarint: CGFloat = 0.8
    
    var imageLinkButtonTap: (() -> ())?
    var userLinkButtonTap: (() -> ())?
    
    static func nib() -> UINib {
        return UINib(nibName: "ContentCollectionViewCell",
                     bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        configButtons()
        configContentView()
        configImageView()
//        configLayoutButtons()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        configLayoutButtons()
        configLabel()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
//        let config = UIImage.SymbolConfiguration(pointSize: size)
//
//        let imageSafary = UIImage(systemName: "safari",
//                                  withConfiguration: config)
//        let imagePerson = UIImage(systemName: "person.fill",
//                                  withConfiguration: config)
//
//        if imageLinkButton.imageView?.image == nil {
//            imageLinkButton.setImage(imageSafary, for: .normal)
//            userLinkButton.setImage(imagePerson, for: .normal)
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        indexPath = nil
        imageView.image = nil
        customContentView.alpha = 1
        customContentView.transform = CGAffineTransform.identity
        NSLayoutConstraint.setMultiplier(
            normalEqualWidthConstarint, of: &equalWidth)
    }
    
    private func configContentView() {
        customContentView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        customContentView.corner(withRadius: 25)
        customContentView.shadow(color: .black,
                                 offset: CGSize(width: 5, height: 5),
                                 opacity: 1,
                                 radius: 15)
    }
    
    private func configImageView() {
        imageView.corner(withRadius: 25)
        imageView.contentMode = .scaleAspectFill
    }
    
    private func configLayoutButtons() {
//        imageLinkButton.layoutIfNeeded()
//        imageLinkButton.layer.cornerRadius = imageLinkButton.frame.size.height/2
        
//        userLinkButton.layoutIfNeeded()
//        userLinkButton.layer.cornerRadius = userLinkButton.frame.size.height/2
        
        size = imageLinkButton.frame.width * 0.5
        print(size)
        let config = UIImage.SymbolConfiguration(pointSize: size)


//        let imageSafary = UIImage(systemName: "safari",
//                                  withConfiguration: config)
        
        let imageSafary = UIImage(systemName: "safari")
        let imagePerson = UIImage(systemName: "person.fill",
                                  withConfiguration: config)
//        
//        if imageLinkButton.imageView?.image == nil {
//            imageLinkButton.setImage(imageSafary, for: .normal)
//            userLinkButton.setImage(imagePerson, for: .normal)
//        }
        
//        let imageSafary = UIImage(systemName: "safari")
//        let imagePerson = UIImage(systemName: "person.fill")
//
//        imageLinkButton.imageView?.image = imageSafary
//        userLinkButton.imageView?.image = imagePerson
        imageLinkButton.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        imageLinkButton.setImage(imageSafary, for: .normal)
        userLinkButton.setImage(imagePerson, for: .normal)
    }
    
//    private func configButtons() {
//        imageLinkButton.setTitle("", for: .normal)
//        imageLinkButton.tintColor = .white
//        imageLinkButton.backgroundColor = .lightGray.withAlphaComponent(0.5)
//
//        userLinkButton.setTitle("", for: .normal)
//        userLinkButton.tintColor = .white
//        userLinkButton.backgroundColor = .lightGray.withAlphaComponent(0.5)
//    }
    
    private func configLabel() {
        nameLabel.layoutIfNeeded()
        
        nameLabel.backgroundColor = .clear
        
        nameLabel.font = UIFont(name: "Avenir Next Ultra Light",
                                size: nameLabel.frame.height * 0.8)
        nameLabel.adjustsFontSizeToFitWidth = true
        
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowRadius = 1.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
    }
    
    func sizeScale(value: CGFloat?) {
        guard let value = value else {return}
        customContentView.transform = CGAffineTransform(
            scaleX: value, y: value)
    }
    
    func alphaScale(value: CGFloat?) {
        guard let value = value else {return}
        customContentView.alpha = value
    }
    
    func parallaxScale(value: CGFloat?) {
        
        guard let value = value else {return}
        let newValue = normalEqualWidthConstarint * value
        NSLayoutConstraint.setMultiplier(newValue, of: &equalWidth)
        self.layoutSubviews()
        imageLinkButton.layoutSubviews()
        userLinkButton.layoutSubviews()
    }
    
    @IBAction func imageLinkAction(_ sender: UIButton) {
        imageLinkButtonTap?()
    }
    
    @IBAction func userLinkAction(_ sender: Any) {
        userLinkButtonTap?()
    }
}
