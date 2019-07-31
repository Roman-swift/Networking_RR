//
//  NetworkManager.swift
//  Networking
//
//  Created by Viacheslav Bilyi on 7/22/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import Foundation

class NetworkManager {

	enum HTTPMethod: String {
		case POST
		case PUT
		case GET
		case DELETE
	}

	enum APIs: String {
		case posts
		case users
		case comments
	}

	private let baseURL = "http://jsonplaceholder.typicode.com/"

	func getAllPosts(_ complitionHandler: @escaping ([Post]) -> Void) {
		if let url = URL(string: baseURL + APIs.posts.rawValue) {
			URLSession.shared.dataTask(with: url) { (data, response, error) in

				if error != nil {
					print("error in request")
				} else {
					if let resp = response as? HTTPURLResponse, resp.statusCode == 200,
						let responseData = data {

						let posts = try? JSONDecoder().decode([Post].self, from: responseData)

						complitionHandler(posts ?? [])
					}
				}
            }.resume()
		}
	}

	func postCreatePost(_ post: Post, complitionHandler: @escaping (Post) -> Void) {

		let sendData = try? JSONEncoder().encode(post)

		guard let url = URL(string: baseURL + APIs.posts.rawValue),
		let data = sendData else { return }

		let request = MutableURLRequest(url: url)
		request.httpMethod = HTTPMethod.POST.rawValue
		request.httpBody = data
		request.setValue("\(data.count)", forHTTPHeaderField: "Content-Lengh")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")

		URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in

			if error != nil {
				print("error")
			} else if let resp = response as? HTTPURLResponse, resp.statusCode == 201, let responseData = data {

				if let responsePost = try? JSONDecoder().decode(Post.self, from: responseData) {
					complitionHandler(responsePost)
				}
			}
		}.resume()
	}

	func getPostsBy(userId: Int, complitionHandler: @escaping ([Post]) -> Void) {
		guard let url = URL(string: baseURL + APIs.posts.rawValue) else { return }

		var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
		components?.queryItems = [URLQueryItem(name: "userId", value: "\(userId)")]
		guard let queryURL = components?.url else { return }

		URLSession.shared.dataTask(with: queryURL) { (data, response, error) in

			if error != nil {
				print("error getPostsBy")
			} else if let resp = response as? HTTPURLResponse,
				resp.statusCode == 200, let reciveData = data {

				let posts = try? JSONDecoder().decode([Post].self, from: reciveData)
				complitionHandler(posts ?? [])
			}
		}.resume()
	}

    func getAllUsers(_ complitionHandler: @escaping ([User]) -> Void) {
            if let url = URL(string: baseURL + "users") {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print("error in request")
            } else {
                if let resp = response as? HTTPURLResponse,
                    resp.statusCode == 200,
                    let responseData = data {
                    let users = try? JSONDecoder().decode([User].self, from: responseData)
                    complitionHandler(users ?? [])
                    }
                }
            }.resume()
        }
    }
    
    func getCommentsForPost(_ postId: Int, _ completionHandler: @escaping ([Comment]) -> Void) {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/comments?postId=\(String(postId))") {
            print(url)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                } else {
                    if let resp = response as? HTTPURLResponse, (200..<300).contains(resp.statusCode), let responseData = data {
                        
                        print(responseData)
                        let comments = try? JSONDecoder().decode([Comment].self, from: responseData)
                        
                        completionHandler(comments ?? [])
                    } else {
                        print((200..<300).contains((response as! HTTPURLResponse).statusCode))
                    }
                }
            }.resume()
        }
    }
    
    func getPostsForUser(_ userId: Int, _ completionHandler: @escaping ([Post]) -> Void) {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/posts?userId=\(String(userId))") {
            print(url)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    
                } else {
                    if let resp = response as? HTTPURLResponse, (200..<300).contains(resp.statusCode), let responseData = data {
                        
                        print(responseData)
                        let posts = try? JSONDecoder().decode([Post].self, from: responseData)
                        
                        completionHandler(posts ?? [])
                    } else {
                        print((200..<300).contains((response as! HTTPURLResponse).statusCode))
                    }
                }
            }.resume()
        }
    }
    
    func removeUser (_ user: User, complitionHandler: @escaping (Bool) -> Void) {
        let sendData = try? JSONEncoder().encode(user)
        guard let url = URL(string: baseURL + APIs.users.rawValue + "/\(user.id)"),
            let data = sendData
            else {
                complitionHandler(false)
                return
        }
        
        
        let request = MutableURLRequest(url: url)
        request.httpMethod = HTTPMethod.DELETE.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Lengh")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print("error")
            } else if let resp = response as? HTTPURLResponse,
                resp.statusCode == 201 || resp.statusCode == 200 {
                complitionHandler(true)
            }
            }.resume()
    }
    
    func removePost (_ post: Post, complitionHandler: @escaping (Bool) -> Void) {
        let sendData = try? JSONEncoder().encode(post)
        guard let url = URL(string: baseURL + APIs.posts.rawValue + "/\(post.id)"),
            let data = sendData
            else {
                complitionHandler(false)
                return
        }
        
        let request = MutableURLRequest(url: url)
        request.httpMethod = HTTPMethod.DELETE.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Lengh")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print("error")
            } else if let resp = response as? HTTPURLResponse,
                resp.statusCode == 201 || resp.statusCode == 200 {
                complitionHandler(true)
            }
        }.resume()
    }
    
    func removeComment (_ comment: Comment, complitionHandler: @escaping (Bool) -> Void) {
        let sendData = try? JSONEncoder().encode(comment)
        guard let url = URL(string: baseURL + APIs.comments.rawValue + "/\(comment.id)"),
            let data = sendData
            else {
                complitionHandler(false)
                return
        }
        
        let request = MutableURLRequest(url: url)
        request.httpMethod = HTTPMethod.DELETE.rawValue
        request.httpBody = data
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Lengh")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print("error")
            } else if let resp = response as? HTTPURLResponse,
                resp.statusCode == 201 || resp.statusCode == 200 {
                complitionHandler(true)
            }
        }.resume()
    }
}
