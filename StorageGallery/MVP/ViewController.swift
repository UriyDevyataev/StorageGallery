//
//  ViewController.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 15.02.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: PresenterInput!
    var model: MainModel?
    
    var currentIndex = 1
    var endOffset: CGFloat = 0.0
    
    var visibleCell = [ContentCollectionViewCell]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        presenter.viewIsReady()
    }
    
    //MARK: - Funcs Configuration
    
    func config() {
        configCollectionView()
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
    
    //MARK: - Funcs for cells
    
    func fill(cell: ContentCollectionViewCell, indexPath: IndexPath) -> UICollectionViewCell {
        
        cell.indexPath = indexPath
        
        let dataImage = model?.data[indexPath.row]
        cell.nameLabel.text = dataImage?.user_name
    
        guard let imageKey = dataImage?.photoKey else {return UICollectionViewCell()}
        
        if let image = presenter.cachedImage(key: imageKey) {
            cell.imageView.image = image
        } else {
            presenter.loadImage(key: imageKey) { image in
                if cell.indexPath == indexPath {
                    DispatchQueue.main.async {
                        cell.imageView.image = image
                    }
                }
            }
        }
        
        cell.imageLinkButtonTap = { [weak self] in
            guard let self = self else {return}
            self.presenter.actionShowWebController(
                withLink: dataImage?.photo_url)
        }
        
        cell.userLinkButtonTap = { [weak self] in
            guard let self = self else {return}
            self.presenter.actionShowWebController(
                withLink: dataImage?.user_url)
        }
        return cell
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
    
    func scrollToStart(visible: Bool) {
        endOffset = collectionView.frame.size.width
        collectionView.scrollToItem(
            at: IndexPath(item: 1, section: 0),
            at: .centeredHorizontally,
            animated: visible)
    }
    
    func scrollToEnd() {
        guard let count = model?.data.count else {return}
        endOffset = CGFloat(count - 2) * collectionView.frame.size.width
        collectionView.scrollToItem(
            at: IndexPath(item: count - 2, section: 0),
            at: .centeredHorizontally,
            animated: false)
    }
    
    func scrollTo(index: Int) {
        endOffset = CGFloat(index) * collectionView.frame.size.width
        collectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: false)
    }
    
    //MARK: - Rotate Device
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.alpha = 0
        collectionView.reloadData()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        presenter.userActivity()
        scrollTo(index: currentIndex)
        UIView.animate(withDuration: 0.2) {
            self.collectionView.alpha = 1
        }
    }
    
    //MARK: - Scroll
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        visibleCell.removeAll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let offsetCell = offset - endOffset
        
        if visibleCell.count < 2 {
            visibleCell = getSortedVisibleCells(offset: offsetCell)
        }

        if visibleCell.count > 0 {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        presenter.userActivity()
        guard let count = model?.data.count else {return}
        endOffset = scrollView.contentOffset.x
        currentIndex = Int(endOffset / collectionView.frame.width)
        switch currentIndex {
        case 0:         scrollToEnd()
        case count - 1: scrollToStart(visible: false)
        default: break
        }
    }
    
    //MARK: - UpdateView
    
    func updateView(model: MainModel) {
        self.model = model
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollToStart(visible: false)
        }
    }
}

//MARK: - Extension UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = model?.data.count else {return 0}
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let contentCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ContentCollectionViewCell.identifier,
            for: indexPath) as? ContentCollectionViewCell else {return UICollectionViewCell()}
    
        let cell = fill(cell: contentCell, indexPath: indexPath)
        return cell
    }
}

//MARK: - Extension UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

//MARK: - Extension PresenterOutput
extension ViewController: PresenterOutput {
    
    func setState(model: MainModel) {
        updateView(model: model)
    }
    
    func showWebController(controller: WebViewController) {
        self.present(controller, animated: true)
    }
    
    func scrollToStart() {
        scrollToStart(visible: true)
    }
}
