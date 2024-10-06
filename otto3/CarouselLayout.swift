//
//  CarouselLayout.swift
//  otto3
//
//  Cade Guerrero-Miranda
//  Cooper Engebretson

import UIKit

class CarouselLayout: UICollectionViewLayout {
    private var cache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private let itemHeight: CGFloat = 200
    private let itemWidth: CGFloat = 370
    private let itemSpacing: CGFloat = 20
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: contentHeight)
    }
    
    override func prepare() {
        guard let collectionView = collectionView else { return }
        
        cache.removeAll()
        contentHeight = 0
        
        let centerY = collectionView.bounds.height / 2
        
        for i in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let yPosition = centerY - (itemHeight / 2) + (CGFloat(i) * (itemHeight + itemSpacing))
            attributes.frame = CGRect(x: (collectionView.bounds.width - itemWidth) / 2, y: yPosition, width: itemWidth, height: itemHeight)
            attributes.transform = CGAffineTransform(translationX: 0, y: -CGFloat(i) * 10).rotated(by: CGFloat(i) * 0.1)
            cache.append(attributes)
            contentHeight = max(contentHeight, attributes.frame.maxY)
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}
