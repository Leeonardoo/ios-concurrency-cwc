//
//  User.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import Foundation

// Source: https://jsonplaceholder.typicode.com/users
struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
}
