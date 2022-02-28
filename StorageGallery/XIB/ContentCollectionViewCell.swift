//
//  ContentCollectionViewCell.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var widthView: NSLayoutConstraint!
    @IBOutlet weak var heighLabel: NSLayoutConstraint!
    @IBOutlet weak var widthButton: NSLayoutConstraint!
    
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
    
    let mulButtonPortret = 0.2
    let mulButtonLandscape = 0.09
    
    let mulLabelLandscape = 0.2
    
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
        configSizeUI()
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
            normalEqualWidthConstarint, of: &widthView)
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
    
    private func getHeighLabelForPortrait() -> CGFloat? {
        
        guard let text = nameLabel.text else {return nil}
        
        let pointSize = getFontHeigh(
            text: text,
            width: nameLabel.frame.width)
        
        return pointSize
    }
    
    private func configLabel() {
        nameLabel.backgroundColor = .clear
        
        guard let font = UIFont(
            name: "Avenir Next Ultra Light",
            size: nameLabel.frame.height)
        else {return}
        
        nameLabel.font = font
    
        nameLabel.layer.shadowColor = UIColor.black.cgColor
        nameLabel.layer.shadowRadius = 1.0
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowOffset = CGSize(width: 4, height: 3)
    }
    
    private func getFontHeigh(text: String, width: CGFloat) -> CGFloat {
        var height: CGFloat = 0
                
        for i in 1...100 {
            let pointSize = CGFloat(i)
            let font = UIFont(name: "Avenir Next Ultra Light",
                              size: CGFloat(pointSize))
            
            let newSize = text.sizeWithConstrainedWidth(
                width: width,
                font: font ?? UIFont.systemFont(ofSize: pointSize))
            
            if newSize.width >= width {
                height = pointSize - 1
                break
            }
        }
        return height
    }
    
    private func configSizeUI() {
        let size = customContentView.frame.size
        let isLandscape = size.height < size.width
            
        //Button
        let mul = isLandscape ? mulButtonLandscape : mulButtonPortret
        NSLayoutConstraint.setMultiplier(mul, of: &widthButton)
        
        //Label
        let heighLandscape = mulLabelLandscape * size.height
        guard let heighPortrait = getHeighLabelForPortrait() else {return}
        
        let constant = isLandscape ? heighLandscape : heighPortrait
        heighLabel.constant = constant
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
        NSLayoutConstraint.setMultiplier(newValue, of: &widthView)
    }
    
    //MARK: - Actions
    
    @IBAction func imageLinkAction(_ sender: UIButton) {
        imageLinkButtonTap?()
    }
    
    @IBAction func userLinkAction(_ sender: Any) {
        userLinkButtonTap?()
    }
}
