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
    
    var userId: Int?
    
    func fetchPosts() {
        if let userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            isLoading = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                apiService.getJSON { (result: Result<[Post], APIError>) in
                    defer {
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                    }
                    
                    switch result {
                        case .success(let posts):
                            DispatchQueue.main.async {
                                self.posts = posts
                            }
                        case .failure(let error):
                            print(error)
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
