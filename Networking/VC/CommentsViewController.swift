//
//  CommentsViewController.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    @IBOutlet weak var commentsTableView: UITableView!{
        didSet {
            commentsTableView.dataSource = self
            commentsTableView.delegate = self
            let nib = UINib(nibName: "CommentsTableViewCell", bundle: nil)
            commentsTableView.register(nib, forCellReuseIdentifier: "CommentCellID")
        }
    }
    
    private var post: Post?
    private var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Comments"
        
        if let myPost = post {
            NetworkManager().getCommentsForPost(myPost.id) { (comments) in
                self.comments = comments
                DispatchQueue.main.async {
                    self.commentsTableView.reloadData()
                }
            }
        }
    }
        func configure(_ post: Post) {
            self.post = post
    }
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentsTableView.dequeueReusableCell(withIdentifier: "CommentCellID", for: indexPath) as! CommentsTableViewCell
        cell.configure(comment: comments[indexPath.row])
        
        return cell
    }
}
