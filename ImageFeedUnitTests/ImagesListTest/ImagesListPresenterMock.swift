//
//  ImagesListPresenterMock.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation
import ImageFeed

final class ImagesListPresenterMock: ImagesListPresenterProtocol {
    private let imagesListService = ImagesListServiceSpy.shared
    var view: ImageFeed.ImagesListViewControllerProtocol?
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage()
    }
}
