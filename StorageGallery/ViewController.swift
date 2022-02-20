//
//  ViewController.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let dataService = DataServiceImp()
    
    var timer: Timer?
    var endOffset: CGFloat = 0.0
    
    var dataModel = [ImageData]()
    var imageDict = [String: UIImage]()
    var visibleCell = [ContentCollectionViewCell]()
    
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
            self.configModelToInfinity()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.scrollToItem(
                    at: IndexPath(item: 1, section: 0),
                    at: .left,
                    animated: false)
            }
        } error: { err in
            print(err ?? "")
        }
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
        
        cell.indexPath = indexPath
        
        let dataImage = dataModel[indexPath.row]
        cell.nameLabel.text = dataImage.user_name
        
        guard let imageKey = dataImage.photoKey else {return UICollectionViewCell()}
        
        if let image = imageDict[imageKey] {
            cell.imageView.image = image
        } else {
            dataService.loadImage(imageKey: imageKey) {[weak self] image in
                guard let self = self else {return}
                self.imageDict[imageKey] = image
                
                if cell.indexPath == indexPath {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        cell.imageLinkButtonTap = { [weak self] in
            guard let self = self else {return}
            guard let controller = self.prepareWebViewController(
                startLink: dataImage.photo_url) else {
                    return
                }
            self.present(controller, animated: true)
        }
        
        cell.userLinkButtonTap = { [weak self] in
            guard let self = self else {return}
            guard let controller = self.prepareWebViewController(
                startLink: dataImage.user_url) else {
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
    
    func getSortedVisibleCells(offset: CGFloat) -> [ContentCollectionViewCell] {
        var cellArray = [ContentCollectionViewCell]()
        
        guard let arrayVisibleCells = collectionView.visibleCells as? [ContentCollectionViewCell] else {return cellArray}

        if offset > 0 {
            cellArray = arrayVisibleCells.sorted{
                $0.indexPath!.row < $1.indexPath!.row}
            as [ContentCollectionViewCell]
        }

        if offset < 0 {
            cellArray = arrayVisibleCells.sorted{
                $0.indexPath!.row > $1.indexPath!.row}
            as [ContentCollectionViewCell]
        }
        return cellArray
    }
    
    func getScale(forOffset: CGFloat, withRange: CGFloat) -> (downScale: CGFloat, upScale: CGFloat) {
        
        let maxScale: CGFloat = 1
        let minScale: CGFloat = maxScale - withRange
        
        var scale : (downScale: CGFloat, upScale: CGFloat) = (minScale, maxScale)
        
        let halfWidth = collectionView.frame.width / 2
        let gain = abs(forOffset) / halfWidth

        let downScale = maxScale - withRange * gain
        scale.downScale = downScale > minScale ? downScale : minScale
    
        let upScale = minScale + withRange * gain
        scale.upScale = upScale < maxScale ? upScale : maxScale
        
        return scale
    }
    
    func configModelToInfinity() {
        let saveFirst = dataModel.first!
        dataModel.insert(dataModel.last!, at: 0)
        dataModel.append(saveFirst)
    }
    
    func createTimer(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5,
                                         target: self,
                                         selector: #selector(timerInretval),
                                         userInfo: nil,
                                         repeats: true)
    }
    
    @objc func timerInretval(){
        timer?.invalidate()
        scrollToStart()
    }
    
    func scrollToStart() {
        endOffset = collectionView.frame.size.width
        collectionView.scrollToItem(
            at: IndexPath(item: 1, section: 0),
            at: .left,
            animated: true)
    }
    
    func scrollToEnd() {
        endOffset = CGFloat(dataModel.count - 2) * collectionView.frame.size.width
        collectionView.scrollToItem(
            at: IndexPath(item: dataModel.count - 2, section: 0),
            at: .centeredHorizontally,
            animated: false)
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        endOffset = scrollView.contentOffset.x
        let currentIndexPath = Int(endOffset / collectionView.frame.width)
    
        switch currentIndexPath {
        case 0:                     scrollToEnd()
        case dataModel.count - 1:   scrollToStart()
        default: break
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        createTimer()
        visibleCell.removeAll()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let offsetCell = offset - endOffset
        
        if visibleCell.count < 2 {
            visibleCell = getSortedVisibleCells(offset: offsetCell)
        }
        
        if visibleCell.count > 1 {
            let sizeScaleValue = getScale(forOffset: offsetCell, withRange: 0.1)
            let alphaScaleValue = getScale(forOffset: offsetCell, withRange: 0.3)
            let parallaxScaleValue = getScale(forOffset: offsetCell, withRange: 0.3)

            visibleCell[0].sizeScale(value: sizeScaleValue.downScale)
            visibleCell[0].alphaScale(value: alphaScaleValue.downScale)
            visibleCell[0].parallaxScale(value: parallaxScaleValue.downScale)

            if visibleCell.count > 1 {
                visibleCell[1].sizeScale(value: sizeScaleValue.upScale)
                visibleCell[1].alphaScale(value: alphaScaleValue.upScale)
                visibleCell[1].parallaxScale(value: parallaxScaleValue.upScale)
            }
        }
    }
}

//MARK: - Extension UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
