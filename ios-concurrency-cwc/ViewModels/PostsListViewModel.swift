//
//  PostsListViewModel.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import Foundation

class PostsListViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAlert = false
    
    var userId: Int?
    
    @MainActor
    func fetchPosts() async {
        if let userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading = true
            
            do {
                posts = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
    }
}

extension PostsListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.posts = Post.mockSingleUsersPostsArray
        }
    }
}
