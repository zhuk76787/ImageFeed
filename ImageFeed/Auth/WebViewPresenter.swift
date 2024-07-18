//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 7/18/24.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
}
