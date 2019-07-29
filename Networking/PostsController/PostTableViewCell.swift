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

	func configure(_ post: Post) {
		postTitleLabel.text = post.title
		postBodyLable.text = post.body
	}
    
}
