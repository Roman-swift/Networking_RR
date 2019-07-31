//
//  PostTableViewCell.swift
//  Networking
//
//  Created by Viacheslav Bilyi on 7/25/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

	@IBOutlet weak var postTitleLabel: UILabel!
	@IBOutlet weak var postBodyLable: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var post: Post?


	func configure(_ post: Post) {
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.post = post
            self.postTitleLabel.text = post.title
            self.postBodyLable.text = post.body
            self.activityIndicator.stopAnimating()
        }
	}
    
}
