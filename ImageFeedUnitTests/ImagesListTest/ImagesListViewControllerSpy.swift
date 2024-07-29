//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/23/24.
//

import Foundation
import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var updateTableViewAnimatedWasCalled: Bool = false
    
    func viewDidLoad() {
        presenter?.fetchPhotosNextPage()
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedWasCalled = true
    }
}
