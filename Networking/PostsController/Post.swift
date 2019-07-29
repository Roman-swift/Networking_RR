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
	var title: String
	var body: String

	init(userId: Int, title: String, body: String) {
		self.title = title
		self.body = body
		self.userId = userId
		self.id = 101
	}
}
