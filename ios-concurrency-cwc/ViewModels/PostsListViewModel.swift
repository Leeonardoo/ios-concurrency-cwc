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
    
    func fetchPosts() {
        if let userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                apiService.getJSON { (result: Result<[Post], APIError>) in
                    defer {
                        self.isLoading = false
                    }
                    
                    switch result {
                        case .success(let posts):
                            self.posts = posts
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription + "\nPlease contact the developer and provide this error and the steps to reproduce"
                            self.showAlert = true
                    }
                }
            }
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
