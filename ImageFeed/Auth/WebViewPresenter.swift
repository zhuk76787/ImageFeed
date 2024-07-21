//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 7/18/24.
//
import Foundation

public protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    var authHelper: AuthHelperProtocol
    
    init(view: WebViewViewControllerProtocol,
         delegate: WebViewViewControllerDelegate,
         authHelper: AuthHelperProtocol) {
        self.view = view
        self.delegate = delegate
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let request = authHelper.authRequest() else {return}
        view?.load(request: request)
        //print(request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        //print("Presenter updating progress to: \(newProgressValue)")
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        //print("Presenter setting progress hidden: \(shouldHideProgress)")
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
