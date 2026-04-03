//
//  SinglePostView.swift
//  ClickLocal
//
//  Created by Daniel Coria on 04/04/24.
//

import SwiftUI

struct SinglePostView: View {
    @StateObject var viewModel = SinglePostViewModel()
    @EnvironmentObject var contentViewModel: ContentViewModel
    let postId: String
	var coordinator: AppCoordinator

    var body: some View {
        VStack {
            if let post = viewModel.post {
				FeedCell(post: post) {
					coordinator.goToVenueDetail(userID: post.venue?.userId ?? "", venue: post.venue!)
//                    Task {
//                        try await viewModel.toggleLike(uid: contentViewModel.currentUser!.id)
//                    }
                }
                Spacer()
            } else {
                ProgressView()
            }
        }
		.setDefaultBackgroundColor()
        .onAppear {
            Task {
                try await viewModel.fetchPostData(postId: postId)
            }
        }
    }
}

//struct SinglePostView_Previews: PreviewProvider {
//    static var previews: some View {
//		SinglePostView(postId: Post.mockPosts[0].id, coordinator: AppCoordinator())
//    }
//}
