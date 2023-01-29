//
//  FeedCollectionViewCell.swift
//  ExampleMVVM
//
//  Created by Olya Yeritspokhyan on 29.01.23.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var feedImageView: UIImageView!
    @IBOutlet private var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(imageURL: String, userImageURL: String) {
        if let image = URL(string: imageURL) {
            feedImageView.load(url: image)
        }
        
        if let userImage = URL(string: userImageURL) {
            userImageView.load(url: userImage)
        }
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
