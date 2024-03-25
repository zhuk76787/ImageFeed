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
            ImageInScrollView()
            centerImage()
        }
    }
    
    @IBOutlet var singleImage: UIImageView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        singleImage.image = image
        self.ImageInScrollView()
        self.centerImage()
        imageScrollView.zoomScale = imageScrollView.minimumZoomScale
       
        
    }
    
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
        
    }
    func configurateFor(imageSize: CGSize) {
        imageScrollView.contentSize = imageSize
        ImageInScrollView()
        viewDidLayoutSubviews()
    }

    private func centerImage() {
        let boundSize = imageScrollView.bounds.size
        var frameToCenter = singleImage.frame
        
        if frameToCenter.size.width < boundSize.width {
            frameToCenter.origin.x = (boundSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }
        if frameToCenter.size.height < boundSize.height {
            frameToCenter.origin.y = (boundSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }
        
        singleImage.frame = frameToCenter
    }
    
    private func ImageInScrollView() {
        let visibleRectSize = imageScrollView.bounds.size
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
        imageScrollView.minimumZoomScale = minScale
        imageScrollView.maximumZoomScale = maxScale
        
        let newContentSize = imageScrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        imageScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
     
}


extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        singleImage
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView){
        self.centerImage()
    }
}

                                         /*
                                         let minZoomScale = imageScrollView.minimumZoomScale
                                         let maxZoomScale = imageScrollView.maximumZoomScale
                                         view.layoutIfNeeded()
                                         let visibleRectSize = imageScrollView.bounds.size
                                         let imageSize = image.size
                                         let hScale = visibleRectSize.width / imageSize.width
                                         let vScale = visibleRectSize.height / imageSize.height
                                         let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
                                         imageScrollView.setZoomScale(scale, animated: false)
                                         imageScrollView.layoutIfNeeded()
                                         let newContentSize = imageScrollView.contentSize
                                         let x = (newContentSize.width - visibleRectSize.width) / 2
                                         let y = (newContentSize.height - visibleRectSize.height) / 2
                                         imageScrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
                                          */
