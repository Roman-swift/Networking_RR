//
//  CommentsTableViewCell.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    private var comment: Comment?
    
    func configure(comment: Comment) {
        DispatchQueue.main.async {
        self.myView.layer.cornerRadius = 15
        self.myView.layer.masksToBounds = false
        self.myView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.myView.layer.shadowColor = UIColor.black.cgColor
        self.myView.layer.shadowOpacity = 0.23
        self.myView.layer.shadowRadius = 5
            
        self.comment = comment
        self.nameLabel.text = comment.name
        self.emailLabel.text = comment.email
        self.bodyLabel.text = comment.body
            
        }
    }
}
