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
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var post: Post?
    var networkManager = NetworkManager()
    private var comments: [Comment] = []
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Comments"
    
        if Connectivity.isConnectedToInternet() {
        activityIndicator.startAnimating()
        if let myPost = post {
            NetworkManager().getCommentsForPost(myPost.id) { (comments) in
                self.comments = comments
                DispatchQueue.main.async {
                    self.commentsTableView.reloadData()
                   self.activityIndicator.stopAnimating()
                }
            }
        }
        }else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                let alert = UIAlertController(title: "No internet connection", message: "Please, check your connection to Internet.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for:.valueChanged)
        self.commentsTableView.addSubview(refreshControl)
    }
    
    func saveNewComment (_ comment: Comment) {
        self.comments.append(comment)
        DispatchQueue.main.async {
            self.commentsTableView.reloadData()
        }
    }
    
    func updateCurrentComment (_ comment: Comment) {
        if let index = comments.firstIndex(where: {$0.id == comment.id}) {
            self.comments[index] = comment
            DispatchQueue.main.async {
                self.commentsTableView.reloadData()
            }
        }
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

@IBAction func  didTapAddCommentButton(_ sender: UIBarButtonItem) {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCommentScreenVCID") as! AddCommentTableViewController
    vc.delegate = self
    self.show(vc, sender: self)
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
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddCommentScreenVCID") as! AddCommentTableViewController
            let currentComment = self.comments[indexPath.row]
            vc.delegate = self
            vc.configure(currentComment)
            self.show(vc, sender: self)
        }
        edit.backgroundColor = .blue
        return [remove,edit]
    }
}

extension CommentsViewController: AddCommentTableViewControllerDelegate {
    func createOrUpdateComment(_ comment: Comment) {
        
        if comments.contains(where: {$0.id == comment.id}){
            updateCurrentComment(comment)
        } else {
            saveNewComment(comment)
        }
    }
}
