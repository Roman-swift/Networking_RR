//
//  Comment.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import Foundation

class Comment: Codable {
    var postId: Int
    var id: Int
    var name: String
    var email: String
    var body: String
    
    init(id: Int, name: String, email: String, body: String) {
        self.postId = 0
        self.id = id
        self.name = name
        self.email = email
        self.body = body
    }
}
