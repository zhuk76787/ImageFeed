//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/22/24.
//

import Foundation
import ImageFeed

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.WebViewViewControllerProtocol?
    //var delegate: WebViewViewControllerDelegateSpy?
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}
