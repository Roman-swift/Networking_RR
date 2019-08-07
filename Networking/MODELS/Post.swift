//
//  Post.swift
//  Networking
//
//  Created by Viacheslav Bilyi on 7/22/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import Foundation

class Post: Codable {
    var userId: Int
    var id: Int
    let title: String
    let body: String
    
    init(id: Int, title: String, body: String) {
        self.title = title
        self.body = body
        self.userId = 0
        self.id = id
    }
}
