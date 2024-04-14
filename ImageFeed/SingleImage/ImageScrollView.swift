//
//  ImageScrollView.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/24/24.
//

import UIKit

class ImageScrollView: UIScrollView {

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

}
