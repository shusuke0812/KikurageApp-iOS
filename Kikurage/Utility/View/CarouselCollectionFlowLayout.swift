//
//  CarouselCollectionFlowLayout.swift
//  Kikurage
//
//  Created by Shusuke Ota on 2020/12/23.
//  Copyright © 2020 shusuke. All rights reserved.
//

import UIKit

/**
このクラスで実装されている主な機能
- CollectionViewのスクロール停止ポイントを制御する
- https://github.com/nkmrh/PagingCollectionView/blob/master/LICENSE を元に作成
*/
class CarouselCollectionFlowLayout: UICollectionViewFlowLayout {
    // ユーザーがセルをスクロールして離した時に呼ばれる
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return proposedContentOffset }
        // セクションの余白
        let expansionMargin = sectionInset.left + sectionInset.right
        // セルの位置とサイズを記録
        let expandedVisibleRect = CGRect(
            x: collectionView.contentOffset.x - expansionMargin,
            y: 0,
            width: collectionView.bounds.width + (expansionMargin * 2),
            height: collectionView.bounds.height
        )
        // CollectionViewの表示領域 attributes（セルの大きさ・位置・重なり順 etc）を取得
        guard let targetAttributes = layoutAttributesForElements(in: expandedVisibleRect)?.sorted(by: { $0.frame.minX < $1.frame.minX }) else { return proposedContentOffset }
        let nextAttributes: UICollectionViewLayoutAttributes?
        // Attributes設定
        // velocity.x == 0: スワイプ無しで指を離したとき、velocity.x > 0: 左スワイプしたとき、velocity.x < 0: 右スワイプしたとき
        if velocity.x == 0 {
            nextAttributes = layoutAttributesForNeabyCenterX(in: targetAttributes, collectionView: collectionView)
        } else if velocity.x > 0 {
            nextAttributes = targetAttributes.last
        } else {
            nextAttributes = targetAttributes.first
        }
        guard let attributes = nextAttributes else { return proposedContentOffset }
        // 画面左端からのセル余白
        let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5

        return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
    }
}

// MARK: - Private

extension CarouselCollectionFlowLayout {
    /// 画面中央に一番近いセルのattributesを取得する
    private func layoutAttributesForNeabyCenterX(in attributes: [UICollectionViewLayoutAttributes], collectionView: UICollectionView) -> UICollectionViewLayoutAttributes? {
        let screenCenterX = collectionView.contentOffset.x + collectionView.bounds.width * 0.5
        let result = attributes.reduce((attributes: nil as UICollectionViewLayoutAttributes?, distance: CGFloat.infinity)) { result, attributes in
            let distance = attributes.frame.midX - screenCenterX
            return abs(distance) < abs(result.distance) ? (attributes, distance) : result
        }
        return result.attributes
    }
}
