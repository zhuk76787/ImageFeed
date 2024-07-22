//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation
import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var fetchPhotosNextPageWasCalled: Bool = false
    
    func fetchPhotosNextPage() {
        fetchPhotosNextPageWasCalled = true
    }
}
