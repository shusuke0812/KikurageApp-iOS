//
//  KikurageImageView.swift
//  KikurageFeature
//
//  Created by Shusuke Ota on 2022/11/8.
//  Copyright © 2022 shusuke. All rights reserved.
//

import UIKit

public class KikurageImageView: UIImageView {
    private var scrollView: UIScrollView!
    public var imageView: UIImageView!

    private var scrollViewSize: CGSize { scrollView.frame.size }
    private var imageViewSize: CGSize { imageView.frame.size }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()

        resizeImageViewToFitContent()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()

        resizeImageViewToFitContent()
    }

    // MARK: Init

    private func initialize() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        setupTapGestureInScrollView()

        scrollView.addSubview(imageView)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: topAnchor),
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.contentLayoutGuide.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.frameLayoutGuide.heightAnchor),

            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func resizeImageViewToFitContent() {
        guard let imageSize = imageView.image?.size else { return }
        let ratio = imageSize.width / imageSize.height
        let aspectCnstraint = imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: ratio)
        aspectCnstraint.priority = UILayoutPriority(999)
        aspectCnstraint.isActive = true
        layoutIfNeeded()
    }

    private func setupTapGestureInScrollView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidDoubleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: Update

    public func updateImageView(with image: UIImage) {
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }

    // MARK: Action

    @objc private func viewDidDoubleTap(_ sender: UITapGestureRecognizer) {
        if scrollView.zoomScale == scrollView.minimumZoomScale {
            let tappedLocation = sender.location(in: imageView)
            zoomImage(to: tappedLocation)
        } else {
            resetZoom()
        }
    }

    private func zoomImage(to point: CGPoint) {
        let scale = scrollView.maximumZoomScale
        let origin = CGPoint(x: point.x - (point.x / scale), y: point.y - (point.y / scale))
        let zoomedRectSize = CGSize(width: imageViewSize.width / scale, height: imageViewSize.height / scale)
        scrollView.zoom(to: CGRect(origin: origin, size: zoomedRectSize), animated: true)
    }

    private func resetZoom() {
        let scale = scrollView.minimumZoomScale
        scrollView.setZoomScale(scale, animated: true)
    }
}

// MARK: - UIScrollViewDelegate

extension KikurageImageView: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
    }
}
