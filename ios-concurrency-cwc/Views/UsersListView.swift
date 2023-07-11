//
//  UsersListView.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import SwiftUI

struct UsersListView: View {
    
    @StateObject var viewModel = UsersListViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.usersAndPosts) { userAndPosts in
                    NavigationLink {
                        PostsListView(posts: userAndPosts.posts)
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(userAndPosts.user.name)
                                    .font(.title)
                                
                                Spacer()
                                
                                Text("(\(userAndPosts.posts.count))")
                            }
                            
                            Text(userAndPosts.user.email)
                        }
                    }
                }
            }
            .overlay(content: {
                if viewModel.isLoading {
                    ProgressView()
                }
            })
            .alert("Error", isPresented: $viewModel.showAlert, actions: {
                Button("OK") {}
            }, message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .task {
                await viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    let viewModel = UsersListViewModel(forPreview: true)
    
    return UsersListView(viewModel: viewModel)
}
