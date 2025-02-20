//
//  SwiftPhotoGalleryCell.swift
//  Pods
//
//  Created by Justin Vallely on 9/10/15.
//
//

import Kingfisher
import UIKit

open class SwiftPhotoGalleryCell: UICollectionViewCell {

    var image:UIImage? {
        didSet {
            configureForNewImage(animated: false)
        }
    }

    var url: URL? {
        didSet {
            configureForNewImage(animated: false)
        }
    }

    open var scrollView: UIScrollView
    public let imageView: UIImageView
    fileprivate let loading: UIImage? = UIImage(named: "propertyLoadingImage")

    override init(frame: CGRect) {

        imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        scrollView = UIScrollView(frame: frame)
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: frame)
        var scrollViewConstraints: [NSLayoutConstraint] = []
        var imageViewConstraints: [NSLayoutConstraint] = []

        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView,
                                                        attribute: .leading,
                                                        relatedBy: .equal,
                                                        toItem: contentView, 
                                                        attribute: .leading,
                                                        multiplier: 1,
                                                        constant: 0))

        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: contentView,
                                                        attribute: .top,
                                                        multiplier: 1,
                                                        constant: 0))

        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView,
                                                        attribute: .trailing,
                                                        relatedBy: .equal,
                                                        toItem: contentView,
                                                        attribute: .trailing,
                                                        multiplier: 1,
                                                        constant: 0))

        scrollViewConstraints.append(NSLayoutConstraint(item: scrollView,
                                                        attribute: .bottom,
                                                        relatedBy: .equal,
                                                        toItem: contentView,
                                                        attribute: .bottom,
                                                        multiplier: 1,
                                                        constant: 0))

        contentView.addSubview(scrollView)
        contentView.addConstraints(scrollViewConstraints)

        imageViewConstraints.append(NSLayoutConstraint(item: imageView,
                                                       attribute: .leading,
                                                       relatedBy: .equal,
                                                       toItem: scrollView,
                                                       attribute: .leading,
                                                       multiplier: 1,
                                                       constant: 0))

        imageViewConstraints.append(NSLayoutConstraint(item: imageView,
                                                       attribute: .top,
                                                       relatedBy: .equal,
                                                       toItem: scrollView,
                                                       attribute: .top,
                                                       multiplier: 1,
                                                       constant: 0))

        imageViewConstraints.append(NSLayoutConstraint(item: imageView,
                                                       attribute: .trailing,
                                                       relatedBy: .equal,
                                                       toItem: scrollView,
                                                       attribute: .trailing,
                                                       multiplier: 1, 
                                                       constant: 0))

        imageViewConstraints.append(NSLayoutConstraint(item: imageView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: scrollView,
                                                       attribute: .bottom,
                                                       multiplier: 1,
                                                       constant: 0))

        scrollView.addSubview(imageView)
        scrollView.addConstraints(imageViewConstraints)

        scrollView.delegate = self
        self.backgroundColor = .clear
        setupGestureRecognizer()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc open func doubleTapAction(recognizer: UITapGestureRecognizer) {

        if (scrollView.zoomScale > scrollView.minimumZoomScale) {
            scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
        } else {
            scrollView.setZoomScale(scrollView.maximumZoomScale, animated: true)
        }
    }

    func configureForNewImage(animated: Bool = true) {
        if let url = url {
            imageView.kf.setImage(with: url, placeholder: UIImage(), completionHandler: { result in
                self.imageView.sizeToFit()
                self.setZoomScale()
                self.scrollViewDidZoom(self.scrollView)
            })
        } else {
            imageView.image = image
            imageView.sizeToFit()
            setZoomScale()
            scrollViewDidZoom(scrollView)
            if animated {
                imageView.alpha = 0.0
                UIView.animate(withDuration: 0.5) {
                    self.imageView.alpha = 1.0
                }
            }
        }
    }

    
    // MARK: Private Methods

    private func setupGestureRecognizer() {

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapAction(recognizer:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
    }

    private func setZoomScale() {
        let imageViewSize = imageView.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height

        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: false)
    }
    
}


// MARK: UIScrollViewDelegate Methods
extension SwiftPhotoGalleryCell: UIScrollViewDelegate {

    open func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    open func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        if verticalPadding >= 0 {
            // Center the image on screen
            scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        } else {
            // Limit the image panning to the screen bounds
            scrollView.contentSize = imageViewSize
        }
    }

}
