//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/14/24.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func updateView(data: Profile)
    func setAvatar(url: URL)
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    private var imageView = UIImageView()
    private var nameLabel = UILabel()
    private var idLable = UILabel()
    private var statusLable = UILabel()
    private var button = UIButton()
    
    private let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    var presenter: ProfilePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ProfilePresenter(view: self)
        setupView()
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification,
                                                                             object: nil,
                                                                             queue: .main) {
            [weak self] _ in
            guard let self = self else {return}
            self.presenter?.updateAvatar()
        }
        presenter?.updateAvatar()
        presenter?.updateProfileDetails()
    }
    @objc
    private func didTapButton() {
        showLogoutAlert()
    }
}
    
extension ProfileViewController {
    func updateView(data: Profile) {
        nameLabel.text = data.name
        idLable.text = data.loginName
        statusLable.text = data.bio
    }
    
    func setAvatar(url: URL) {
        imageView.kf.setImage(with: url)
    }
}

extension ProfileViewController {
    private func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены что хотите выйти?",
            preferredStyle: .alert
        )
        
        let yesAction = UIAlertAction(
            title: "Да",
            style: .default) { _ in
                alert.dismiss(animated: true)
                self.presenter?.logout()
                
                guard let window = UIApplication.shared.windows.first else {
                    assertionFailure("confirmExit Invalid Configuration")
                    return
                }
                window.rootViewController = SplashViewController()
            }
        
        let noAction = UIAlertAction(
            title: "Нет",
            style: .default) { _ in
                alert.dismiss(animated: true)
            }
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true)
    }
}

extension ProfileViewController {
    private func  setupView() {
        view.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        profileImageConfiguration()
        nameLableConfiguration()
        idLableConfiguration()
        statusLableConfiguration()
        buttonConfiguration()
    }
    
    private func profileImageConfiguration() {
        let profileImage = UIImage(named: "userPhoto")
        imageView = UIImageView(image: profileImage)
        imageView.tintColor = .gray
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.accessibilityIdentifier = "Avatar image"
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func nameLableConfiguration() {
        nameLabel.textColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: 235),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func idLableConfiguration() {
        idLable.textColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
        idLable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        idLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(idLable)
        NSLayoutConstraint.activate([
            idLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 99),
            idLable.heightAnchor.constraint(equalToConstant: 18),
            idLable.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            idLable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func statusLableConfiguration() {
        statusLable.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        idLable.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        statusLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLable)
        NSLayoutConstraint.activate([
            statusLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
            statusLable.heightAnchor.constraint(equalToConstant: 18),
            statusLable.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            statusLable.topAnchor.constraint(equalTo: idLable.bottomAnchor, constant: 8)
        ])
    }
    
    private func buttonConfiguration() {
        let exitButtonImage = UIImage(named: "Exit")
        guard let exitButtonImage else {return}
        button = UIButton.systemButton(
            with: exitButtonImage ,
            target: self,
            action: #selector(Self.didTapButton)
        )
        button.tintColor = #colorLiteral(red: 0.9771148562, green: 0.5101671815, blue: 0.4975126386, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "Logout button"
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24)
        ])
    }
}
