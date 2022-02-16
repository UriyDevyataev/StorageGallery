//
//  ViewController.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let colorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.magenta, UIColor.yellow, UIColor.gray, UIColor.cyan]

    let dataService = DataServiceImp()
    
    var dataModel = [String: ImageData]()
    var imageKeys = [String]()
    var imageDict = [String: UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        receiveData()
    }
    
    func config() {
        configCollectionView()
    }
    
    func receiveData() {
        
        dataService.receiveData {[weak self] dict in
            guard let self = self else {return}
            self.dataModel = dict
            self.createImageKeys()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } error: { err in
            print(err ?? "")
        }
    }
    
    func createImageKeys() {
        var array = [String]()
        dataModel.forEach { (key: String, value: ImageData) in
            array.append(key)
        }
        imageKeys = array.sorted{$0 < $1}
    }
    
    func configCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.backgroundColor = .black
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(ContentCollectionViewCell.nib(), forCellWithReuseIdentifier: ContentCollectionViewCell.identifier)
    }
    
    func fill(cell: ContentCollectionViewCell, indexPath: IndexPath) -> UICollectionViewCell {

        let imageKey = imageKeys[indexPath.row]
        guard let imageData = dataModel[imageKey] else {
            return UICollectionViewCell()
        }
        
        cell.nameLabel.text = imageData.user_name
        
        if let image = imageDict[imageKeys[indexPath.row]] {
            cell.imageView.image = image
        } else {
            dataService.loadImage(imageKey: imageKey) {[weak self] image in
                guard let self = self else {return}
                self.imageDict[imageKey] = image
                DispatchQueue.main.async {
                    cell.imageView.image = image
                }
            }
        }
        
        cell.imageLinkButtonTap = { [weak self] in
            guard let self = self else {return}
            guard let controller = self.prepareWebViewController(
                startLink: imageData.photo_url) else {
                    return
                }
            self.present(controller, animated: true)
        }
        
        cell.userLinkButtonTap = { [weak self] in
            guard let self = self else {return}
            guard let controller = self.prepareWebViewController(
                startLink: imageData.user_url) else {
                    return
                }
            self.present(controller, animated: true)
        }
        return cell
    }
    
    func prepareWebViewController(startLink: String) -> WebViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller  = storyboard.instantiateViewController(identifier: "WebViewControllerIdent") as? WebViewController {
            controller.modalPresentationStyle = .formSheet
            controller.url = URL(string: startLink)
            return controller
        } else {
            return nil
        }
    }
}

//MARK: - Extension UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let contentCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ContentCollectionViewCell.identifier,
            for: indexPath) as? ContentCollectionViewCell else {return UICollectionViewCell()}
    
        let cell = fill(cell: contentCell, indexPath: indexPath)
        return cell
    }
}

//MARK: - Extension UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    
//        guard let currIndexPath = collectionView.indexPathsForVisibleItems.first else {return}
    }
}

//MARK: - Extension UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

