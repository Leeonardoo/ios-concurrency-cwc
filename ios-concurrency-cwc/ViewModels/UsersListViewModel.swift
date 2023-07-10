//
//  UsersListViewModel.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import Foundation

class UsersListViewModel: ObservableObject {
    
    @Published var users: [User] = []
    @Published var isLoading = false

    func fetchUsers() {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            apiService.getJSON { (result: Result<[User], APIError>) in
                defer {
                    DispatchQueue.main.async {
                        self.isLoading = false
                    }
                }
                
                switch result {
                    case .success(let users):
                        DispatchQueue.main.async {
                            self.users = users
                        }
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }
}

extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        self.init()
        if forPreview {
            self.users = User.mockUsers
        }
    }
}
