////
////  WebViewViewController.swift
////  ImageFeed
////
////  Created by Дмитрий Жуков on 4/3/24.
////
//
//
//import UIKit
//import WebKit
//
//protocol WebViewViewControllerDelegate: AnyObject {
//    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
//    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
//}
//
//public protocol WebViewViewControllerProtocol: AnyObject {
//    var presenter: WebViewPresenterProtocol? { get set }
//    func load(request: URLRequest)
//    func setProgressValue(_ newValue: Float)
//    func setProgressHidden(_ isHidden: Bool)
//   }
//
//final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
//    @objc private var webView = WKWebView()
//    private var progressView = UIProgressView()
//    
//    private var estimatedProgressObservation: NSKeyValueObservation?
//    
//    weak var delegate: WebViewViewControllerDelegate?
//    var presenter: WebViewPresenterProtocol?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
//        setupLayer()
//        configureProgressIndicator()
//        presenter?.viewDidLoad()
//        webView.navigationDelegate = self
//        
//        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: .new) { [weak self] _, _ in
//                    guard let self = self else { return }
//                    self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
//                }
//    }
//    
//    deinit {
//            estimatedProgressObservation?.invalidate()
//        }
//    
//    @IBAction private func didTapBackButton(_ sender: Any?) {
//        delegate?.webViewViewControllerDidCancel(self)
//    }
//    
//    
////    override func observeValue(
////            forKeyPath keyPath: String?,
////            of object: Any?,
////            change: [NSKeyValueChangeKey : Any]?,
////            context: UnsafeMutableRawPointer?
////        ) {
////            if keyPath == #keyPath(webView.estimatedProgress) {
////                presenter?.didUpdateProgressValue(webView.estimatedProgress)
////            } else {
////                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
////            }
////        }
//    
//    func setProgressValue(_ newValue: Float) {
//        progressView.progress = newValue
//    }
//
//    func setProgressHidden(_ isHidden: Bool) {
//        progressView.isHidden = isHidden
//    }
//    
//    func load(request: URLRequest) {
//        webView.load(request)
//    }
//}
//
//extension WebViewViewController {
//    
//    
//    func setupLayer() {
//        webView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(webView)
//        
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    func configureProgressIndicator() {
//        progressView.translatesAutoresizingMaskIntoConstraints = false
//        progressView.progressViewStyle = .default
//        progressView.setProgress(0.1, animated: true)
//        progressView.tintColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
//        
//        webView.addSubview(progressView)
//        
//        NSLayoutConstraint.activate([
//            progressView.heightAnchor.constraint(equalToConstant: 4),
//            progressView.leadingAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.leadingAnchor),
//            progressView.trailingAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.trailingAnchor),
//            progressView.topAnchor.constraint(equalTo: webView.safeAreaLayoutGuide.topAnchor)
//            
//        ])
//    }
//}
//
//extension WebViewViewController: WKNavigationDelegate {
//    func webView(
//        _ webView: WKWebView,
//        decidePolicyFor navigationAction: WKNavigationAction,
//        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
//    ) {
//        if let code = code(from: navigationAction) {
//            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
//            decisionHandler(.cancel)
//        } else {
//            decisionHandler(.allow)
//        }
//    }
//    
//    private func code(from navigationAction: WKNavigationAction) -> String? {
//        if let url = navigationAction.request.url {
//            return presenter?.code(from: url)
//        }
//        return nil
//    } 
//}


import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    private var webView = WKWebView()
    private var progressView = UIProgressView()
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayer()
        configureProgressIndicator()
        presenter?.viewDidLoad()
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: .new) { [weak self] _, _ in
            guard let self = self else { return }
            print("Estimated progress: \(self.webView.estimatedProgress)")
            self.presenter?.didUpdateProgressValue(self.webView.estimatedProgress)
        }
    }
    
//    deinit {
//        estimatedProgressObservation?.invalidate()
//    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    func setProgressValue(_ newValue: Float) {
        print("Setting progress value: \(newValue)")
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        print("Setting progress hidden: \(isHidden)")
        progressView.isHidden = isHidden
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewViewController {
    private func setupLayer() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureProgressIndicator() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .default
        progressView.tintColor = .gray
        
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 4),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        }
        return nil
    }
}
