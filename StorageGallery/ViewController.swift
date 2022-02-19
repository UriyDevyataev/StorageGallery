//
//  ViewController.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

enum Direction {
    case left
    case right
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var endOffset: CGFloat = 0.0
    
    let colorArray = [UIColor.red, UIColor.blue, UIColor.green, UIColor.magenta, UIColor.yellow, UIColor.gray, UIColor.cyan]

    let dataService = DataServiceImp()
    
    var dataModel = [String: ImageData]()
    var imageKeys = [String]()
    var imageDict = [String: UIImage]()
    
    var arrayPoints = [CGPoint]()
    
    var startPoint = CGPoint.zero
    
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
        
        collectionView.backgroundColor = .clear
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
        
        cell.indexPath = indexPath
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
    
    func getSortedVisibleCells(offset: CGFloat) -> [ContentCollectionViewCell]? {
        
        guard let arrayVisibleCells = collectionView.visibleCells as? [ContentCollectionViewCell] else {return nil}
        
        var cellArray : [ContentCollectionViewCell]?

        if offset > 0 {
            cellArray = arrayVisibleCells.sorted{
                $0.indexPath.row < $1.indexPath.row}
            as [ContentCollectionViewCell]
        }

        if offset < 0 {
            cellArray = arrayVisibleCells.sorted{
                $0.indexPath.row > $1.indexPath.row}
            as [ContentCollectionViewCell]
        }
        return cellArray
    }
    
    func getScale(forOffset: CGFloat, withRange: CGFloat) -> (downScale: CGFloat?, upScale: CGFloat?) {
        
        var scale : (downScale: CGFloat?, upScale: CGFloat?) = (nil, nil)
        
        let maxScale: CGFloat = 1
        let minScale: CGFloat = maxScale - withRange
        
        let halfWidth = collectionView.frame.width / 2
        let gain = abs(forOffset) / halfWidth

        let downScale = maxScale - withRange * gain
        scale.downScale = downScale > minScale ? downScale : nil
    
        let upScale = minScale + withRange * gain
        scale.upScale = upScale < maxScale ? upScale : nil
        
        return scale
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
    
    func isRightDirection(point: CGPoint) -> Direction? {
        if arrayPoints.count < 2 {
            arrayPoints.append(point)
            return nil
        } else {
            return arrayPoints[0].x > arrayPoints[1].x ? Direction.left : Direction.right
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endOffset = scrollView.contentOffset.x
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let offset = scrollView.contentOffset.x
        let offsetCell = offset - endOffset
        
        guard let cellArray = getSortedVisibleCells(offset: offsetCell) else {return}
        
        let sizeScaleValue = getScale(forOffset: offsetCell, withRange: 0.1)
        let alphaScaleValue = getScale(forOffset: offsetCell, withRange: 0.3)
        let parallaxScaleValue = getScale(forOffset: offsetCell, withRange: 0.3)

        cellArray[0].sizeScale(value: sizeScaleValue.downScale)
        cellArray[0].alphaScale(value: alphaScaleValue.downScale)
        cellArray[0].parallaxScale(value: parallaxScaleValue.downScale)

        if cellArray.count > 1 {
            cellArray[1].sizeScale(value: sizeScaleValue.upScale)
            cellArray[1].alphaScale(value: alphaScaleValue.upScale)
            cellArray[1].parallaxScale(value: parallaxScaleValue.upScale)
        }
    }
}

//MARK: - Extension UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
