//
//  PostDetailsViewController.swift
//  ExampleMVVM
//
//  Created by Olya Yeritspokhyan on 29.01.23.
//

import UIKit

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    private var post: PostItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }
    
    func configure(post: PostItem) {
        self.post = post
    }
        
    func setUpUI() {
        guard let post = post else { return }
        if let image = URL(string: post.imageURL) {
            postImage.load(url: image)
        }
        sizeLabel.text = "Size: " + String(post.size)
        tagLabel.text = "Tags: " + post.tags
        typeLabel.text = "Type: " + post.type
        
        ownerLabel.text = "Owner: " + post.userName
        downloadsLabel.text = "Downloads: " + String(post.numberOfDownloads)
        commentsLabel.text = "Comments: " + String(post.numberOfComments)
        likesLabel.text = "Likes: " + String(post.numberOfLikes)
        viewsLabel.text = "Views: " + String(post.numberOfViews)
    }
}
