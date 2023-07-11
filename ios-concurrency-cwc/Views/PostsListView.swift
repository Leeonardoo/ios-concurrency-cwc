//
//  PostsListView.swift
//  ios-concurrency-cwc
//
//  Created by Leonardo de Oliveira on 09/07/23.
//

import SwiftUI

struct PostsListView: View {
    
    var posts: [Post]
    
    var body: some View {
            List {
                ForEach(posts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        
                        Text(post.body)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Posts")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
        }
}

//#Preview {
//    let viewModel = PostsListViewModel(forPreview: true)
//    
//    return NavigationView {
//        PostsListView(viewModel: viewModel, userId: 1)
//    }
//}
