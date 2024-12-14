//
//  KUICarouselCollectionView.swift
//  KikurageUI
//
//  Created by Shusuke Ota on 2024/12/14.
//  Copyright © 2024 shusuke. All rights reserved.
//

import FirebaseStorageUI
import UIKit

public struct KUICarouselCollectionViewProps {
    let height: CGFloat

    public init(height: CGFloat = 320) {
        self.height = height
    }
}

public class KUICarouselCollectionView: UIView {
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!

    public init(props: KUICarouselCollectionViewProps) {
        super.init(frame: .zero)
        setupComponent(props: props)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configDelegate(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }

    public func setPageControlNumber(imageCount: Int) {
        if imageCount <= 1 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = imageCount
        }
    }

    public func updateCurrentPage(index: Int) {
        pageControl.currentPage = index
    }

    private func setupComponent(props: KUICarouselCollectionViewProps) {
        let flowLayout = KUICarouselCollectionFlowLayout()
        flowLayout.estimatedItemSize = .zero
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(KUICarouselCollectionViewCell.self, forCellWithReuseIdentifier: KUICarouselCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .gray
        pageControl.pageIndicatorTintColor = .white
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        addSubview(collectionView)
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: props.height),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

/**
 このクラスで実装されている主な機能
 - CollectionViewのスクロール停止ポイントを制御する
 - https://github.com/nkmrh/PagingCollectionView/blob/master/LICENSE を元に作成
 */
class KUICarouselCollectionFlowLayout: UICollectionViewFlowLayout {
    // ユーザーがセルをスクロールして離した時に呼ばれる
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
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
        guard let targetAttributes = layoutAttributesForElements(in: expandedVisibleRect)?.sorted(by: { $0.frame.minX < $1.frame.minX }) else {
            return proposedContentOffset
        }
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
        guard let attributes = nextAttributes else {
            return proposedContentOffset
        }
        // 画面左端からのセル余白
        let cellLeftMargin = (collectionView.bounds.width - attributes.bounds.width) * 0.5

        return CGPoint(x: attributes.frame.minX - cellLeftMargin, y: collectionView.contentOffset.y)
    }

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

public class KUICarouselCollectionViewCell: UICollectionViewCell {
    public static let identifier = "CarouselCollectionViewCell"

    private(set) var zoomingImageView: KUIZoomingImageView!

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupComponsent()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setImage(imageStoragePath: String) {
        let storageReference = Storage.storage().reference(withPath: imageStoragePath)
        zoomingImageView.imageView.sd_setImage(with: storageReference, placeholderImage: nil)
    }

    private func setupComponsent() {
        zoomingImageView = KUIZoomingImageView()
        zoomingImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(zoomingImageView)

        NSLayoutConstraint.activate([
            zoomingImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            zoomingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            zoomingImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            zoomingImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
