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
    
    @IBOutlet var singleImage: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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

/*
func configurateFor(imageSize: CGSize) {
    scrollView.contentSize = imageSize
    imageInScrollView(image: image!)
}
*/

/*
 lazy var zoomingTap: UITapGestureRecognizer = {
     let zoomingTap = UITapGestureRecognizer(target: scrollView, action: #selector(handelZoomingTap))
     zoomingTap.numberOfTapsRequired = 2
     return zoomingTap
 }()
 
 @objc func handelZoomingTap(sender: UITapGestureRecognizer) {
     let location = sender.location(in: sender.view)
     scrollView.zoom(point: location, animated: true)
 }
 
 func zoom(point: CGPoint, animated: Bool) {
     let currectScale = scrollView.zoomScale
     let minScale = scrollView.minimumZoomScale
     let maxScale = scrollView.maximumZoomScale
     
     if (minScale == maxScale && minScale > 1) {
         return
     }
     let toScale = maxScale
     let finalScale = (currectScale == minScale) ? toScale : minScale
     
     let zoomRect = scrollView.zoomToCGRect(scale: finalScale, center: point)
     scrollView.zoom(to: zoomRect, animated: animated)
 }
 
 func zoomToCGRect(scale: CGFloat, center: CGPoint) -> CGRect {
     var zoomRect = CGRect.zero
     let bounds = scrollView.bounds
     
     zoomRect.size.width = bounds.size.width / scale
     zoomRect.size.height = bounds.size.height / scale
     
     zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
     zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
     
     return zoomRect
 }
 */
