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
    var networkManager = NetworkManager()
    private var comments: [Comment] = []
    var refreshControl = UIRefreshControl()

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
        
        refreshControl.addTarget(self, action: #selector(refresh), for:.valueChanged)
        self.commentsTableView.addSubview(refreshControl)
    }
    
    func removeComment (_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.comments.remove(at: indexPath.row)
            self.commentsTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
        func configure(_ post: Post) {
            self.post = post
    }
    
    @objc func refresh(_ sender: Any) {
        if let myPost = post {
            NetworkManager().getCommentsForPost(myPost.id) { (comments) in
                self.comments = comments
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.commentsTableView.reloadData()
                }
            }
        }
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, indexPath in
            let currentComment = self.comments[indexPath.row]
            
            self.networkManager.removeComment(currentComment) { _ in
                self.removeComment(indexPath)
            }
        }
        
        return [remove]
    }
}
