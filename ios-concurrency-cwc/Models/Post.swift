//
//  Post.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/posts
// Single User's posts: https://jsonplaceholder.typicode.com/users/:id/posts
struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
