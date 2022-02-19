//
//  examples.swift
//  StorageGallery
//
//  Created by Юрий Девятаев on 19.02.2022.
//

//guard let arrayVisibleCells = collectionView.visibleCells as? [ContentCollectionViewCell] else {return}
//
//if arrayVisibleCells.count == 2 {
//
//    let fullSizeTrack = collectionView.frame.width/2
//    let pos = scrollView.panGestureRecognizer.location(in: self.view)
//    let offset = startPoint.x - pos.x
////            print("offset = \(offset)")
//
//    switch offset {
//    case 0...:
//
//        let ratio = abs(offset) / fullSizeTrack
//
//        let scaleDecrease = 1 - ratio
//        let scaleIncrease = 1 + ratio
//
//        if scaleDecrease >= 0.5, scaleDecrease <= 1 {
//            arrayVisibleCells[1].transform = CGAffineTransform(
//                scaleX: scaleDecrease, y: scaleDecrease)
//            arrayVisibleCells[1].alpha = scaleDecrease
//        }
//
//        if scaleIncrease >= 1, scaleIncrease <= 2 {
//            arrayVisibleCells[0].transform = CGAffineTransform(
//                scaleX: scaleIncrease, y: scaleIncrease)
//            arrayVisibleCells[0].alpha = scaleIncrease
//        }
//
//    case ..<0:
//
//        print("right")
//    default: break
//    }
//}

//        let centerX = scrollView.contentOffset.x + scrollView.frame.size.width/2
//        for cell in collectionView.visibleCells {
//
//            var offsetX = centerX - cell.center.x
//            if offsetX < 0 {
//                offsetX *= -1
//            }
//
//            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
//            if offsetX > 50 {
//
//                let offsetPercentage = (offsetX - 50) / view.bounds.width
//                var scaleX = 1-offsetPercentage
//
//                if scaleX < 0.8 {
//                    scaleX = 0.8
//                }
//                cell.transform = CGAffineTransform(scaleX: scaleX, y: scaleX)
//            }
//        }


//func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//    let offset = scrollView.contentOffset.x
//
//    guard let arrayVisibleCells = collectionView.visibleCells as? [ContentCollectionViewCell] else {return}
//
//    let offsetCell = offset - endOffset
//
//    var cellArray : [ContentCollectionViewCell]?
//
//    if offsetCell > 0 {
//        cellArray = arrayVisibleCells.sorted{
//            $0.indexPath.row < $1.indexPath.row}
//        as [ContentCollectionViewCell]
//    }
//
//    if offsetCell < 0 {
//        cellArray = arrayVisibleCells.sorted{
//            $0.indexPath.row > $1.indexPath.row}
//        as [ContentCollectionViewCell]
//    }
//
//    guard let cellArray = cellArray else {return}
//
//    let minScale: CGFloat = 0.9
//    let maxScale: CGFloat = 1
//    let rangeScale = maxScale - minScale
//
//    let halfWidth = collectionView.frame.width / 2
//    let gain = abs(offsetCell) / halfWidth
//
//    let downScale = maxScale - rangeScale * gain
//    let upScale = minScale + rangeScale * gain
//
//    if downScale >= minScale, downScale <= maxScale {
//        cellArray[0].customContentView.transform = CGAffineTransform(
//            scaleX: downScale, y: downScale)
//    }
//
//    if upScale >= minScale, upScale <= maxScale, cellArray.count > 1 {
//        cellArray[1].customContentView.transform = CGAffineTransform(
//            scaleX: upScale, y: upScale)
//
//    }
//}
