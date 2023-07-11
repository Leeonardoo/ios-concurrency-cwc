//
//  UserAndPosts.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 10/07/23.
//

import Foundation

struct UserAndPosts: Identifiable {
    var id = UUID()
    let user: User
    let posts: [Post]
}
