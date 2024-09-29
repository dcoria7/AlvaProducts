//
//  FeedCell.swift
//  InstaSwift
//
//  Created by Bruno Rangel on 02/06/23.
//

import Firebase
import Kingfisher
import SwiftUI

struct FeedCell: View {
    let post: Post
    let user: User?
    let onLikeTapped: () -> Void
    
    var body: some View {
        VStack {
            
//            HStack {
//                if let venue = post.venue {
//                    CircularUsersImageView(post: post, size: .xSmall)
//                    Text(venue.title)
//                        .font(.footnote)
//                        .fontWeight(.semibold)
//                }
//                Spacer()
//            }
//            .padding(.leading, 10)

			// post image
			KFImage(URL(string: post.imageUrl)!)
				.placeholder {
					ProgressView()
						.frame(width: 100)
				}
				.resizable()
				.aspectRatio(contentMode: .fit)
				.clipShape(Rectangle())
            
            // action buttons
//            HStack(spacing: 16) {
//                Button {
//                    onLikeTapped()
//                } label: {
//                    if let user {
//                        Image(systemName: "heart")
//                            .imageScale(.large)
//                            .symbolVariant(post.liked?.contains(user.id) ?? false ? .fill : .none)
//                            .foregroundColor(post.liked?.contains(user.id) ?? false ? Color(.systemRed) : .primary)
//                    }
//                }
//                Button {
//                    print("Comment post")
//
//                } label: {
//                    Image(systemName: "bubble.right")
//                        .imageScale(.large)
//                }
//                Button {
//                    print("Share post")
//
//                } label: {
//                    Image(systemName: "paperplane")
//                        .imageScale(.large)
//                }
//                Spacer()
//            }
//            .padding(.leading, 10)
//            .padding(.top, 4)
//            .foregroundColor(.primary)

            // likes label
//            Text("\(post.likes) likes")
//                .font(.footnote)
//                .fontWeight(.semibold)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.leading, 10)
//                .padding(.top, 1)
            // caption label
            HStack {
				if let venue = post.venue {
					CircularUsersImageView(post: post, size: .xSmall)
					VStack(alignment: .leading) {
						Text(venue.title)
							.font(.footnote)
							.fontWeight(.semibold)
						
						Text(post.caption)
							.font(.footnote)
							.frame(maxWidth: .infinity, alignment: .leading)
							.padding(.top, 1)
					}
				}
				Spacer()
            }
			.padding(.leading, 10)
			
            
            Text(post.timestamp.dateValue().elapsedTime())
				.font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(.black.opacity(0.6))
                .padding(.leading, 10)
                .padding(.top, 1)
        }
    }
						 
	@ViewBuilder
	private func makeShareIcon() -> some View {
		Button {
			print("Share post")
			
		} label: {
			Image(systemName: "paperplane")
				.resizable()
				.frame(width: 50, height: 50)
				.padding()
				.background(Color.blue)
				.foregroundColor(.black)
				.clipShape(Circle())
		}
		
		
		Circle()
			.foregroundColor(.red)
			.frame(width: 20, height: 20)
	}
}

struct FeedCell_Previews: PreviewProvider {
    static var previews: some View {
        FeedCell(post: Post.mockPosts[1], user: User.mockUsers[1]) {
            print("On Like Tapped")
        }
    }
}
