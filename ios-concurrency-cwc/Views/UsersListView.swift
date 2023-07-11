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
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                    }
                }
            )
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage ?? ""))
            })
            .navigationTitle("Users")
            .listStyle(.plain)
            .onAppear {
                Task {
                    await viewModel.fetchUsers()
                }
            }
        }
    }
}

#Preview {
    let viewModel = UsersListViewModel(forPreview: true)
    
    return UsersListView(viewModel: viewModel)
}
