//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/14/24.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var label1: UILabel?
    private var label2: UILabel?
    private var label3: UILabel?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
            let profileImage = UIImage(named: "userPhoto")
            let imageView = UIImageView(image: profileImage)
            imageView.tintColor = .gray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 70),
                imageView.heightAnchor.constraint(equalToConstant: 70),
                imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
            ])
           
            
            let nameLabel = UILabel()
            nameLabel.text = "Екатерина Новикова"
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
            
            let idLable = UILabel()
            idLable.text = "@ekaterina_nov"
            idLable.textColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
            idLable.font = UIFont(name: "system", size: 13)
            idLable.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(idLable)
            NSLayoutConstraint.activate([
                idLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 99),
                idLable.heightAnchor.constraint(equalToConstant: 18),
                idLable.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                idLable.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
            ])
            
            let statusLable = UILabel()
            statusLable.text = "Hello, world!"
            statusLable.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            statusLable.font = UIFont(name: "system", size: 13)
            statusLable.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(statusLable)
            NSLayoutConstraint.activate([
                statusLable.widthAnchor.constraint(greaterThanOrEqualToConstant: 77),
                statusLable.heightAnchor.constraint(equalToConstant: 18),
                statusLable.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
                statusLable.topAnchor.constraint(equalTo: idLable.bottomAnchor, constant: 8)
            ])
        
            self.label1 = nameLabel
            self.label2 = idLable
            self.label3 = statusLable
            
            let button = UIButton.systemButton(
                with: UIImage(named: "Exit")!,
                target: self,
                action: #selector(Self.didTapButton)
            )
            button.tintColor = #colorLiteral(red: 0.9771148562, green: 0.5101671815, blue: 0.4975126386, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24),
            button.heightAnchor.constraint(equalToConstant: 24),
            button.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 327),
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 16),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
            ])
        }
        
        @objc
        private func didTapButton() {
            for view in view.subviews {
                if view is UILabel {
                    view.removeFromSuperview()
                }
            }
        }
}
/*
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var extitButton: UIButton!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var idLable: UILabel!
    @IBOutlet weak var statusLable: UILabel!
    @IBAction func didTupExitButton(_ sender: Any) {
    }
  */
    
 

        // Do any additional setup after loading the view.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


