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
    var normalEqualWidthConstarint: CGFloat = 0.8
    
    var imageLinkButtonTap: (() -> ())?
    var userLinkButtonTap: (() -> ())?
    
    static func nib() -> UINib {
        return UINib(nibName: "ContentCollectionViewCell",
                     bundle: nil)
    }
    
    //MARK: - Draw cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configContentView()
        configImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configLabel()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        prepare()
    }
    
    func prepare() {
        indexPath = nil
        imageView.image = nil
        customContentView.alpha = 1
        customContentView.transform = CGAffineTransform.identity
        NSLayoutConstraint.setMultiplier(
            normalEqualWidthConstarint, of: &equalWidth)
    }
    
    //MARK: - Funcs Configurations
    
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
    
    //MARK: - Public Funcs
    
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
    }
    
    //MARK: - Actions
    
    @IBAction func imageLinkAction(_ sender: UIButton) {
        imageLinkButtonTap?()
    }
    
    @IBAction func userLinkAction(_ sender: Any) {
        userLinkButtonTap?()
    }
}
