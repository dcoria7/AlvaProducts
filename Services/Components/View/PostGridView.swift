//
//  PostGridView.swift
//
//

import Kingfisher
import SwiftUI

struct PostGridView: View {
    let posts: [Post]
	var coordinator: AppCoordinator
	
    var body: some View {
		
		ScrollView(.horizontal){
			LazyHStack {
				ForEach(posts) { post in
					NavigationLink {
						SinglePostView(postId: post.id, coordinator: coordinator)
					} label: {
						KFImage(URL(string: post.imageUrl))
							.placeholder({ _ in
								ProgressView()
									.frame(width: 100)
									.tint(.green())
							})
							.resizable()
							.scaledToFill()
							.frame(width: 150, height: 100, alignment: .center)
							.clipped()
					}
					.padding(.leading, 10)
				}
			}
		}
		.frame(height: 100)
    }
}

struct PostGridView_Previews: PreviewProvider {
    static var previews: some View {
		PostGridView(posts: Post.mockPosts, coordinator: AppCoordinator())
    }
}
