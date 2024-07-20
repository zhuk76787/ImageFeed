////
////  WebViewPresenter.swift
////  ImageFeed
////
////  Created by Дмитрий Жуков on 7/18/24.
////
//
//import Foundation
//
//public protocol WebViewPresenterProtocol {
//    var view: WebViewViewControllerProtocol? { get set }
//    func viewDidLoad()
//    func didUpdateProgressValue(_ newValue: Double)
//    func code(from url: URL) -> String?
//}
//
//final class WebViewPresenter: WebViewPresenterProtocol {
//    weak var view: WebViewViewControllerProtocol?
//    func viewDidLoad() {
//        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
//            assertionFailure("Ошибка подготовки \(WebViewConstants.unsplashAuthorizeURLString)")
//            return
//        }
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//        guard let url = urlComponents.url else {
//            return
//        }
//        let request = URLRequest(url: url)
//        
//        view?.load(request: request)
//        didUpdateProgressValue(0)
//    }
//    
//    func didUpdateProgressValue(_ newValue: Double) {
//            let newProgressValue = Float(newValue)
//            view?.setProgressValue(newProgressValue)
//            
//            let shouldHideProgress = shouldHideProgress(for: newProgressValue)
//            view?.setProgressHidden(shouldHideProgress)
//        }
//        
//        func shouldHideProgress(for value: Float) -> Bool {
//            abs(value - 1.0) <= 0.0001
//        }
//    
//    func code(from url: URL) -> String? {
//        if let urlComponents = URLComponents(string: url.absoluteString),
//           urlComponents.path == "/oauth/authorize/native",
//           let items = urlComponents.queryItems,
//           let codeItem = items.first(where: { $0.name == "code" })
//        {
//            return codeItem.value
//        } else {
//            return nil
//        }
//    }
//}


import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            assertionFailure("Ошибка подготовки \(WebViewConstants.unsplashAuthorizeURLString)")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            return
        }
        let request = URLRequest(url: url)
        
        view?.load(request: request)
        didUpdateProgressValue(0.0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        print("Presenter updating progress to: \(newProgressValue)")
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        print("Presenter setting progress hidden: \(shouldHideProgress)")
        view?.setProgressHidden(shouldHideProgress)
    }
    
     func shouldHideProgress(for value: Float) -> Bool {
        return abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == "/oauth/authorize/native",
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        } else {
            return nil
        }
    }
}
