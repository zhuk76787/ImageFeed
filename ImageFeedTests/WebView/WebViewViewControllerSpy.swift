//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Дмитрий Жуков on 7/22/24.
//

import Foundation
import ImageFeed


protocol WebViewViewControllerDelegateSpy: AnyObject {
    func webViewViewController(_ vc: WebViewViewControllerSpy, didAuthenticateWithCode code: String)
   func webViewViewControllerDidCancel(_ vc: WebViewViewControllerSpy)
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: ImageFeed.WebViewPresenterProtocol?
    var delegate: WebViewViewControllerDelegateSpy?
    var loadRequestCalled: Bool = false
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {}
    
    func setProgressHidden(_ isHidden: Bool) {}
}
