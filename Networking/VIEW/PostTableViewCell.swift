//
//  PostTableViewCell.swift
//  Networking
//
//  Created by Viacheslav Bilyi on 7/25/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var postTitleLabel: UILabel!
	@IBOutlet weak var postBodyLable: UILabel!

    private var post: Post?

	func configure(_ post: Post) {
        DispatchQueue.main.async {
            self.myView.layer.cornerRadius = 15
            self.myView.layer.masksToBounds = false
            self.myView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.myView.layer.shadowColor = UIColor.black.cgColor
            self.myView.layer.shadowOpacity = 0.23
            self.myView.layer.shadowRadius = 5
            
            self.post = post
            self.postTitleLabel.text = post.title
            self.postBodyLable.text = post.body
        }
	}
    
}
