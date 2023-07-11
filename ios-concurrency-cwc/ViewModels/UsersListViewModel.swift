//
//  UsersListViewModel.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var usersAndPosts: [UserAndPosts] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAlert = false
    
    @MainActor
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        let apiService2 = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        isLoading = true
        
        do {
            async let users: [User] = try await apiService.getJSON()
            async let posts: [Post] = try await apiService2.getJSON()
            
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
            
            for user in fetchedUsers {
                let userPosts = fetchedPosts.filter { $0.userId == user.id }
                let newUserAndPosts = UserAndPosts(user: user, posts: userPosts)
                usersAndPosts.append(newUserAndPosts)
            }
        } catch {
            showAlert = true
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.usersAndPosts = UserAndPosts.mockUsersAndPosts
        }
    }
}
