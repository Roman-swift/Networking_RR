//
//  CommentsTableViewCell.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    private var comment: Comment?
    
    func configure(comment: Comment) {
        self.comment = comment
        self.nameLabel.text = comment.name
        self.emailLabel.text = comment.email
        self.bodyLabel.text = comment.body
    }
}
