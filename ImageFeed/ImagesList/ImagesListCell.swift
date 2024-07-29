//
//  File.swift
//  ImageFeed
//
//  Created by Дмитрий Жуков on 3/3/24.
//

import Kingfisher
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dataLable: UILabel!
    @IBOutlet private var gradientCell: GradientView!
    
    @IBAction private func likeButtonClicked(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageCell.kf.cancelDownloadTask()
    }
    
    func setImageCell(image: UIImage,
                      date: String,
                      isLiked: Bool){
        imageCell.image = image
        dataLable.text = date
        setImageLike(isLiked: isLiked)
    }
    
    func setImageLike(isLiked: Bool) {
        guard let imageLike = UIImage(named: isLiked ? "like_button_on" : "like_button_off") else { return }
        likeButton.setImage(imageLike, for: .normal)
    }
    
    func setDelegate(_ delegate: ImagesListCellDelegate) {
        self.delegate = delegate
    }
}
