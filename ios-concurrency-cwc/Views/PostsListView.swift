//
//  PostsListView.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import SwiftUI

struct PostsListView: View {
    
    @StateObject var viewModel = PostsListViewModel()
    var userId: Int?
    
    var body: some View {
            List {
                ForEach(viewModel.posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        
                        Text(post.body)
                            .font(.callout)
                            .foregroundStyle(.secondary)
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
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
            .task {
                viewModel.userId = userId
                await viewModel.fetchPosts()
            }
        }
}

#Preview {
    let viewModel = PostsListViewModel(forPreview: true)
    
    return NavigationView {
        PostsListView(viewModel: viewModel, userId: 1)
    }
}
