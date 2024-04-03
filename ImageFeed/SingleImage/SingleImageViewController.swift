//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/17/24.
//

import UIKit

final class SingleImageViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            singleImage.image = image
            if let image = image {
                imageInScrollView(image: image)
            }
        }
    }
    
    @IBOutlet private var singleImage: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        singleImage.image = image
        imageInScrollView(image: image)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image!],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
   
    private func imageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let xScale = visibleRectSize.width / imageSize.width
        let yScale = visibleRectSize.height / imageSize.height
        let minScale = min(xScale, yScale)
        var maxScale: CGFloat = 1.0
        if minScale < 0.1 {
            maxScale = 0.3
        }
        if minScale >= 0.1 && minScale < 0.5 {
            maxScale = 0.7
        }
        if minScale >= 0.5 {
            maxScale = max(1.0, minScale)
        }
        scrollView.minimumZoomScale = minScale
        scrollView.maximumZoomScale = maxScale
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let scale = min(maxZoomScale, max(minZoomScale, minScale))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
   
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.singleImage
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundSize = scrollView.bounds.size
        let frameToCenter = singleImage.frame
        let offSetX = max((boundSize.width - frameToCenter.size.width) / 2, 0)
        let offSetY = max((boundSize.height - frameToCenter.size.height) / 2, 0)
        scrollView.contentInset = UIEdgeInsets(top: offSetY, left: offSetX, bottom: 0, right: 0)
    }
    
    
}

