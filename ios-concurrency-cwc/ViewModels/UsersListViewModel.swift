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
    @Published var errorMessage: String? = nil
    @Published var showAlert = false
    
    @MainActor
    func fetchUsers() async {
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        isLoading = true
        
        do {
            users = try await apiService.getJSON()
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
            self.users = User.mockUsers
        }
    }
}
