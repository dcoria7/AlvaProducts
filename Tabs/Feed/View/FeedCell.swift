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
//    let user: User?
    let onLikeTapped: () -> Void
    
    var body: some View {
        VStack {
            
			// post image
			KFImage(URL(string: post.imageUrl)!)
				.placeholder {
					ProgressView()
						.frame(width: 100)
						.tint(.white)
				}
				.resizable()
				.scaledToFill()
				.frame(height: 550) // Set the frame size
				.clipped() // Crop the image to the frame size
				.clipShape(Rectangle())
			
			NavigationLink(value: post) {
				// caption label
				HStack {
					if let venue = post.venue {
						CircularUsersImageView(post: post, size: .xSmall)
						VStack(alignment: .leading) {
							Text(venue.title)
								.foregroundStyle(.white)
								.font(.title3)
								.fontWeight(.bold)
							
							Text(post.caption)
								.foregroundStyle(.white)
								.font(.footnote)
								.frame(maxWidth: .infinity, alignment: .leading)
								.padding(.top, 1)
						}
					}
					Spacer()
				}
				.padding(.leading, 10)
			}
			.navigationDestination(for: Post.self) { post in
				VenueDetailView(userId: post.venue?.userId ?? "", venue: post.venue!) // TODO: use coordinator instead
			}
			
			
            
            Text(post.timestamp.dateValue().elapsedTime())
				.foregroundStyle(.white) // TODO: make a modifier text
				.font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
				.foregroundColor(.white.opacity(0.4))
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
        FeedCell(post: Post.mockPosts[1]) {
            print("On Like Tapped")
        }
    }
}
